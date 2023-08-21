#!groovy
@Library('gsdk-shared-lib@master')
import groovy.json.JsonSlurper
properties([
    disableConcurrentBuilds(),
    parameters([
        // Allows the building of additional binaries with different software version for OTA automation
        booleanParam(name: 'OTA_AUTOMATION_TEST', defaultValue: false, description: 'Set to true to generate additional SQA images for ota testing'),
        // Allows the building of unify components in matter 
        booleanParam(name: 'BUILD_UNIFY_MATTER', defaultValue: false, description: 'Set to true to build and generate unify matter artifacts (UMB and UMPC)'),
        // Allows the building of additional binaries with different software version for ECOSYSTEM automation
        booleanParam(name: 'ECOSYSTEM_AUTOMATION_TEST', defaultValue: false, description: 'Set to true to generate additional SQA images for ecosystem testing')
    ])
])

buildOverlayDir = ''
//TO DO, this is for SQA UTF testing, this value should get from db or somewhere instead of hardcoded
RELEASE_NAME='22Q4-GA'
stashFolder = ''
chiptoolPath = ''
bootloaderPath = ''
buildFarmLabel = 'Build-Farm'
buildFarmLargeLabel = 'Build-Farm-Large'
chipBuildEfr32Image = "artifactory.silabs.net/gsdk-dockerhub-proxy/connectedhomeip/chip-build-efr32:0.5.64"
saved_workspace = 'saved_workspace'
software_version = 'sl_matter_version_str=\\"2\\" sl_matter_version=2'
commanderImage = "artifactory.silabs.net/gsdk-docker-production/sqa-testnode-lite:latest"

secrets = [[path: 'teams/gecko-sdk/app/svc_gsdk', engineVersion: 2,
            secretValues: [[envVar: 'SL_PASSWORD', vaultKey: 'password'],
                           [envVar: 'SL_USERNAME', vaultKey: 'username']]]]
// helpers
def initWorkspaceAndScm()
{
    buildOverlayDir = sh( script: '/srv/jenkins/createSuperOverlay.sh '+
                                  'createbuildoverlay '+
                                  '/srv/workspaces '+
                                  '/srv/jenkins/reference',
                                  returnStdout: true ).trim()
    echo "Build overlay directory: ${buildOverlayDir}"

    // Get pipeline metadata
    dir(buildOverlayDir+createWorkspaceOverlay.overlayMatterPath)
    {
        checkout scm: [$class                     : 'GitSCM',
                 branches                         : scm.branches,
                 browser: [$class: 'Stash',
                            repoUrl: 'https://stash.silabs.com/projects/WMN_TOOLS/repos/matter/'],
                 doGenerateSubmoduleConfigurations: scm.doGenerateSubmoduleConfigurations,
                 extensions                       : scm.extensions << [$class: 'ScmName', name: 'matter'],
                 userRemoteConfigs                : scm.userRemoteConfigs]

        // Switch Origin for the gecko_sdk to reduce dowload and cost
        sh 'git --version'
        sh 'git submodule update --init third_party/openthread/ot-efr32/'
        sh 'cd ./third_party/openthread/ot-efr32'
        sh 'git submodule set-url ./third_party/silabs/gecko_sdk https://stash.silabs.com/scm/embsw/gecko_sdk_release.git'
        sh 'cd ../../../'
        sh 'git submodule set-url ./third_party/silabs/gecko_sdk https://stash.silabs.com/scm/embsw/gecko_sdk_release.git'

        // Matter Init --Checkout relevant submodule
        sh 'scripts/checkout_submodules.py --shallow --recursive --platform efr32 linux'

    }

    dir(buildOverlayDir+'/matter-scripts'){
        checkout scm: [$class                     : 'GitSCM',
                 branches                         : [[name: 'master']],
                 browser                          : [$class: 'Stash',
                                                     repoUrl: 'https://stash.silabs.com/scm/wmn_sqa/matter-scripts/'],
                //  extensions                       : [$class: 'ScmName', name: 'matter-scripts'],
                 userRemoteConfigs                : [[credentialsId: 'svc_gsdk',
                                                      url: 'https://stash.silabs.com/scm/wmn_sqa/matter-scripts.git']]]
    }

    dir(buildOverlayDir+'/sqa-tools'){
        checkout scm: [$class                     : 'GitSCM',
                 branches                         : [[name: 'master']],
                 browser                          : [$class: 'Stash',
                                                     repoUrl: 'https://stash.silabs.com/scm/wmn_sqa/sqa-tools/'],
                //  extensions                       : [$class: 'ScmName', name: 'sqa-tools'],
                 userRemoteConfigs                : [[credentialsId: 'svc_gsdk',
                                                      url: 'https://stash.silabs.com/scm/wmn_sqa/sqa-tools.git']]]
    }
    dir(buildOverlayDir+"/overlay/unify"){
        checkout scm: [$class: 'GitSCM',
                 branches:   [[name: 'release/23q2']],
                 extensions: [[$class: 'CloneOption', depth: 1, noTags: false, reference: '', shallow: true],
                                [$class: 'SubmoduleOption', disableSubmodules: false, parentCredentials: true,
                                recursiveSubmodules: true, reference: '', shallow: true, trackingSubmodules: false]],
                    userRemoteConfigs: [[credentialsId: 'svc_gsdk', url: 'https://stash.silabs.com/scm/uic/uic.git']]]
    }
    dir(buildOverlayDir+createWorkspaceOverlay.overlayPrebuiltZapPath){
        packageManagers.downloadLatestZapBuild('pipelineMetadata.toolchain_info.zap.zapBranch')
    }
}

def runInWorkspace(Map args, Closure cl)
{
    return {
        actionWithRetry {
            label = args.label ?: buildFarmLabel
            node(label) {
                def workspaceTmpDir = createWorkspaceOverlay(advanceStageMarker.getBuildStagesList(),
                                                             buildOverlayDir)
                def filterPattern = args.saveFilter == 'NONE' ? '-name "no-files"' : args.saveFilter

                def dirPath = workspaceTmpDir + (args.wsPath ?: createWorkspaceOverlay.overlayMatterPath)
                def saveDir = args.savePath ?: 'matter/'
                dir(dirPath) {
                    // pass environment in as arg if possible...
                    def env = ['BASIC_ENV=1']
                    withEnv(env) {
                        sh 'printenv | sort'
                        try {
                            cl()
                        } catch (e) {
                            deactivateWorkspaceOverlay(advanceStageMarker.getBuildStagesList(),
                                                       workspaceTmpDir,
                                                       saveDir,
                                                       '-name no-files')
                            throw e
                        }
                    }
                }
                if (filterPattern != null) {
                    // use a custom filter (including an empty '')
                    deactivateWorkspaceOverlay(advanceStageMarker.getBuildStagesList(),
                                             workspaceTmpDir,
                                             saveDir, filterPattern)
                } else {
                    deactivateWorkspaceOverlay(advanceStageMarker.getBuildStagesList(), workspaceTmpDir)
                }
            }
        }
    }
}

def buildOpenThreadExample(app, ota_automation=false, ecosystem_automation=false, config_args='')
{
    actionWithRetry {
        node(buildFarmLargeLabel)
        {
            def workspaceTmpDir = createWorkspaceOverlay(advanceStageMarker.getBuildStagesList(),
                                                            buildOverlayDir)
            def dirPath = workspaceTmpDir + createWorkspaceOverlay.overlayMatterPath
            def saveDir = 'matter/'
            def out_dir = saved_workspace
            def buildRelease = true
            def openThreadBoards = [:]
            def sleepyBoard = ["BRD4161A", "BRD4187C"]
            def lowPowerBoard = ["BRD4186C"]
            // Boards for Code Size report
            def codeSizeBoard = ["BRD4187C", "BRD4325B"]

            // Remove -app at end of string for later use (if it exists)
            def appNameOnly = app - '-app'

            withDockerRegistry([url: "https://artifactory.silabs.net ", credentialsId: 'svc_gsdk']){
                sh "docker pull $chipBuildEfr32Image"
            }
            // Build only for release candidate branch
            if (ota_automation) {
                openThreadBoards = ["BRD4161A", "BRD4187C"]
                sleepyBoard = [:]
                buildRelease = false
            }
            if (ecosystem_automation) {
                openThreadBoards = ["BRD4187C"]
                sleepyBoard = [:]
                buildRelease = false
            }
            else if (env.BRANCH_NAME.startsWith('RC_')) {
                // TODO MATTER-1900
                openThreadBoards = ["BRD4161A", "BRD4162A", "BRD4163A", "BRD4164A", "BRD4166A", "BRD4186C", "BRD4187C", "BRD2703A", "BRD2601B", "BRD4316A", "BRD4317A"]
            } else {
                // TODO MATTER-1900
                openThreadBoards = ["BRD4161A", "BRD4166A", "BRD4186C", "BRD4187C", "BRD2703A","BRD4316A" ]

            }

            dir(dirPath) {
                try {
                    withDockerContainer(image: chipBuildEfr32Image, args: "-u root")
                    {
                        // CSA Examples build
                        withEnv(['PW_ENVIRONMENT_ROOT='+dirPath])
                        {
                            openThreadBoards.each { board ->

                                if(ota_automation){
                                    // Move binaries to standardized output
                                    sh """ ./scripts/examples/gn_silabs_example.sh ./examples/${app}/silabs ./out/OTA/ota_automation_out/${app}/OpenThread/ ${board} ${config_args} chip_build_libshell=true
                                            mkdir -p ${saved_workspace}/out/OTA/ota_automation_out/${app}/OpenThread/${board}
                                            cp ./out/OTA/ota_automation_out/${app}/OpenThread/${board}/*.s37 ${saved_workspace}/out/OTA/ota_automation_out/${app}/OpenThread/${board}/"""
                                }
                                else if(ecosystem_automation){
                                    // Move binaries to standardized output
                                    sh """./scripts/examples/gn_silabs_example.sh ./examples/${app}/silabs ./out/ECOSYSTEM/ecosystem_automation_out/${app}/OpenThread/ ${board} 'import("//with_pw_rpc.gni")'
                                           mkdir -p ${saved_workspace}/out/ECOSYSTEM/ecosystem_automation_out/${app}/OpenThread/${board}
                                           cp ./out/ECOSYSTEM/ecosystem_automation_out/${app}/OpenThread/${board}/*.s37 ${saved_workspace}/out/ECOSYSTEM/ecosystem_automation_out/${app}/OpenThread/${board}/"""
                                }
                                else{
                                    
                                        // Enable matter shell with chip_build_libshell=true argument for SQA tests
                                        sh """./scripts/examples/gn_silabs_example.sh ./examples/${app}/silabs ./out/CSA/${app}/OpenThread/standard ${board} chip_build_libshell=true
                                                mkdir -p ${saved_workspace}/out/standard/${board}/OpenThread
                                                cp ./out/CSA/${app}/OpenThread/standard/${board}/*.s37 ${saved_workspace}/out/standard/${board}/OpenThread/
                                                cp ./out/CSA/${app}/OpenThread/standard/${board}/*.map ${saved_workspace}/out/standard/${board}/OpenThread/
                                        """

                                        if(buildRelease) {
                                            if (codeSizeBoard.contains(board)) {
                                                sh """./scripts/examples/gn_silabs_example.sh ./examples/${app}/silabs ./out/CSA/${app}/OpenThread/release ${board} --release --use_ot_lib
                                                    mkdir -p ${saved_workspace}/out/release/${board}/OpenThread
                                                    cp ./out/CSA/${app}/OpenThread/release/${board}/*.s37 ${saved_workspace}/out/release/${board}/OpenThread/
                                                    cp ./out/CSA/${app}/OpenThread/release/${board}/*.map ${saved_workspace}/out/release/${board}/OpenThread/
                                                """
                                            }
                                        }

                                        if(sleepyBoard.contains(board)) {
                                            // Builds --icd examples
                                            sh """./scripts/examples/gn_silabs_example.sh ./examples/${app}/silabs ./out/CSA/${app}/OpenThread/sleepy ${board} --icd
                                                mkdir -p ${saved_workspace}/out/sleepy/${board}/OpenThread
                                                cp ./out/CSA/${app}/OpenThread/sleepy/${board}/*.s37 ${saved_workspace}/out/sleepy/${board}/OpenThread/
                                                cp ./out/CSA/${app}/OpenThread/sleepy/${board}/*.map ${saved_workspace}/out/sleepy/${board}/OpenThread/
                                            """
                                        }

                                        if(lowPowerBoard.contains(board)) {
                                            // Build BRD4186C with --icd and --low_power
                                            sh """./scripts/examples/gn_silabs_example.sh ./examples/${app}/silabs ./out/CSA/${app}/OpenThread/low_power_sleepy ${board} --icd --low-power
                                                mkdir -p ${saved_workspace}/out/low_power_sleepy/${board}/OpenThread
                                                cp ./out/CSA/${app}/OpenThread/low_power_sleepy/${board}/*.s37 ${saved_workspace}/out/low_power_sleepy/${board}/OpenThread/
                                                cp ./out/CSA/${app}/OpenThread/low_power_sleepy/${board}/*.map ${saved_workspace}/out/low_power_sleepy/${board}/OpenThread/
                                            """
                                        }

                                        stash name: 'OpenThreadExamples-'+app+'-'+board, includes: 'out/**/*.s37 '
                                }

                            }
                        }
                    }
                } catch (e) {
                    deactivateWorkspaceOverlay(advanceStageMarker.getBuildStagesList(),
                                                workspaceTmpDir,
                                                saveDir,
                                                '-name no-files')
                    throw e
                }
            }
            deactivateWorkspaceOverlay(advanceStageMarker.getBuildStagesList(),
                                       workspaceTmpDir,
                                       'matter/' + saved_workspace,
                                       '-name "*.s37" -o -name "*.map"')
        }
    }
}



def buildSilabsCustomOpenThreadExamples(app)
{
    actionWithRetry {
        node(buildFarmLargeLabel)
        {
            def workspaceTmpDir = createWorkspaceOverlay(advanceStageMarker.getBuildStagesList(),
                                                            buildOverlayDir)
            def dirPath = workspaceTmpDir + createWorkspaceOverlay.overlayMatterPath
            def saveDir = 'matter/'

            withDockerRegistry([url: "https://artifactory.silabs.net ", credentialsId: 'svc_gsdk']){
                sh "docker pull $chipBuildEfr32Image"
            }

            def boardsForCustomOpenThread = [:]

            if (env.BRANCH_NAME.startsWith('RC_')) {
                boardsForCustomOpenThread = ["BRD4161A", "BRD4186C", "BRD4187C", "BRD4166A"]
            } else {
                boardsForCustomOpenThread = ["BRD4161A", "BRD4186C", "BRD4166A"]
            }

            def appNameOnly = app - '-app'

            dir(dirPath) {
                try {
                    withDockerContainer(image: chipBuildEfr32Image, args: "-u root")
                    {
                        // Custom Silabs build
                        withEnv(['PW_ENVIRONMENT_ROOT='+dirPath])
                        {
                            boardsForCustomOpenThread.each { board ->
                                // Enable matter shell with chip_build_libshell=true argument for SQA tests
                                sh "./scripts/examples/gn_silabs_example.sh ./silabs_examples/${app} ./out/silabs/${app}/OpenThread/ ${board} chip_build_libshell=true"
                            }
                        }
                    }
                } catch (e) {
                    deactivateWorkspaceOverlay(advanceStageMarker.getBuildStagesList(),
                                                workspaceTmpDir,
                                                saveDir,
                                                '-name no-files')
                    throw e
                }
                // Move binaries to standardized output
                boardsForCustomOpenThread.each { board ->
                        sh """ mkdir -p ${saved_workspace}/out/standard/${board}/OpenThread
                               cp ./out/silabs/${app}/OpenThread/${board}/*.s37 ${saved_workspace}/out/standard/${board}/OpenThread/
                               cp ./out/silabs/${app}/OpenThread/${board}/*.map ${saved_workspace}/out/standard/${board}/OpenThread/ """
                }
                stash name: 'CustomOpenThreadExamples', includes:  'out/**/*.s37 '

            }
            deactivateWorkspaceOverlay(advanceStageMarker.getBuildStagesList(),
                                       workspaceTmpDir,
                                       'matter/' + saved_workspace,
                                       '-name "*.s37" -o -name "*.map"')
        }
    }
}

def buildSilabsSensorApp()
{
    actionWithRetry {
        node(buildFarmLargeLabel)
        {
            def workspaceTmpDir = createWorkspaceOverlay(advanceStageMarker.getBuildStagesList(),
                                                            buildOverlayDir)
            def dirPath = workspaceTmpDir + createWorkspaceOverlay.overlayMatterPath
            def saveDir = 'matter/'

            def boardsForCustomOpenThread = [:]

            if (env.BRANCH_NAME.startsWith('RC_')) {
                boardsForCustomOpenThread = ["BRD4161A", "BRD4186C", "BRD4187C", "BRD4166A"]
            } else {
                boardsForCustomOpenThread = ["BRD4161A", "BRD4186C", "BRD4166A"]
            }

            withDockerRegistry([url: "https://artifactory.silabs.net ", credentialsId: 'svc_gsdk']){
                    sh "docker pull $chipBuildEfr32Image"
                }

            dir(dirPath) {
                try {
                    withDockerContainer(image: chipBuildEfr32Image, args: "-u root")
                    {
                        // Custom Silabs build
                        withEnv(['PW_ENVIRONMENT_ROOT='+dirPath])
                        {

                            boardsForCustomOpenThread.each { board ->
                                sh """ ./scripts/examples/gn_silabs_example.sh ./silabs_examples/silabs-sensors ./out/silabs/silabs-sensors/occupancy/OpenThread ${board} \"is_occupancy_sensor=true\" chip_build_libshell=true
                                        mkdir -p ${saved_workspace}/out/standard/${board}/OpenThread/sensors/occupancy/
                                        cp ./out/silabs/silabs-sensors/occupancy/OpenThread/${board}/*.s37 ${saved_workspace}/out/standard/${board}/OpenThread/sensors/occupancy/
                                        cp ./out/silabs/silabs-sensors/occupancy/OpenThread/${board}/*.map ${saved_workspace}/out/standard/${board}/OpenThread/sensors/occupancy/
                                """

                                sh """ ./scripts/examples/gn_silabs_example.sh ./silabs_examples/silabs-sensors ./out/silabs/silabs-sensors/temperature/OpenThread ${board} \"is_temperature_sensor=true\" chip_build_libshell=true
                                        mkdir -p ${saved_workspace}/out/standard/${board}/OpenThread/sensors/temperature/
                                        cp ./out/silabs/silabs-sensors/temperature/OpenThread/${board}/*.s37 ${saved_workspace}/out/standard/${board}/OpenThread/sensors/temperature/
                                        cp ./out/silabs/silabs-sensors/temperature/OpenThread/${board}/*.map ${saved_workspace}/out/standard/${board}/OpenThread/sensors/temperature/
                                """

                                sh """ ./scripts/examples/gn_silabs_example.sh ./silabs_examples/silabs-sensors ./out/silabs/silabs-sensors/contact/OpenThread ${board} \"is_contact_sensor=true\" chip_build_libshell=true
                                        mkdir -p ${saved_workspace}/out/standard/${board}/OpenThread/sensors/contact/
                                        cp ./out/silabs/silabs-sensors/contact/OpenThread/${board}/*.s37 ${saved_workspace}/out/standard/${board}/OpenThread/sensors/contact/
                                        cp ./out/silabs/silabs-sensors/contact/OpenThread/${board}/*.map ${saved_workspace}/out/standard/${board}/OpenThread/sensors/contact/
                                """

                                sh """ ./scripts/examples/gn_silabs_example.sh ./silabs_examples/silabs-sensors ./out/silabs/silabs-sensors/occupancy-sed/OpenThread ${board} \"is_occupancy_sensor=true\" --icd
                                        mkdir -p ${saved_workspace}/out/sleepy/${board}/OpenThread/sensors/occupancy-sed/
                                        cp ./out/silabs/silabs-sensors/occupancy-sed/OpenThread/${board}/*.s37 ${saved_workspace}/out/sleepy/${board}/OpenThread/sensors/occupancy-sed/
                                        cp ./out/silabs/silabs-sensors/occupancy-sed/OpenThread/${board}/*.map ${saved_workspace}/out/sleepy/${board}/OpenThread/sensors/occupancy-sed/
                                """

                                sh """ ./scripts/examples/gn_silabs_example.sh ./silabs_examples/silabs-sensors ./out/silabs/silabs-sensors/temperature-sed/OpenThread ${board} \"is_temperature_sensor=true\" --icd
                                        mkdir -p ${saved_workspace}/out/sleepy/${board}/OpenThread/sensors/temperature-sed/
                                        cp ./out/silabs/silabs-sensors/temperature-sed/OpenThread/${board}/*.s37 ${saved_workspace}/out/sleepy/${board}/OpenThread/sensors/temperature-sed/
                                        cp ./out/silabs/silabs-sensors/temperature-sed/OpenThread/${board}/*.map ${saved_workspace}/out/sleepy/${board}/OpenThread/sensors/temperature-sed/
                                """

                                sh """ ./scripts/examples/gn_silabs_example.sh ./silabs_examples/silabs-sensors ./out/silabs/silabs-sensors/contact-sed/OpenThread ${board} \"is_contact_sensor=true\" --icd
                                        mkdir -p ${saved_workspace}/out/sleepy/${board}/OpenThread/sensors/contact-sed/
                                        cp ./out/silabs/silabs-sensors/contact-sed/OpenThread/${board}/*.s37 ${saved_workspace}/out/sleepy/${board}/OpenThread/sensors/contact-sed/
                                        cp ./out/silabs/silabs-sensors/contact-sed/OpenThread/${board}/*.map ${saved_workspace}/out/sleepy/${board}/OpenThread/sensors/contact-sed/
                                """

                            }

                        }

                    }
                } catch (e) {
                        deactivateWorkspaceOverlay(advanceStageMarker.getBuildStagesList(),
                                                    workspaceTmpDir,
                                                    saveDir,
                                                    '-name no-files')
                        throw e
                }
                stash name: 'CustomOpenThreadExamples', includes:  'out/**/*.s37 '
            }

            deactivateWorkspaceOverlay(advanceStageMarker.getBuildStagesList(),
                                       workspaceTmpDir,
                                       'matter/' + saved_workspace,
                                       '-name "*.s37" -o -name "*.map"')
        }
    }
}

def executeWifiBuild(exampleType, app, relPath, radioName, board, args, ota_automation, sleepyBoard )
{
    // Boards for Code Size report
    def codeSizeBoard = ["BRD4187C", "BRD4325B"]

    if(ota_automation){
        sh "./scripts/examples/gn_silabs_example.sh ${exampleType}/${app}/${relPath}/ out/OTA/ota_automation_out/WiFi/${app}_wifi_${radioName}/ ${board} ${args} chip_build_libshell=true "
    }
    else{
        // Enable matter shell, on standard builds, with chip_build_libshell=true argument for SQA tests
        sh "./scripts/examples/gn_silabs_example.sh ${exampleType}/${app}/${relPath}/ out/${app}_wifi_${radioName} ${board} ${args} chip_build_libshell=true"
        if (codeSizeBoard.contains(board)){
            sh "./scripts/examples/gn_silabs_example.sh ${exampleType}/${app}/${relPath}/ out/${app}_wifi_${radioName}/release ${board} ${args} --release"
        }
    }


    // for sleepy devices
    if (sleepyBoard.contains(board)) {
       sh "./scripts/examples/gn_silabs_example.sh ${exampleType}/${app}/${relPath}/ out/${app}_wifi_${radioName}/sleepy ${board} chip_enable_icd_server=true ${args}"
    }
}

def moveWifiBinaries(app, board, radioName, ota_automation, sleepyBoard)
{
    def platformAndRadio = ""
    // Used to restructure output directory in later step
    def appNameOnly = app - '-app'
    def fileTypesToMove = ["s37","map"]
    // Boards for Code Size report
    def codeSizeBoard = ["BRD4187C", "BRD4325B"]

    if (board == "BRD4325B" )
    {
        platformAndRadio = "SiWx917"
    }
    else
    {
        platformAndRadio = "efr32-${radioName}"
    }


    if (ota_automation){

        sh """
            ls; pwd; mkdir -p ${saved_workspace}/out/OTA/ota_automation_out/WiFi/${app}_wifi_${radioName}/${board}
            cp out/OTA/ota_automation_out/WiFi/${app}_wifi_${radioName}/${board}/*.s37  ${saved_workspace}/out/OTA/ota_automation_out/WiFi/${app}_wifi_${radioName}/${board}/${platformAndRadio}-${appNameOnly}-example.s37"""
    }
    else{
        fileTypesToMove.each { fileType ->
            sh """
                ls; pwd; mkdir -p ${saved_workspace}/out/standard/${board}/WiFi; mkdir -p ${saved_workspace}/out/release/${board}/WiFi
                cp out/${app}_wifi_${radioName}/${board}/*.${fileType} ${saved_workspace}/out/standard/${board}/WiFi/${platformAndRadio}-${appNameOnly}-example.${fileType} """
                if (codeSizeBoard.contains(board)){
                    sh """ cp out/${app}_wifi_${radioName}/release/${board}/*.${fileType} ${saved_workspace}/out/release/${board}/WiFi/${platformAndRadio}-${appNameOnly}-example.${fileType} """
                }


            if (sleepyBoard.contains(board)) {
                sh """ mkdir -p ${saved_workspace}/out/sleepy/${board}/WiFi
                    cp ./out/${app}_wifi_${radioName}/sleepy/${board}/*.${fileType} ${saved_workspace}/out/sleepy/${board}/WiFi/${platformAndRadio}-${appNameOnly}-example.${fileType} """
            }
        }
        stash name: 'WiFiExamples-' + app + '-' + board + '-' + radioName, includes: 'out/**/*.s37 '
    }
}

def buildWiFiExample(app, buildCustom, ota_automation=false, config_args='')
{
    actionWithRetry {
        node(buildFarmLargeLabel)
        {
            def workspaceTmpDir = createWorkspaceOverlay(advanceStageMarker.getBuildStagesList(),
                                                            buildOverlayDir)
            def dirPath = workspaceTmpDir + createWorkspaceOverlay.overlayMatterPath
            def saveDir = 'matter/'
            def exampleType =''
            def relPath = ''
            def wifiNCPRadios = [ "rs9116", "SiWx917", "wf200" ]
            def args = config_args
            def radioName = ''
            def sleepyBoard = [ "BRD4186C", "BRD4187C" ]
            def wifiBoards = ''

            if (buildCustom == true)
            {
                exampleType = "silabs_examples"
            }
            else
            {
                exampleType = "examples"
                relPath = "silabs"
            }

            if (ota_automation) {
                wifiBoards = ["BRD4161A", "BRD4187C"]
            } else {
                // Build only for release candidate branch
                if (env.BRANCH_NAME.startsWith('RC_')) {
                    wifiBoards = [ "BRD4161A", "BRD4163A", "BRD4164A", "BRD4170A", "BRD4186C", "BRD4187C", "BRD4325B" ]
                } else {
                    wifiBoards = [ "BRD4161A", "BRD4187C", "BRD4325B" ]
                }
            }

            withDockerRegistry([url: "https://artifactory.silabs.net ", credentialsId: 'svc_gsdk']){
                    sh "docker pull $chipBuildEfr32Image"
            }

            dir(dirPath) {
                try {
                    withDockerContainer(image: chipBuildEfr32Image, args: "-u root")
                    {
                        // CSA Examples build
                        withEnv(['PW_ENVIRONMENT_ROOT='+dirPath])
                        {
                            wifiBoards.each { board ->
                                // Reset args string per board
                                args = config_args

                                if (board == "BRD4325B")
                                {
                                    // TODO MATTER-1925 fix me once window app is refactored
                                    if (app == "window-app")
                                    {
                                        return
                                    }
                                    sh 'echo Building 917'
                                    radioName = "917_soc"
                                    executeWifiBuild(exampleType, app, relPath, radioName, board, args, ota_automation, sleepyBoard)
                                    moveWifiBinaries(app, board, radioName, ota_automation, sleepyBoard)
                                } else {
                                    wifiNCPRadios.each { rcp ->
                                        // MG24 + SiWx917: name the example as "xxx_wifi_91x"
                                        // MG24 + 9116: name the example as "xxx_wifi_rs9116"
                                        // MG12 + 9116: name the example as "xxx_wifi_rs9116" so that it only applies to RS9116 (we don't support MG12 + SiWx917)
                                        // MGxx + WF00: name the example as "xxx_wifi_wf200"
                                        radioName = "${rcp}"  // MGxx + WF200

                                        if (rcp == "SiWx917") {
                                            radioName = "91x"
                                        }
                                        // MG12 + WF200: set is_debug=false and chip_logging=false, otherwise it does not fit (not a problem for MG24 + WF200, also MG24 + WF200 init fails with is_debug=false)
                                        // MG24 + RS9116/SiWx917: disable LCD and ext flash due to common SPI pin multiplexing issue
                                        // MG24 + WF200: disable libshell due to VCOM pin multiplexing issue
                                        // TODO : Disabling all logs currently makes the build fail. But flash size is close to the limit. Once fixed re-disable logs
                                        if ((board == "BRD4161A" || board == "BRD4163A" || board == "BRD4164A" || board == "BRD4170A") && rcp == "wf200")  // MG12 + WF200
                                        {
                                            args = args + " is_debug=false"

                                            // TODO : MG12 + lock-app + WF200 does not currently fit within flash so disabling chip logging as well
                                            if (app == "lock-app")
                                            {
                                                args = args + " chip_logging=false"
                                            }
                                        }
                                        else if ((rcp == "SiWx917" || rcp == "rs9116"))  // MG24 + SiWx917/RS9116
                                        {
                                            args = args + " disable_lcd=true use_external_flash=false chip_enable_ble_rs911x=true"
                                        }

                                        args = args + " --wifi " + rcp

                                        executeWifiBuild(exampleType, app, relPath, radioName, board, args, ota_automation, sleepyBoard)
                                        moveWifiBinaries(app, board, radioName, ota_automation, sleepyBoard)
                                    }
                                }
                            }
                        }
                    }

                } catch (e) {
                    deactivateWorkspaceOverlay(advanceStageMarker.getBuildStagesList(),
                                                workspaceTmpDir,
                                                saveDir,
                                                '-name no-files')
                    throw e
                }
            }

            deactivateWorkspaceOverlay(advanceStageMarker.getBuildStagesList(),
                                       workspaceTmpDir,
                                       'matter/' + saved_workspace,
                                       '-name "*.s37" -o -name "*.map"')
        }
    }
}

def buildChipToolAndOTAProvider()
{
        actionWithRetry {
        node(buildFarmLabel)
        {
            def workspaceTmpDir = createWorkspaceOverlay(advanceStageMarker.getBuildStagesList(),
                                                            buildOverlayDir)
            def dirPath = workspaceTmpDir + createWorkspaceOverlay.overlayMatterPath
            def saveDir = 'matter/'
            def chipToolImage = "artifactory.silabs.net/gsdk-docker-production/connectedhomeip/chip-build-crosscompile:22"

            withDockerRegistry([url: "https://artifactory.silabs.net ", credentialsId: 'svc_gsdk']){
                sh "docker pull $chipToolImage"
            }

            dir(dirPath) {
                try {
                    withDockerContainer(image: chipToolImage, args: "-u root")
                    {
                        withEnv(['PW_ENVIRONMENT_ROOT='+dirPath])
                        {

                            sh 'rm -rf ./.environment'
                            sh 'pwd'
                            sh 'git config --global --add safe.directory $(pwd)'
                            sh 'git config --global --add safe.directory $(pwd)/third_party/pigweed/repo'
                            sh 'chmod +x ./scripts/setup/bootstrap.sh'
                            sh './scripts/setup/bootstrap.sh'
                            sh './scripts/run_in_build_env.sh  "./scripts/build/build_examples.py --target linux-arm64-chip-tool-ipv6only-clang build"'
                            sh './scripts/run_in_build_env.sh  "./scripts/build/build_examples.py --target linux-arm64-ota-provider-ipv6only-clang build"'
                        }
                    }
                } catch (e) {
                        deactivateWorkspaceOverlay(advanceStageMarker.getBuildStagesList(),
                                                    workspaceTmpDir,
                                                    saveDir,
                                                    '-name no-files')
                        throw e
                }
                // Move binaries to standardized output
                sh """ mkdir -p ${saved_workspace}/out/Chiptool/linux-arm64-ipv6only-clang
                       mkdir -p ${saved_workspace}/out/OTA/linux-arm64-ipv6only-clang
                       cp out/linux-arm64-chip-tool-ipv6only-clang/chip-tool ${saved_workspace}/out/Chiptool/linux-arm64-ipv6only-clang
                       cp out/linux-arm64-ota-provider-ipv6only-clang/chip-ota-provider-app ${saved_workspace}/out/OTA/linux-arm64-ipv6only-clang
                """
                stash name: 'ChipTool', includes: 'out/linux-arm64-chip-tool-ipv6only-clang/chip-tool'
                stash name: 'OTAProvider', includes: 'out/linux-arm64-ota-provider-ipv6only-clang/chip-ota-provider-app'

            }
            deactivateWorkspaceOverlay(advanceStageMarker.getBuildStagesList(),
                                       workspaceTmpDir,
                                       'matter/' + saved_workspace,
                                       '-name "chip-tool" -o -name "chip-ota-provider-app"')
        }
    }
}

def buildUnifyApp(arch, app, env_exports, buildDir, out_path)
{
    echo "Build Unify Matter " + app
    sh 'rm -rf ./.environment'
    sh 'git config --global --add safe.directory $(pwd)'
    sh 'git config --global --add safe.directory $(pwd)/third_party/pigweed/repo'

    // Compile the Unify app
    dir (buildDir)
    {
        def archname = arch - 'hf'
        sh "../../../scripts/run_in_build_env.sh \"${env_exports}; gn gen ${out_path} --args='target_cpu=\\\"" + archname + "\\\"'\""
        sh "../../../scripts/run_in_build_env.sh \"${env_exports}; ninja -C ${out_path}\""
    }
}

def buildUnifyARM(arch, triples, app)
{
    actionWithRetry {
        node(buildFarmLargeLabel)
        {
            def workspaceTmpDir = createWorkspaceOverlay(advanceStageMarker.getBuildStagesList(),
                                                            buildOverlayDir)
            def dirPath = workspaceTmpDir + createWorkspaceOverlay.overlayMatterPath
            def unifyCheckoutDir = workspaceTmpDir + "/overlay/unify"
            def saveDir = 'matter/out/'
            try {

                withDockerRegistry([url: "https://artifactory.silabs.net ", credentialsId: 'svc_gsdk']) {
                    def unify_matter_docker = docker.image('artifactory.silabs.net/gsdk-docker-production/unify-cache/unify-matter:1.1.3-' + arch)
                    stage('unify ' + arch) {
                        dir(dirPath) {
                            unify_matter_docker.inside("-u root -v${unifyCheckoutDir}:/unify")
                            {
                                withEnv(['PW_ENVIRONMENT_ROOT=' + dirPath])
                                {
                                    // Build libunify 
                                    echo "Build libunify for " + arch
                                    sh 'cd /unify && cmake -DCMAKE_INSTALL_PREFIX=$PWD/stage_' + arch + ' -GNinja -DCMAKE_TOOLCHAIN_FILE=../cmake/' + arch + '_debian.cmake  -B build_unify_' + arch + '/ -S components -DBUILD_TESTING=OFF'
                                    sh 'cd /unify && cmake --build build_unify_' + arch
                                    sh 'cd /unify && cmake --install build_unify_' + arch + ' --prefix $PWD/stage_' + arch
                                }
                            }
                        }
                    }
                    stage('Unify Matter ' + app + ' ' + arch) {

                            dir(dirPath)
                            {
                                unify_matter_docker.inside("-u root -v${unifyCheckoutDir}:/unify")
                                {
                                    withEnv(['PW_ENVIRONMENT_ROOT=' + dirPath])
                                    {
                                        def pkg_config_export = "export PKG_CONFIG_PATH=:/unify/stage_" + arch + "/share/pkgconfig:/usr/lib/" + triples + "/pkgconfig"
                                        def python_path_export = "export PYTHONPATH=\$PYTHONPATH:/usr/local/miniconda/lib/python3.9/site-packages/"
                                        def all_env_exports = "${pkg_config_export}; ${python_path_export}"
                                        buildUnifyApp(arch, app, all_env_exports, "silabs_examples/unify-matter-" + app + "/linux", "../../../out/silabs_examples/unify-matter-" + app + "/" + arch + "_debian_bullseye")
                                    }
                                }

                                // Move binaries to standardized output
                                sh """  mkdir -p ${saved_workspace}/out/""" + app + """/""" + arch + """_debian_bullseye
                                            
                                        cp ./out/silabs_examples/unify-matter-""" + app + """/""" + arch + """_debian_bullseye/obj/bin/unify-matter-""" + app + """ ${saved_workspace}/out/""" + app + """/""" + arch + """_debian_bullseye/
                                """
                                if (fileExists("""./out/silabs_examples/unify-matter-""" + app + """/""" + arch + """_debian_bullseye/packages""")) {
                                    sh """  cp ./out/silabs_examples/unify-matter-""" + app + """/""" + arch + """_debian_bullseye/packages/* ${saved_workspace}/out/""" + app + """/""" + arch + """_debian_bullseye/
                                    """
                                }
                            }
                    }
                    stage('chip-tool ' + arch) {
                            dir(dirPath)
                            {
                                unify_matter_docker.inside("-u root -v${unifyCheckoutDir}:/unify")
                                {
                                    withEnv(['PW_ENVIRONMENT_ROOT=' + dirPath])
                                    {

                                        def pkg_config_export = "export PKG_CONFIG_PATH=:/unify/stage_" + arch + "/share/pkgconfig:/usr/lib/" + triples + "/pkgconfig"
                                        sh 'rm -rf ./.environment'
                                        sh 'git config --global --add safe.directory $(pwd)'
                                        sh 'git config --global --add safe.directory $(pwd)/third_party/pigweed/repo'

                                        // Compile the Unify app
                                        dir ("examples/chip-tool")
                                        {
                                            def archname = arch - 'hf'
                                            def out_path = "../../out/examples/chip-tool/" + arch + "_debian_bullseye"
                                            sh "../../scripts/run_in_build_env.sh \"${pkg_config_export}; gn gen ${out_path} --args='target_cpu=\\\"" + archname + "\\\"'\""
                                            sh "../../scripts/run_in_build_env.sh \"${pkg_config_export}; ninja -C ${out_path}\""
                                        }
                                    }
                                }

                                // Move binaries to standardized output
                                sh """  mkdir -p ${saved_workspace}/out/Chiptool/""" + arch + """_debian_bullseye
                                            
                                        cp ./out/examples/chip-tool/""" + arch + """_debian_bullseye/chip-tool ${saved_workspace}/out/Chiptool/""" + arch + """_debian_bullseye/
                                """
                            }
                    }
                }
            } catch (e) {
                deactivateWorkspaceOverlay(advanceStageMarker.getBuildStagesList(),
                                            workspaceTmpDir,
                                            "matter",
                                            '-name no-files')
                throw e
            }
            deactivateWorkspaceOverlay(advanceStageMarker.getBuildStagesList(),
                                            workspaceTmpDir,
                                            'matter/' + saved_workspace,
                                            '-name "unify-matter-*" -o -type f -name "chip-tool" -o -type f -name "*.deb"')
        }
    }
}

def buildUnifyAMD(app)
{
    actionWithRetry {
        node(buildFarmLargeLabel)
        {
            def workspaceTmpDir = createWorkspaceOverlay(advanceStageMarker.getBuildStagesList(),
                                                            buildOverlayDir)
            def dirPath = workspaceTmpDir + createWorkspaceOverlay.overlayMatterPath
            def unifyCheckoutDir = workspaceTmpDir + "/overlay/unify"
            def saveDir = 'matter/out/'
            try {
                
                withDockerRegistry([url: "https://artifactory.silabs.net ", credentialsId: 'svc_gsdk']) {
                    def unify_matter_docker_amd64 = docker.image('artifactory.silabs.net/gsdk-docker-production/unify-cache/unify-matter:1.1.3-amd64')
                    dir(dirPath)
                    {
                        stage('libunify amd64') {
                            unify_matter_docker_amd64.inside("-u root -v${unifyCheckoutDir}:/unify")
                            {
                                withEnv(['PW_ENVIRONMENT_ROOT=' + dirPath])
                                {
                                    echo "Build libunify"
                                    sh 'cd /unify && cmake -DCMAKE_INSTALL_PREFIX=$PWD/stage_amd64 -GNinja -B build_unify_amd64/ -S components -DBUILD_TESTING=OFF'
                                    sh 'cd /unify && cmake --build build_unify_amd64'
                                    sh 'cd /unify && cmake --install build_unify_amd64 --prefix $PWD/stage_amd64'
                                }
                            }
                            stage('Unify Matter ' + app + ' amd64') {
                                unify_matter_docker_amd64.inside("-u root -v${unifyCheckoutDir}:/unify")
                                {
                                    withEnv(['PW_ENVIRONMENT_ROOT=' + dirPath])
                                    {
                                        echo "Build Unify Matter " + app
                                        sh 'rm -rf ./.environment'
                                        sh 'git config --global --add safe.directory $(pwd)'
                                        sh 'git config --global --add safe.directory $(pwd)/third_party/pigweed/repo'
                                        def pkg_config_export = "export PKG_CONFIG_PATH=:/unify/stage_amd64/share/pkgconfig"

                                        // Execute Unit Tests
                                        dir ("silabs_examples/unify-matter-" + app + "/linux")
                                        {
                                            sh "../../../scripts/run_in_build_env.sh \"${pkg_config_export}; ../../unify-matter-common/scripts/compile_tests.sh -t amd64\""
                                            sh "export LD_LIBRARY_PATH=/unify/stage_amd64/lib; ../../unify-matter-common/scripts/run_tests.sh -b out/amd64_test"
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            } catch (e) {
                deactivateWorkspaceOverlay(advanceStageMarker.getBuildStagesList(),
                                            workspaceTmpDir,
                                            "matter",
                                            '-name no-files')
                throw e
            }
            deactivateWorkspaceOverlay(advanceStageMarker.getBuildStagesList(),
                                            workspaceTmpDir,
                                            'matter/' + saved_workspace,
                                            '-name no-files')
        }
    }
}

def exportIoTReports()
{
    actionWithRetry {
        node(buildFarmLabel)
        {
            def workspaceTmpDir = createWorkspaceOverlay(advanceStageMarker.getBuildStagesList(),
                                                            buildOverlayDir)
            def dirPath = workspaceTmpDir + createWorkspaceOverlay.overlayMatterPath
            def saveDir = 'matter/'
            withDockerRegistry([url: "https://artifactory.silabs.net ", credentialsId: 'svc_gsdk']){
                sh "docker pull $chipBuildEfr32Image"
            }

            dir(dirPath) {
                try {
                    withDockerContainer(image: chipBuildEfr32Image, args: "-u root")
                    {
                        // sh 'apt-get install python3-venv'
                        sh 'python3 -m venv code_size_analysis_venv'
                        sh '. code_size_analysis_venv/bin/activate'
                        sh 'python3 -m pip install --upgrade pip'
                        sh 'pip3 install code_size_analyzer_client-python>=0.4.1'

                        sh "echo ${env.BUILD_NUMBER}"

                        // This set of Applications to track code size was
                        // approved by Rob Alexander on June 7 2023
                        // Matter Thread MG24 (BRD4187C) – Light
                        // Matter Thread MG24 (BRD4187C) – Lock
                        // Matter Thread MG24 (BRD4187C) – Window Shade
                        // Matter Wi-Fi 9116 (BRD4187C) – Lock
                        // Matter Wi-Fi 9116 (BRD4187C) – Thermostat
                        // Matter Wi-Fi 917 (BRD4325B) – Lock
                        // Matter Wi-Fi 917 (BRD4325B) – Thermostat

                        def wifiSizeTrackingApp = [ "lock-app", "thermostat"]
                        def openThreadMG24Apps = ["lighting-app", "lock-app", "window-app"]
                        def appVersion = ["release"]

                        // Generate report for MG24 (BRD4187C) apps
                        openThreadMG24Apps.each { app ->
                            appVersion.each { version ->
                                def appNameOnly = app - '-app'
                                sh """unset OTEL_EXPORTER_OTLP_ENDPOINT
                                    code_size_analyzer_cli \
                                    --map_file ${saved_workspace}/out/${version}/BRD4187C/OpenThread/matter-silabs-${appNameOnly}-example*.map \
                                    --stack_name matter \
                                    --target_part efr32mg24b210f1536im48 \
                                    --compiler gcc \
                                    --target_board BRD4187C \
                                    --app_name ${app}-${version}-MG24 \
                                    --service_url https://code-size-analyzer.silabs.net \
                                    --branch_name ${env.BRANCH_NAME} \
                                    --build_number b${env.BUILD_NUMBER} \
                                    --output_file ${app}-MG24.json \
                                    --store_results True \
                                    --verify_ssl False
                                """

                            }
                        }

                        // Generate report for WiFi implementation MG24 BRD4187C + RS9116
                        wifiSizeTrackingApp.each { app ->
                            def appNameOnly = app - '-app'
                            sh """unset OTEL_EXPORTER_OTLP_ENDPOINT
                                code_size_analyzer_cli \
                                --map_file ${saved_workspace}/out/standard/BRD4187C/WiFi/efr32-91x-${appNameOnly}-example.map \
                                --stack_name matter \
                                --target_part efr32mg24b210f1536im48 \
                                --compiler gcc \
                                --target_board BRD4187C \
                                --app_name ${app}-WiFi-MG24 \
                                --service_url https://code-size-analyzer.silabs.net \
                                --branch_name ${env.BRANCH_NAME} \
                                --build_number b${env.BUILD_NUMBER} \
                                --output_file ${app}-WiFi-MG24.json \
                                --store_results True \
                                --verify_ssl False
                            """
                        }

                        // Generate report for WiFi SOC (BRD4325B)s
                        wifiSizeTrackingApp.each { app ->
                            def appNameOnly = app - '-app'
                            sh """unset OTEL_EXPORTER_OTLP_ENDPOINT
                                code_size_analyzer_cli \
                                --map_file ${saved_workspace}/out/release/BRD4325B/WiFi/SiWx917-${appNameOnly}-example.map \
                                --stack_name matter \
                                --target_part SiWG917M612LGTAA \
                                --compiler gcc \
                                --target_board BRD4325B \
                                --app_name ${app}-WiFi-917 \
                                --service_url https://code-size-analyzer.silabs.net \
                                --branch_name ${env.BRANCH_NAME} \
                                --build_number b${env.BUILD_NUMBER} \
                                --output_file ${app}-WiFi-917.json \
                                --store_results True \
                                --verify_ssl False
                            """
                        }

                        // Create dummy files to forward workspace to next stage
                        sh 'touch ./bugfix.txt'
                    }
                } catch (e) {
                    deactivateWorkspaceOverlay(advanceStageMarker.getBuildStagesList(),
                                                workspaceTmpDir,
                                                saveDir,
                                                '-name no-files')
                    throw e
                }
            }
            deactivateWorkspaceOverlay(advanceStageMarker.getBuildStagesList(),
                                       workspaceTmpDir,
                                       'matter/',
                                       '-name "bugfix.txt"')
        }
    }
}

def openThreadTestSuite(deviceGroup,name,board)
{
    globalLock(credentialsId: 'hwmux_token_matterci', deviceGroup: deviceGroup)
    {
        node('gsdkBostonNode')
        {
                    sh 'printenv'
                    ws('/home/dockerUser/qaWorkspace/')
                    {
                        dir('matter-scripts')
                        {
                            checkout scm: [$class                     : 'GitSCM',
                                            branches                         : [[name: 'master']],
                                            browser                          : [$class: 'Stash',
                                            repoUrl: 'https://stash.silabs.com/scm/wmn_sqa/matter-scripts/'],
                                            userRemoteConfigs                : [[credentialsId: 'svc_gsdk',
                                                            url: 'https://stash.silabs.com/scm/wmn_sqa/matter-scripts.git']]]
                        }
                        dir('sqa-tools')
                        {
                            sh '''
                                git clean -ffdx
                                git pull
                            '''
                        }

                        catchError(buildResult: 'UNSTABLE',
                                    catchInterruptions: false,
                                    message: "[ERROR] One or more openthread tests have failed",
                                    stageResult: 'UNSTABLE')
                        {
                            dir('matter')
                            {
                                sh 'pwd '
                                stashFolder = 'OpenThreadExamples-'+name+'-'+board
                                echo "unstash folder: "+stashFolder
                                unstash stashFolder
                                unstash 'ChipTool'

                                chiptoolPath = sh(script: "find " + pwd() + " -name 'chip-tool' -print",returnStdout: true).trim()
                                echo chiptoolPath

                            }


                            def  ci_path="${WORKSPACE}/matter/out/CSA/"+name+"/OpenThread/standard/"
                            echo "ci_path: "+ci_path
                            def  zap_install_path="${WORKSPACE}/zap-bin"
                            echo "zap_install_path: " + zap_install_path

                            withEnv([ 'TEST_SCRIPT_REPO=matter-scripts',
                                    "BOARD_ID=${board}",
                                    "MATTER_APP_EXAMPLE=${name}" ,
                                    "BRANCH_NAME=${JOB_BASE_NAME}",
                                    'RUN_SUITE=true',
                                    'TEST_SUITE=MatterCI',
                                    'PUBLISH_RESULTS=true',
                                    'RUN_TCM_SETUP=false',
                                    "MATTER_CI_PATH=${ci_path}",
                                    'DEBUG=true',
                                    "TEST_BUILD_NUMBER=${BUILD_NUMBER}",
                                    "MATTER_CHIP_TOOL_PATH=${chiptoolPath}" ,
                                    "_JAVA_OPTIONS='-Xmx3072m'",
                                    "ZAP_INSTALL_PATH=${zap_install_path}"
                                    ])
                                {
                                sh 'pwd && ls -R'
                                sh 'printenv '
                                sh "java -XX:+PrintFlagsFinal -Xmx1g -version | grep -Ei 'maxheapsize|maxram'"

                                sh "ls -ll /home/dockerUser/qaWorkspace/matter/out/CSA/lighting-app/OpenThread/standard/${board}/"

                                sh "ant -file $WORKSPACE/sqa-tools/test_tcm.xml  compileJava"
                                sh "ant -file $WORKSPACE/sqa-tools/test_tcm.xml  runTestsJava"

                                sh "ls -ll /home/dockerUser/qaWorkspace/matter-scripts/Results/"
                                sh "ls -ll /home/dockerUser/qaWorkspace/matter-scripts/"

                                junit "${TEST_SCRIPT_REPO}/Results/*.xml"
                                sh "rm ${TEST_SCRIPT_REPO}/Results/*.xml"

                                archiveArtifacts 'sqa-tools/TestResults/Log/**/*.log,TestResults/Log/**/*.csv,TestResults/Log/**/*.png, TestResults/Log/**/*.pcap'

                            }
                        }
            }
        }
    }
}

def utfThreadTestSuite(nomadNode,deviceGroup,testBedName,appName,matterType,board,testSuite,manifestYaml,testSequenceYaml )
{
    globalLock(credentialsId: 'hwmux_token_matterci', deviceGroup: deviceGroup) {
       node(nomadNode)
       {
                    sh 'printenv'
                    ws('/home/dockerUser/qaWorkspace/')
                    {

                        dir('utf_app_matter')
                        {
                            sshagent(['svc_gsdk-ssh']) {
                                checkout scm: [$class                     : 'GitSCM',
                                                branches                         : [[name: 'master']],
                                                browser                          : [$class: 'Stash',
                                                repoUrl: 'https://stash.silabs.com/scm/utf/utf_app_matter.git/'],
                                                userRemoteConfigs                : [[credentialsId: 'svc_gsdk-ssh',
                                                                url: 'ssh://git@stash.silabs.com/utf/utf_app_matter.git']]]

                                sh ''' git submodule sync --recursive
                                    git submodule update --init --recursive -q '''
                                sh 'git submodule foreach --recursive git fetch --tags'
                                sh ''' git clean -ffdx
                                    git submodule foreach --recursive -q git reset --hard -q
                                    git submodule foreach --recursive -q git clean -ffdx -q '''
                            }

                            dir('matter')
                            {
                                    sh 'pwd '
                                    stashFolder = 'OpenThreadExamples-'+appName+'-'+board
                                    echo "unstash folder: "+stashFolder
                                    unstash stashFolder
                                    unstash 'ChipTool'

                                    chiptoolPath = sh(script: "find " + pwd() + " -name 'chip-tool' -print",returnStdout: true).trim()
                                    echo chiptoolPath
                                    sh "cp out/CSA/${appName}/OpenThread/standard/${board}/*.s37 ../manifest"
                            }

                            withVault([vaultSecrets: secrets])
                            {
                                withEnv([
                                    // vars required for publish to database
                                    'UTF_QUEUE_SERVER_URL=amqps://' + SL_USERNAME + ':' + SL_PASSWORD + '@utf-queue-central.silabs.net:443/%2f',
                                    "UTF_PRODUCER_APP_ID=$BUILD_TAG",
                                    "RELEASE_NAME=$RELEASE_NAME",
                                    "TEST_SUITE=MatterCI", // ?
                                    "TEST_SCRIPT_REPO=utf-app-matter",
                                    "SDK_URL=N/A",        // ?
                                    "STUDIO_URL=N/A",     // ?
                                    "BRANCH_NAME=${JOB_BASE_NAME}", // ?
                                    "SDK_BUILD_NUM=$BUILD_NUMBER",
                                    "TESTBED_NAME=${testBedName}",
                                    "BUILD_URL=$BUILD_URL",
                                    "JENKIN_RUN_NUM=$BUILD_NUMBER",
                                    "JENKINS_JOB_NAME=$JOB_NAME",
                                    "JENKINS_SERVER_NAME=$JENKINS_URL",
                                    "JENKINS_TEST_RESULTS_URL=$JOB_URL$BUILD_NUMBER/testReport",
                                    "BOARD_ID=${board}",
                                    "MATTER_APP_EXAMPLE=${appName}",
                                    'RUN_SUITE=true',
                                    "MATTER_TYPE=${matterType}",
                                    "TEST_TYPE=ci",
                                    'PUBLISH_RESULTS=true', // unneeded?
                                    'RUN_TCM_SETUP=false',  // unneeded?
                                    "MATTER_CHIP_TOOL_PATH=${chiptoolPath}" ,
                                    'DEBUG=true'
                                ])
                                {
                                    catchError(buildResult: 'UNSTABLE',
                                               catchInterruptions: false,
                                               message: "[ERROR] One or more tests have failed",
                                               stageResult: 'UNSTABLE')
                                    {
                                        sh """
                                            echo ${MATTER_CHIP_TOOL_PATH}
                                            ls -al ${MATTER_CHIP_TOOL_PATH}
                                            ./workspace_setup.sh
                                            executor/launch_utf_tests.sh --publish_test_results true --harness  ${TESTBED_NAME}.yaml --executor_type local --pytest_command "pytest --tb=native tests${testSuite} --manifest manifest${manifestYaml}.yaml ${testSequenceYaml}"
                                        """
                                    }
                                }
                            }
                            archiveArtifacts artifacts: 'reports/pytest-report.html'
                            junit: 'reports/junit_report.xml'
                        }
                    }
        }
    }
}


def utfWiFiTestSuite(nomadNode,deviceGroup,testBedName,appName,matterType,board,wifi_module,testSuite,manifestYaml,testSequenceYaml)
{
    globalLock(credentialsId: 'hwmux_token_matterci', deviceGroup: deviceGroup) {
       node(nomadNode)
       {
                    sh 'printenv'
                    ws('/home/dockerUser/qaWorkspace/')
                    {

                        dir('utf_app_matter')
                        {
                            sshagent(['svc_gsdk-ssh']) {
                                checkout scm: [$class                     : 'GitSCM',
                                                branches                         : [[name: 'master']],
                                                browser                          : [$class: 'Stash',
                                                repoUrl: 'https://stash.silabs.com/scm/utf/utf_app_matter.git/'],
                                                userRemoteConfigs                : [[credentialsId: 'svc_gsdk-ssh',
                                                                url: 'ssh://git@stash.silabs.com/utf/utf_app_matter.git']]]


                                sh ''' git submodule sync --recursive
                                    git submodule update --init --recursive -q '''
                                sh 'git submodule foreach --recursive git fetch --tags'
                                sh ''' git clean -ffdx
                                    git submodule foreach --recursive -q git reset --hard -q
                                    git submodule foreach --recursive -q git clean -ffdx -q '''
                            }



                            dir('matter')
                            {
                                stashFolder = 'WiFiExamples-'+appName+'-'+board+'-'+wifi_module
                                unstash stashFolder
                                unstash 'ChipTool'

                                chiptoolPath = sh(script: "find " + pwd() + " -name 'chip-tool' -print",returnStdout: true).trim()
                                echo chiptoolPath

                               sh "cp out/${appName}_wifi_${wifi_module}/${board}/*.s37 ../manifest"

                            }

                            withVault([vaultSecrets: secrets])
                            {
                                withEnv([
                                    // vars required for publish to database
                                    'UTF_QUEUE_SERVER_URL=amqps://' + SL_USERNAME + ':' + SL_PASSWORD + '@utf-queue-central.silabs.net:443/%2f',
                                    "UTF_PRODUCER_APP_ID=$BUILD_TAG",
                                    "RELEASE_NAME=$RELEASE_NAME",
                                    "TEST_SUITE=MatterCI", // ?
                                    "TEST_SCRIPT_REPO=utf-app-matter",
                                    "SDK_URL=N/A",        // ?
                                    "STUDIO_URL=N/A",     // ?
                                    "BRANCH_NAME=${JOB_BASE_NAME}", // ?
                                    "SDK_BUILD_NUM=$BUILD_NUMBER",
                                    "TESTBED_NAME=${testBedName}",
                                    "BUILD_URL=$BUILD_URL",
                                    "JENKIN_RUN_NUM=$BUILD_NUMBER",
                                    "JENKINS_JOB_NAME=$JOB_NAME",
                                    "JENKINS_SERVER_NAME=$JENKINS_URL",
                                    "JENKINS_TEST_RESULTS_URL=$JOB_URL$BUILD_NUMBER/testReport",
                                    // vars required for matter test execution (?)
                                    "BOARD_ID=${board}",
                                    "MATTER_APP_EXAMPLE=${appName}",
                                    'RUN_SUITE=true',
                                    "MATTER_TYPE=${matterType}",
                                    "WIFI_MODULE=${wifi_module}",
                                    "TEST_TYPE=ci",
                                    'PUBLISH_RESULTS=true', // unneeded?
                                    'RUN_TCM_SETUP=false',  // unneeded?
                                    "MATTER_CHIP_TOOL_PATH=${chiptoolPath}" ,
                                    'DEBUG=true'
                                ])
                                {
                                    catchError(buildResult: 'UNSTABLE',
                                               catchInterruptions: false,
                                               message: "[ERROR] One or more tests have failed",
                                               stageResult: 'UNSTABLE')
                                    {

                                        sh """
                                            echo ${TESTBED_NAME}
                                            ./workspace_setup.sh
                                            executor/launch_utf_tests.sh --publish_test_results true --harness  ${TESTBED_NAME}.yaml --executor_type local --pytest_command "pytest --tb=native tests${testSuite} --manifest manifest${manifestYaml}.yaml ${testSequenceYaml}"
                                        """
                                    }
                                }
                            }
                            archiveArtifacts artifacts: 'reports/pytest-report.html'
                            junit: 'reports/junit_report.xml'
                        }
                    }
        }
    }
}

def generateGblFileAndOTAfiles()
{
    actionWithRetry {
        node(buildFarmLabel)
        {

            def boards = ["BRD4161A","BRD4187C"]
            def technology = ["OpenThread","WiFi"]
            def wifiRCP = ["wf200","rs9116", "91x"]
            def appName = "lighting-app"
            def workspaceTmpDir = createWorkspaceOverlay(advanceStageMarker.getBuildStagesList(),
                                                            buildOverlayDir)
            def dirPath = workspaceTmpDir + createWorkspaceOverlay.overlayMatterPath
            def saveDir = 'matter/'

            // Closure to generate the gbl and ota files
            def genFiles = {app, tech, board, radioName ->

                sh """

                        commander --version
                        pwd

                        if [ "${tech}" = "OpenThread" ] ; then
                            bin_path="${dirPath}/${saved_workspace}/out/OTA/ota_automation_out/${app}/OpenThread/${board}"
                            file="\$(find \$bin_path/ -name \\*.s37 | grep -o '[^/]*\$')"
                        else
                            bin_path="${dirPath}/${saved_workspace}/out/OTA/ota_automation_out/WiFi/${app}_wifi_${radioName}/${board}"
                            file="\$(find \$bin_path/ -name \\*.s37 | grep -o '[^/]*\$')"
                        fi

                        gbl_file="\$(basename \$file .s37).gbl"
                        ota_file="\$(basename \$file .s37).ota"

                        commander gbl create \$bin_path/\$gbl_file --app \$bin_path/\$file
                        ${dirPath}/src/app/ota_image_tool.py create -v 0xFFF1 -p 0x8005 -vn 2 -vs 2.0 -da sha256 \$bin_path/\$gbl_file \$bin_path/\$ota_file

                        ls -al \$bin_path

                    """
                return 0
            }

            withDockerRegistry([url: "https://artifactory.silabs.net ", credentialsId: 'svc_gsdk']){
                sh "docker pull $commanderImage"
            }

            dir(dirPath) {
                try{
                    withDockerContainer(image: commanderImage)
                    {
                        withEnv(['file=""',
                                    'gbl_file=""',
                                    'ota_file=""',
                                    'bin_path=""']){

                                technology.each{ tech_ ->
                                    boards.each{ brd ->

                                        if(tech_ == "WiFi"){
                                            wifiRCP.each{ radioName ->
                                                if (brd == "BRD4161A" && radioName != "91x"){
                                                    genFiles.call(appName, tech_, brd, radioName)
                                                }
                                                else if (brd == "BRD4187C"){
                                                    genFiles.call(appName, tech_, brd, radioName)
                                                }
                                            }
                                        }
                                        else if (tech_ == "OpenThread"){
                                            genFiles.call(appName, tech_, brd, "")
                                        }

                                    }
                                }
                        }
                    }
                }
                catch (e)
                {
                        deactivateWorkspaceOverlay(advanceStageMarker.getBuildStagesList(),
                                  workspaceTmpDir,
                                  saveDir,
                                  '-name no-files')
                        throw e
                }
            }
            deactivateWorkspaceOverlay(advanceStageMarker.getBuildStagesList(), workspaceTmpDir, 'matter/'+ saved_workspace,'-name "*.gbl" -o -name "*.ota"')
        }
    }
}

def generateRpsFiles()
{
    actionWithRetry {
        node(buildFarmLabel)
        {
            def boards = "BRD4325B"
            def wifiPlatforms = "917_soc"
            // TODO Matter-1925
            def appName = "lighting,lock,light-switch,onoff-plug"
            def workspaceTmpDir = createWorkspaceOverlay(advanceStageMarker.getBuildStagesList(),
                                                            buildOverlayDir)
            def dirPath = workspaceTmpDir + createWorkspaceOverlay.overlayMatterPath
            def saveDir = 'matter/'

            def image = "artifactory.silabs.net/gsdk-docker-production/gsdk_nomad_containers/gsdk_23q2:latest"

            // Closure to generate the rps files
            def genRpsFiles = {app, board, radioName ->

                sh """

                        commander --version
                        pwd

                        bin_path_std="${dirPath}/${saved_workspace}/out/standard/${board}/WiFi/"
                        bin_path_release="${dirPath}/${saved_workspace}/out/release/${board}/WiFi/"
                        file_std="\$(find \$bin_path_std/*${app}*.s37 | grep -o '[^/]*\$')"
                        file_release="\$(find \$bin_path_release/*${app}*.s37 | grep -o '[^/]*\$')"

                        rps_file_std="\$(basename \$file_std .s37).rps"
                        rps_file_release="\$(basename \$file_release .s37).rps"

                        commander rps create \$bin_path_std/\$rps_file_std --app \$bin_path_std/\$file_std
                        commander rps create \$bin_path_release/\$rps_file_release --app \$bin_path_release/\$file_release

                        ls -al \$bin_path_std
                        ls -al \$bin_path_release

                    """
                return 0
            }

            withDockerRegistry([url: "https://artifactory.silabs.net ", credentialsId: 'svc_gsdk']){
                sh "docker pull $image"
            }

            dir(dirPath) {
                try{
                    withDockerContainer(image: image)
                    {
                        withEnv(['file_std=""',
                                    'file_release=""',
                                    'rps_file_std=""',
                                    'rps_file_release=""',
                                    'bin_path_std=""',
                                    'bin_path_release=""']){
                            boards.tokenize(",").each{ brd ->
                                wifiPlatforms.tokenize(",").each{ platform ->
                                    appName.tokenize(",").each{ app ->
                                        // generating the RPS file for BRD4325B
                                        genRpsFiles.call(app, brd, platform)
                                    }
                                }
                            }
                        }
                    }
                }
                catch (e)
                {
                        deactivateWorkspaceOverlay(advanceStageMarker.getBuildStagesList(),
                                  workspaceTmpDir,
                                  saveDir,
                                  '-name no-files')
                        throw e
                }
            }
            deactivateWorkspaceOverlay(advanceStageMarker.getBuildStagesList(), workspaceTmpDir, 'matter/' + saved_workspace,'-name "*.rps"')
        }
    }
}

def pushToArtifactoryAndUbai()
{
    actionWithRetry {
        node(buildFarmLabel)
        {
            def workspaceTmpDir = createWorkspaceOverlay(advanceStageMarker.getBuildStagesList(),
                                                            buildOverlayDir)
            def dirPath = workspaceTmpDir + createWorkspaceOverlay.overlayMatterPath
            def saveDir = 'matter/'

            def image = "artifactory.silabs.net/gsdk-docker-production/gsdk_nomad_containers/gsdk_ubai:latest"
            
            withDockerRegistry([url: "https://artifactory.silabs.net ", credentialsId: 'svc_gsdk']){
                sh "docker pull $image"
            }

            dir(dirPath) {
                try{
                    //for RC_ branch, artifacts need push staging repos, otherwise push to development repos
                    def reposName = 'gsdk-generic-development'
                    if (env.BRANCH_NAME.startsWith('RC_')){
                        reposName = 'gsdk-generic-staging'
                    }
                    echo reposName

                    withDockerContainer(image: image)
                    {
                        withCredentials([usernamePassword(credentialsId: 'svc_gsdk', passwordVariable: 'SL_PASSWORD', usernameVariable: 'SL_USERNAME')])
                        {

                                sh '''
                                    set -o pipefail
                                    set -x
                                    pwd
                                    file="build-binaries.zip"
                                    cd saved_workspace

                                    if [ -d "out/OTA/ota_automation_out" ]; then
                                        if [ -d "out/ECOSYSTEM/ecosystem_automation_out" ]; then
                                            zip -r "${file}" out -x out/OTA/ota_automation_out/\\* -x out/ECOSYSTEM/ecosystem_automation_out/\\*
                                        else
                                            zip -r "${file}" out -x out/OTA/ota_automation_out/\\*
                                        fi
                                    else
                                        if [ -d "out/ECOSYSTEM/ecosystem_automation_out" ]; then
                                            zip -r "${file}" out -x out/ECOSYSTEM/ecosystem_automation_out/\\*
                                        else
                                            zip -r "${file}" out
                                        fi
                                    fi
                                    ls -al

                                    status_code=$(curl -s  -w "%{http_code}" --upload-file "$file" \
                                                    -X PUT "https://artifactory.silabs.net/artifactory/'''+reposName+'''/matter/${JOB_BASE_NAME}/${BUILD_NUMBER}/$file"\
                                                    -u $SL_USERNAME:$SL_PASSWORD -H 'Content-Type: application/octet-stream'
                                                    )
                                            if [[ "$status_code" -ne 201 ]] ; then
                                                    echo "$file File upload was not successful.\nStatus Code: $status_code"
                                                    exit 1
                                            else
                                                    echo "$file File upload was successful."
                                            fi

                                    rm "${file}"
                                    zip -r "${file}" out

                                    echo 'UBAI uploading ......'
                                    ubai_upload_cli --client-id jenkins-gsdk-pipelines-Matter --file-path build-binaries.zip  --metadata app_name matter \
                                            --metadata branch ${JOB_BASE_NAME} --metadata build_number ${BUILD_NUMBER} --metadata stack matter --metadata target matter  --username ${SL_USERNAME} --password ${SL_PASSWORD}

                                    if [ $? -eq 0 ]; then
                                        echo 'uploaded to UBAI successfully....... '
                                    else
                                        echo FAIL
                                    fi
                            '''
                            }
                    }
                } catch (e)
                {
                        deactivateWorkspaceOverlay(advanceStageMarker.getBuildStagesList(),
                                  workspaceTmpDir,
                                  saveDir,
                                  '-name no-files')
                        throw e
                }
            }

            deactivateWorkspaceOverlay(advanceStageMarker.getBuildStagesList(), workspaceTmpDir, 'matter/')

        }
    }
}

def triggerSqaSmokeAndRegressionTest(buildTool)
{
    node(buildFarmLabel)
        {
            def workspaceTmpDir = createWorkspaceOverlay(advanceStageMarker.getBuildStagesList(),
                                                            buildOverlayDir)
               // def dirPath = workspaceTmpDir + createWorkspaceOverlay.overlayMatterPath
            def saveDir = 'matter/'
            catchError(buildResult: 'SUCCESS',
                        catchInterruptions: false,
                        message: "[ERROR] SQA smoke trigger branch doesn't exist",
                        stageResult: 'SUCCESS')
            {

                ws(workspaceTmpDir+createWorkspaceOverlay.overlaySqaPipelinesPath)
                {
                        sh 'pwd && ls -al'
                            if(sqaFunctions.isProductionJenkinsServer())
                            {
                                echo 'in product jenkin.... '
                                sqaFunctions.commitToMatterSqaPipelines(buildTool, 'smoke')
                                sqaFunctions.commitToMatterSqaPipelines(buildTool, 'regression')
                                sqaFunctions.commitToMatterSqaPipelines(buildTool, 'endurance-customers-issues')
                                sqaFunctions.commitToMatterSqaPipelines(buildTool, 'regression-binding-enhanced')
                                sqaFunctions.commitToMatterSqaPipelines(buildTool, 'regression-enhanced-groups')
                            }
                }
            }
            deactivateWorkspaceOverlay(advanceStageMarker.getBuildStagesList(), workspaceTmpDir, 'matter/')
        }
}
// pipeline definition and execution
def pipeline()
{

   stage('Init Workspace and Repos')
    {
        node('buildNFS')
        {
            // set up NFS overlay and git repos
            initWorkspaceAndScm()
            // export the NFS overlay
            sh 'sudo exportfs -af'
        }
    }

    def parallelNodesBuild = [:]
    stage("Build")
    {
        advanceStageMarker()

        //---------------------------------------------------------------------
        // Build Unify Matter Bridge and PC
        //---------------------------------------------------------------------
        if(params.BUILD_UNIFY_MATTER == true || env.BRANCH_NAME.startsWith('RC_')) {
            parallelNodesBuild["Unify Matter Bridge ARM64"] = 
            { 
                // Currently official supported platform
                this.buildUnifyARM("arm64","aarch64-linux-gnu", "bridge")
            }
            parallelNodesBuild["Unify Matter PC ARM64"] = 
            { 
                // Currently official supported platform
                this.buildUnifyARM("arm64","aarch64-linux-gnu", "pc")
            }
            parallelNodesBuild["Unify Matter Bridge ARMHF"] = 
            {
                this.buildUnifyARM("armhf","arm-linux-gnueabihf", "bridge")
            }
            parallelNodesBuild["Unify Matter PC ARMHF"] = 
            {
                this.buildUnifyARM("armhf","arm-linux-gnueabihf", "pc")
            }
            parallelNodesBuild["Unify Matter Bridge AMD64"] = 
            {
                this.buildUnifyAMD("bridge")
            }
            parallelNodesBuild["Unify Matter PC AMD64"] = 
            {
                this.buildUnifyAMD("pc")
            }
        }

        //---------------------------------------------------------------------
        // Build OpenThread Examples
        //---------------------------------------------------------------------
        // build library dependencies
        def openThreadApps = ["lighting-app", "lock-app", "thermostat", "light-switch-app", "window-app"]

        openThreadApps.each { appName ->
            parallelNodesBuild["OpenThread " + appName]      = { this.buildOpenThreadExample(appName)   }
        }

        //---------------------------------------------------------------------
        // Build WiFi Examples
        //---------------------------------------------------------------------

        def wifiApps = [ "lighting-app", "lock-app", "light-switch-app", "thermostat", "window-app" ]

        wifiApps.each { appName ->
            parallelNodesBuild["WiFi " + appName ]      = { this.buildWiFiExample(appName, false)   }
        }

        //---------------------------------------------------------------------
        // Build Custom examples
        //---------------------------------------------------------------------

        def silabsCustomExamplesOpenThread = ["onoff-plug-app", "template"]
        def silabsCustomExamplesWifi = ["onoff-plug-app"]

        // Openthread custom examples
        silabsCustomExamplesOpenThread.each { example ->
            parallelNodesBuild["Custom OT " + example] = { this.buildSilabsCustomOpenThreadExamples(example)   }
        }

        // Build OpenThread Silabs Sensor App
        parallelNodesBuild["Silabs Sensor "] = { this.buildSilabsSensorApp()   }

        // Wifi custom examples
        silabsCustomExamplesWifi.each { example ->
            parallelNodesBuild["Custom WiFi " + example]       = { this.buildWiFiExample(example, true)   }
        }

        //---------------------------------------------------------------------
        // Build Tooling
        //---------------------------------------------------------------------
        parallelNodesBuild['Build Chip-tool and OTA-Provider '] = { this.buildChipToolAndOTAProvider()   }

        parallelNodesBuild.failFast = false
        parallel parallelNodesBuild

    }

    if (env.BRANCH_NAME.startsWith('silabs') || env.BRANCH_NAME.startsWith('RC_')) {
        stage("Code Size analysis")
        {
            advanceStageMarker()
            exportIoTReports()
        }
    }
    def parallelNodesImages = [:]

    if(params.OTA_AUTOMATION_TEST == true || env.BRANCH_NAME.startsWith('RC_')){
        stage("Generate SQA images")
        {
            advanceStageMarker()
            def parallelNodesOTABuild = [:]

            parallelNodesImages["OT OTA Light"]         = {this.buildOpenThreadExample("lighting-app", ota_automation=true, config_args=software_version)}
            parallelNodesImages["WiFi OTA imgage"]      = { this.buildWiFiExample("lighting-app", false, ota_automation=true, config_args=software_version)  }

            parallelNodesImages.failFast = false
            parallel parallelNodesImages

        }
        stage("Generate Gbl/Ota files"){

            advanceStageMarker()
            generateGblFileAndOTAfiles()
        }
    }

    def parallelNodesEcosystemImages = [:]

    if(params.ECOSYSTEM_AUTOMATION_TEST == true || env.BRANCH_NAME.startsWith('RC_')){
        stage("Generate SQA ECOSYSTEM images")
        {
            advanceStageMarker()

            parallelNodesEcosystemImages["Ecosystem Lighting"]         = {this.buildOpenThreadExample("lighting-app", ota_automation=false, ecosystem_automation=true)}
            //Will need to add node for wifi when pigweed support is added for 917soc
            parallelNodesEcosystemImages.failFast = false
            parallel parallelNodesEcosystemImages

        }
    }


    stage("Generate RPS files")
    {
        // Generating the RPS file for 917 SoC
        advanceStageMarker()
        generateRpsFiles()

    }

    stage("Push to Artifactory and UBAI")
    {
        advanceStageMarker()
        pushToArtifactoryAndUbai()
    }

     stage('SQA')
    {
      // advanceStageMarker()
        //even openthread test in parallel, they actually run in sequence as they are using same raspi
        def parallelNodes = [:]
        parallelNodes['lighting Thread BRD4187C']   = { this.utfThreadTestSuite('gsdkMontrealNode','utf_matter_thread','matter_thread','lighting-app','thread','BRD4187C','',"/manifest-4187-thread","--tmconfig tests/.sequence_manager/test_execution_definitions/matter_thread_ci_sequence.yaml") }
        // parallelNodes['lighting Thread BRD2703A']   = { this.utfThreadTestSuite('gsdkMontrealNode','utf_matter_thread_2',
        //                                                                         'matter_thread_2','lighting-app','thread','BRD2703A','',
        //                                                                         "/manifest-2703-thread",
        //                                                                         "--tmconfig tests/.sequence_manager/test_execution_definitions/matter_thread_ci_sequence.yaml") }
        parallelNodes['lighting Thread BRD4161A']   = { this.utfThreadTestSuite('gsdkMontrealNode','utf_matter_thread_4','matter_thread_4','lighting-app','thread','BRD4161A','',"/manifest-4161-thread","--tmconfig tests/.sequence_manager/test_execution_definitions/matter_thread_ci_sequence.yaml") }
        parallelNodes['lighting 917-exp BRD4187C']   = { this.utfWiFiTestSuite('gsdkMontrealNode','utf_matter_wifi','matter_wifi','lighting-app','wifi','BRD4187C','91x','',"/manifest-4187-917","--tmconfig tests/.sequence_manager/test_execution_definitions/matter_wifi_ci_sequence.yaml") }
        parallelNodes.failFast = false
        parallel parallelNodes

    }
    stage("Trigger SQA Smoke and Regression")
    {
        advanceStageMarker()
        triggerSqaSmokeAndRegressionTest('NINJA')
    }

    currentBuild.result = 'SUCCESS'
}

def postFailure(e)
{
    currentBuild.result = 'FAILURE'
}

def postAlways()
{
    stage('Cleanup Overlays')
    {
        advanceStageMarker()
        node('buildNFS')
        {
            // clean up the things that have been pushed to the overlay
            sh '/srv/jenkins/createSuperOverlay.sh '+
               'removebuildoverlay '+
               buildOverlayDir
            dir('/srv/jenkins/overlays/') {
                sh 'rm -rf ' + advanceStageMarker.nfsOverlayWorkspaceRoot.replace('/mnt/nfs', '/srv/jenkins')
            }
        }
    }
}

// TODO lock the repo resource?
try {
    pipeline()
} catch (e) {
    postFailure(e)
    throw e
} finally {
    postAlways()
}
