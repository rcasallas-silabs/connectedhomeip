#!groovy
@Library('gsdk-shared-lib@master')
import groovy.json.JsonSlurper
properties([disableConcurrentBuilds()])

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
                 branches:   [[name: 'release/22q4']],
                 extensions: [[$class: 'CloneOption', depth: 1, noTags: false, reference: '', shallow: true],
                                [$class: 'SubmoduleOption', disableSubmodules: false, parentCredentials: true,
                                recursiveSubmodules: true, reference: '', shallow: true, trackingSubmodules: false]],
                    userRemoteConfigs: [[credentialsId: 'svc_gsdk', url: 'https://bitbucket-cph.silabs.com/scm/stash/uic/uic.git']]]
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

def buildOpenThreadExample(app)
{
    actionWithRetry {
        node(buildFarmLargeLabel)
        {
            def workspaceTmpDir = createWorkspaceOverlay(advanceStageMarker.getBuildStagesList(),
                                                            buildOverlayDir)
            def dirPath = workspaceTmpDir + createWorkspaceOverlay.overlayMatterPath
            def saveDir = 'matter/'
            def buildRelease = true
            def openThreadBoards = [:]
            def sleepyBoard = ["BRD4161A", "BRD4186C"]

            def relPath = "silabs/efr32"

            // Remove -app at end of string for later use (if it exists)
            def appNameOnly = app - '-app'

            withDockerRegistry([url: "https://artifactory.silabs.net ", credentialsId: 'svc_gsdk']){
                sh "docker pull $chipBuildEfr32Image"
            }
            // Build only for release candidate branch
            if (env.BRANCH_NAME.startsWith('RC_')) {
                openThreadBoards = ["BRD4161A", "BRD4162A", "BRD4163A", "BRD4164A", "BRD4166A", "BRD4186C", "BRD4187C", "BRD2703A", "BRD2601B", "BRD4316A", "BRD4317A", "BRD4319A"]
            } else {
                openThreadBoards = ["BRD4161A", "BRD4166A", "BRD4187C", "BRD2703A","BRD4316A", "BRD4319A" ]

            }

            dir(dirPath) {
                try {
                    withDockerContainer(image: chipBuildEfr32Image, args: "-u root")
                    {
                        // CSA Examples build
                        withEnv(['PW_ENVIRONMENT_ROOT='+dirPath])
                        {
                            openThreadBoards.each { board ->
                                def arguments = ""
                                    if (sleepyBoard.contains(board)) {
                                        arguments = "--sed"
                                    }
                                sh """./scripts/examples/gn_efr32_example.sh ./examples/${app}/${relPath} ./out/CSA/${app}/OpenThread/standard ${board}
                                        mkdir -p ${saved_workspace}/out/standard/${board}/OpenThread
                                        cp ./out/CSA/${app}/OpenThread/standard/${board}/*.s37 ${saved_workspace}/out/standard/${board}/OpenThread/
                                        cp ./out/CSA/${app}/OpenThread/standard/${board}/*.map ${saved_workspace}/out/standard/${board}/OpenThread/ 
                                """

                                if(buildRelease) {
                                    // TODO: --use_ot_lib is used in the release build options until thread issue with NDEBUG is found and fixed
                                    // TODO: Skip MGM24 modules release build. They don't have thread_cert_libs to workaround above issue ^
                                    def skipRelease = ["BRD4316A", "BRD4317A", "BRD4319A"]
                                    if (!skipRelease.contains(board)) {
                                        sh """./scripts/examples/gn_efr32_example.sh ./examples/${app}/${relPath} ./out/CSA/${app}/OpenThread/release ${board} --release --use_ot_lib
                                            mkdir -p ${saved_workspace}/out/release/${board}/OpenThread
                                            cp ./out/CSA/${app}/OpenThread/release/${board}/*.s37 ${saved_workspace}/out/release/${board}/OpenThread/
                                            cp ./out/CSA/${app}/OpenThread/release/${board}/*.map ${saved_workspace}/out/release/${board}/OpenThread/
                                        """
                                    }
                                }
                                if(arguments) {
                                    sh """./scripts/examples/gn_efr32_example.sh ./examples/${app}/${relPath} ./out/CSA/${app}/OpenThread/sleepy ${board} ${arguments}
                                          mkdir -p ${saved_workspace}/out/sleepy/${board}/OpenThread
                                          cp ./out/CSA/${app}/OpenThread/sleepy/${board}/*.s37 ${saved_workspace}/out/sleepy/${board}/OpenThread/
                                          cp ./out/CSA/${app}/OpenThread/sleepy/${board}/*.map ${saved_workspace}/out/sleepy/${board}/OpenThread/
                                    """
                                }
                                stash name: 'OpenThreadExamples-'+app+'-'+board, includes: 'out/**/*.s37 '
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
                                sh "./scripts/examples/gn_efr32_example.sh ./silabs_examples/${app}/efr32 ./out/silabs/${app}/OpenThread/ ${board}"
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
                                sh """ ./scripts/examples/gn_efr32_example.sh ./silabs_examples/silabs-sensors/efr32 ./out/silabs/silabs-sensors/occupancy/OpenThread ${board} \"is_occupancy_sensor=true\"
                                        mkdir -p ${saved_workspace}/out/standard/${board}/OpenThread/sensors/occupancy/
                                        cp ./out/silabs/silabs-sensors/occupancy/OpenThread/${board}/*.s37 ${saved_workspace}/out/standard/${board}/OpenThread/sensors/occupancy/
                                        cp ./out/silabs/silabs-sensors/occupancy/OpenThread/${board}/*.map ${saved_workspace}/out/standard/${board}/OpenThread/sensors/occupancy/
                                """

                                sh """ ./scripts/examples/gn_efr32_example.sh ./silabs_examples/silabs-sensors/efr32 ./out/silabs/silabs-sensors/temperature/OpenThread ${board} \"is_temperature_sensor=true\"
                                        mkdir -p ${saved_workspace}/out/standard/${board}/OpenThread/sensors/temperature/
                                        cp ./out/silabs/silabs-sensors/temperature/OpenThread/${board}/*.s37 ${saved_workspace}/out/standard/${board}/OpenThread/sensors/temperature/
                                        cp ./out/silabs/silabs-sensors/temperature/OpenThread/${board}/*.map ${saved_workspace}/out/standard/${board}/OpenThread/sensors/temperature/
                                """

                                sh """ ./scripts/examples/gn_efr32_example.sh ./silabs_examples/silabs-sensors/efr32 ./out/silabs/silabs-sensors/contact/OpenThread ${board} \"is_contact_sensor=true\"
                                        mkdir -p ${saved_workspace}/out/standard/${board}/OpenThread/sensors/contact/
                                        cp ./out/silabs/silabs-sensors/contact/OpenThread/${board}/*.s37 ${saved_workspace}/out/standard/${board}/OpenThread/sensors/contact/
                                        cp ./out/silabs/silabs-sensors/contact/OpenThread/${board}/*.map ${saved_workspace}/out/standard/${board}/OpenThread/sensors/contact/
                                """

                                sh """ ./scripts/examples/gn_efr32_example.sh ./silabs_examples/silabs-sensors/efr32 ./out/silabs/silabs-sensors/occupancy-sed/OpenThread ${board} \"is_occupancy_sensor=true\" --sed
                                        mkdir -p ${saved_workspace}/out/sleepy/${board}/OpenThread/sensors/occupancy-sed/
                                        cp ./out/silabs/silabs-sensors/occupancy-sed/OpenThread/${board}/*.s37 ${saved_workspace}/out/sleepy/${board}/OpenThread/sensors/occupancy-sed/
                                        cp ./out/silabs/silabs-sensors/occupancy-sed/OpenThread/${board}/*.map ${saved_workspace}/out/sleepy/${board}/OpenThread/sensors/occupancy-sed/
                                """

                                sh """ ./scripts/examples/gn_efr32_example.sh ./silabs_examples/silabs-sensors/efr32 ./out/silabs/silabs-sensors/temperature-sed/OpenThread ${board} \"is_temperature_sensor=true\" --sed
                                        mkdir -p ${saved_workspace}/out/sleepy/${board}/OpenThread/sensors/temperature-sed/
                                        cp ./out/silabs/silabs-sensors/temperature-sed/OpenThread/${board}/*.s37 ${saved_workspace}/out/sleepy/${board}/OpenThread/sensors/temperature-sed/
                                        cp ./out/silabs/silabs-sensors/temperature-sed/OpenThread/${board}/*.map ${saved_workspace}/out/sleepy/${board}/OpenThread/sensors/temperature-sed/
                                """

                                sh """ ./scripts/examples/gn_efr32_example.sh ./silabs_examples/silabs-sensors/efr32 ./out/silabs/silabs-sensors/contact-sed/OpenThread ${board} \"is_contact_sensor=true\" --sed
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

def buildWiFiExample(platform, app, board, wifiRadio, args, radioName, buildCustom)
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
            def fileTypesToMove = ["s37","map"]

            // Used to restructure output directory in later step
            def appNameOnly = app - '-app'

            def sleepyBoard = [ "BRD4186C", "BRD4187C" ]

            if (buildCustom == true)
            {
                exampleType = "silabs_examples"
                relPath = "${platform}"
            }
            else
            {
                exampleType = "examples"
                relPath = "silabs/${platform}"
            }   

            // Only the wifi ncp builds require to specify the --wifi radio used.
            if (platform != "SiWx917")
            {
                args = args + " --wifi " + wifiRadio
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

                            sh "./scripts/examples/gn_efr32_example.sh ${exampleType}/${app}/${relPath}/ out/${app}_wifi_${radioName} ${board} ${args}"
                            sh "./scripts/examples/gn_efr32_example.sh ${exampleType}/${app}/${relPath}/ out/${app}_wifi_${radioName}/release ${board} ${args} --release"

                            // for sleepy devices
                            if (sleepyBoard.contains(board)) {
                                sh "./scripts/examples/gn_efr32_example.sh ${exampleType}/${app}/${relPath}/ out/${app}_wifi_${radioName}/sleepy ${board} enable_sleepy_device=true ${args}"
                            }
                        }
                    }

                    // Move binaries to standardized output 
                    def platformAndRadio = "${platform}-${radioName}"
                    if (platform == "SiWx917")
                    {
                        platformAndRadio = "${platform}"
                    }
                    fileTypesToMove.each { fileType ->
                        sh """ 
                            ls; pwd; mkdir -p ${saved_workspace}/out/standard/${board}/WiFi; mkdir -p ${saved_workspace}/out/release/${board}/WiFi
                            cp out/${app}_wifi_${radioName}/${board}/*.${fileType} ${saved_workspace}/out/standard/${board}/WiFi/${platformAndRadio}-${appNameOnly}-example.${fileType}
                            cp out/${app}_wifi_${radioName}/release/${board}/*.${fileType} ${saved_workspace}/out/release/${board}/WiFi/${platformAndRadio}-${appNameOnly}-example.${fileType} """
                        if (sleepyBoard.contains(board)) {
                            sh """ mkdir -p ${saved_workspace}/out/sleepy/${board}/WiFi
                                cp ./out/${app}_wifi_${radioName}/sleepy/${board}/*.${fileType} ${saved_workspace}/out/sleepy/${board}/WiFi/${platformAndRadio}-${appNameOnly}-example.${fileType} """
                        }
                    }
                    stash name: 'WiFiExamples-' + app + '-' + board + '-' + radioName, includes: 'out/**/*.s37 ' 

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
                            sh './scripts/build/gn_bootstrap.sh'
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

def buildUnifyBridge()
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
                    def unify_bridge_docker_arm64 = docker.image('artifactory.silabs.net/gsdk-docker-production/unify-cache/unify-matter:1.1.1-arm64')
                    def unify_bridge_docker_armhf = docker.image('artifactory.silabs.net/gsdk-docker-production/unify-cache/unify-matter:1.1.1-armhf')
                    def unify_bridge_docker_amd64 = docker.image('artifactory.silabs.net/gsdk-docker-production/unify-cache/unify-matter:1.1.1-amd64')
                    dir(dirPath)
                    {
                        // Currently official supported platform
                        unify_bridge_docker_arm64.inside("-u root -v${unifyCheckoutDir}:/unify")
                        {
                            withEnv(['PW_ENVIRONMENT_ROOT='+dirPath])
                            {
                                // Build libunify for arm64
                                echo "Build libunify for arm64"
                                sh 'cd /unify && cmake -DCMAKE_INSTALL_PREFIX=$PWD/stage_arm64 -GNinja -DCMAKE_TOOLCHAIN_FILE=../cmake/arm64_debian.cmake  -B build_unify_arm64/ -S components -DBUILD_TESTING=OFF'
                                sh 'cd /unify && cmake --build build_unify_arm64'
                                sh 'cd /unify && cmake --install build_unify_arm64 --prefix $PWD/stage_arm64'

                                echo "Build Unify Matter Bridge"
                                sh 'rm -rf ./.environment'
                                sh 'git config --global --add safe.directory $(pwd)'
                                sh 'git config --global --add safe.directory $(pwd)/third_party/pigweed/repo'
                                def pkg_config_export = "export PKG_CONFIG_PATH=:/unify/stage_arm64/share/pkgconfig:/usr/lib/aarch64-linux-gnu/pkgconfig"

                                // Compile the Unify Matter Bridge for arm64
                                dir ("silabs_examples/unify-matter-bridge/linux")
                                {
                                    def out_path = "../../../out/silabs_examples/unify-matter-bridge/arm64_debian_bullseye"
                                    sh "../../../scripts/run_in_build_env.sh \"${pkg_config_export}; gn gen ${out_path} --args='target_cpu=\\\"arm64\\\"'\""
                                    sh "../../../scripts/run_in_build_env.sh \"${pkg_config_export}; ninja -C ${out_path}\""
                                }

                                // Compile chip-tool for arm64
                                dir ("examples/chip-tool")
                                {
                                    def out_path = "../../out/examples/chip-tool/arm64_debian_bullseye"
                                    sh "../../scripts/run_in_build_env.sh \"${pkg_config_export}; gn gen ${out_path} --args='target_cpu=\\\"arm64\\\"'\""
                                    sh "../../scripts/run_in_build_env.sh \"${pkg_config_export}; ninja -C ${out_path}\""
                                }
                            }
                        }
                        // Delete this when SQA no longer needs an ARMHF build. 
                        unify_bridge_docker_armhf.inside("-u root -v${unifyCheckoutDir}:/unify") {
                            withEnv(['PW_ENVIRONMENT_ROOT='+dirPath])
                            {
                                echo "Build libunify for armhf"
                                sh 'cd /unify && cmake -DCMAKE_INSTALL_PREFIX=$PWD/stage_armhf -GNinja -DCMAKE_TOOLCHAIN_FILE=../cmake/armhf_debian.cmake  -B build_unify_armhf/ -S components -DBUILD_TESTING=OFF'
                                sh 'cd /unify && cmake --build build_unify_armhf'
                                sh 'cd /unify && cmake --install build_unify_armhf --prefix $PWD/stage_armhf'

                                echo "Build Unify Matter Bridge armhf"
                                sh 'rm -rf ./.environment'
                                sh 'git config --global --add safe.directory $(pwd)'
                                sh 'git config --global --add safe.directory $(pwd)/third_party/pigweed/repo'
                                def pkg_config_export = "export PKG_CONFIG_PATH=:/unify/stage_armhf/share/pkgconfig:/usr/lib/arm-linux-gnueabihf/pkgconfig"

                                dir ("silabs_examples/unify-matter-bridge/linux")
                                {
                                    def out_path = "../../../out/silabs_examples/unify-matter-bridge/armhf_debian_bullseye"
                                    sh "../../../scripts/run_in_build_env.sh \"${pkg_config_export}; gn gen ${out_path} --args='target_cpu=\\\"arm\\\"'\""
                                    sh "../../../scripts/run_in_build_env.sh \"${pkg_config_export}; ninja -C ${out_path}\""
                                }

                                dir ("examples/chip-tool")
                                {
                                    def out_path = "../../out/examples/chip-tool/armhf_debian_bullseye"
                                    sh "../../scripts/run_in_build_env.sh \"${pkg_config_export}; gn gen ${out_path} --args='target_cpu=\\\"arm\\\"'\""
                                    sh "../../scripts/run_in_build_env.sh \"${pkg_config_export}; ninja -C ${out_path}\""
                                }
                            }
                        }
                        unify_bridge_docker_amd64.inside("-u root -v${unifyCheckoutDir}:/unify")
                        {
                            withEnv(['PW_ENVIRONMENT_ROOT='+dirPath])
                            {
                                echo "Build libunify"
                                sh 'cd /unify && cmake -DCMAKE_INSTALL_PREFIX=$PWD/stage_amd64 -GNinja -B build_unify_amd64/ -S components -DBUILD_TESTING=OFF'
                                sh 'cd /unify && cmake --build build_unify_amd64'
                                sh 'cd /unify && cmake --install build_unify_amd64 --prefix $PWD/stage_amd64'

                                echo "Build Unify Matter Bridge"
                                sh 'rm -rf ./.environment'
                                sh 'git config --global --add safe.directory $(pwd)'
                                sh 'git config --global --add safe.directory $(pwd)/third_party/pigweed/repo'
                                def pkg_config_export = "export PKG_CONFIG_PATH=:/unify/stage_amd64/share/pkgconfig"

                                // Execute Unit Tests
                                dir ("silabs_examples/unify-matter-bridge/linux")
                                {
                                    sh "../../../scripts/run_in_build_env.sh \"${pkg_config_export}; ../scripts/compile_tests.sh -t amd64\""
                                    sh "../scripts/run_tests.sh -b out/amd64_test"
                                }
                            }
                        }

                        // Move binaries to standardized output
                        sh """  mkdir -p ${saved_workspace}/out/Bridge/arm64_debian_bullseye; mkdir -p ${saved_workspace}/out/Chiptool/arm64_debian_bullseye
                                mkdir -p ${saved_workspace}/out/Bridge/armhf_debian_bullseye; mkdir -p ${saved_workspace}/out/Chiptool/armhf_debian_bullseye
                                    
                                cp ./out/silabs_examples/unify-matter-bridge/arm64_debian_bullseye/obj/bin/unify-matter-bridge ${saved_workspace}/out/Bridge/arm64_debian_bullseye/
                                cp ./out/silabs_examples/unify-matter-bridge/armhf_debian_bullseye/obj/bin/unify-matter-bridge ${saved_workspace}/out/Bridge/armhf_debian_bullseye/
                                cp ./out/examples/chip-tool/arm64_debian_bullseye/chip-tool ${saved_workspace}/out/Chiptool/arm64_debian_bullseye/
                                cp ./out/examples/chip-tool/armhf_debian_bullseye/chip-tool  ${saved_workspace}/out/Chiptool/armhf_debian_bullseye/
                        """
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
                                            '-name "unify-matter-bridge" -o -type f -name "chip-tool"')
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
                        // approved by Rob Alexander on September 7 2022
                        // Light --> MG24 (BRD4187C)
                        // Lock ---> MG24 (BRD4187C) (Thread and RS9116)
                        // Window ---> MG12 (BRD4161A) + MG24 (BRD4187C)
                        // Thermostat ---> MG24 (BRD4187C) (Thread and RS9116)

                        def wifiSizeTrackingApp = [ "lock-app", "thermostat"]
                        def openThreadMG24Apps = ["lighting-app", "lock-app", "window-app"]
                        def appVersion = ["standard", "release"]

                        // Generate report for MG24 (BRD4187C) apps
                        openThreadMG24Apps.each { app ->
                            appVersion.each { version ->
                                def appNameOnly = app - '-app'
                                sh """unset OTEL_EXPORTER_OTLP_ENDPOINT
                                    code_size_analyzer_cli \
                                    --map_file ${saved_workspace}/out/${version}/BRD4187C/OpenThread/chip-efr32-${appNameOnly}*.map \
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

                        // Generate report for MG12 (BRD4161A) Window-app only
                        appVersion.each { version ->
                            sh """unset OTEL_EXPORTER_OTLP_ENDPOINT
                                code_size_analyzer_cli \
                                --map_file ${saved_workspace}/out/${version}/BRD4161A/OpenThread/chip-efr32-window*.map \
                                --stack_name matter \
                                --target_part efr32mg12p432f1024gl125 \
                                --compiler gcc \
                                --target_board BRD4161A \
                                --app_name window-app-${version}-MG12 \
                                --service_url https://code-size-analyzer.silabs.net \
                                --branch_name ${env.BRANCH_NAME} \
                                --build_number b${env.BUILD_NUMBER} \
                                --output_file window-app-MG12.json \
                                --store_results True \
                                --verify_ssl False
                            """
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
                            checkout scm: [$class                     : 'GitSCM',
                                            branches                         : [[name: 'master']],
                                            browser                          : [$class: 'Stash',
                                            repoUrl: 'https://stash.silabs.com/scm/utf/utf_app_matter.git/'],
                                            userRemoteConfigs                : [[credentialsId: 'svc_gsdk',
                                                            url: 'ssh://git@stash.silabs.com/utf/utf_app_matter.git']]]

                            sh ''' git submodule sync --recursive
                                git submodule update --init --recursive -q '''
                            sh 'git submodule foreach --recursive git fetch --tags'
                            sh ''' git clean -ffdx
                                git submodule foreach --recursive -q git reset --hard -q
                                git submodule foreach --recursive -q git clean -ffdx -q '''

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
                            checkout scm: [$class                     : 'GitSCM',
                                            branches                         : [[name: 'master']],
                                            browser                          : [$class: 'Stash',
                                            repoUrl: 'https://stash.silabs.com/scm/utf/utf_app_matter.git/'],
                                            userRemoteConfigs                : [[credentialsId: 'svc_gsdk',
                                                            url: 'ssh://git@stash.silabs.com/utf/utf_app_matter.git']]]


                            sh ''' git submodule sync --recursive
                                git submodule update --init --recursive -q '''
                            sh 'git submodule foreach --recursive git fetch --tags'
                            sh ''' git clean -ffdx
                                git submodule foreach --recursive -q git reset --hard -q
                                git submodule foreach --recursive -q git clean -ffdx -q '''



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
 
            def boards = "BRD4161A,BRD4187C,BRD4325B"
            def technology = "openThread,WiFi"
            def wifiPlatforms = "wf200,rs9116,91x"
            def appName = "lighting-app"
            def workspaceTmpDir = createWorkspaceOverlay(advanceStageMarker.getBuildStagesList(),
                                                            buildOverlayDir)
            def dirPath = workspaceTmpDir + createWorkspaceOverlay.overlayMatterPath
            def saveDir = 'matter/'

            def image = "artifactory.silabs.net/gsdk-docker-production/sqa-testnode-lite:latest"

            // Closure to generate the gbl and ota files
            def genFiles = {app, tech, board, radioName ->

                sh """
                        
                        commander --version
                        pwd

                        if [ "${tech}" = "openThread" ] ; then
                            bin_path="${dirPath}/${saved_workspace}/out/release/${board}/OpenThread/"
                            file="\$(find \$bin_path/*lighting-example.s37 | grep -o '[^/]*\$')"
                        else
                            bin_path="${dirPath}/${saved_workspace}/out/release/${board}/WiFi/"
                            file="\$(find \$bin_path/*${radioName}-lighting-example.s37 | grep -o '[^/]*\$')"
                        fi

                        gbl_file="\$(basename \$file .s37).gbl"
                        ota_file="\$(basename \$file .s37).ota"

                        commander gbl create \$bin_path/\$gbl_file --app \$bin_path/\$file
                        src/app/ota_image_tool.py create -v 0xFFF1 -p 0x8005 -vn 2 -vs 2.0 -da sha256 \$bin_path/\$gbl_file \$bin_path/\$ota_file

                        ls -al \$bin_path

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
                        withCredentials([usernamePassword(credentialsId: 'svc_gsdk', passwordVariable: 'SL_PASSWORD', usernameVariable: 'SL_USERNAME')])
                        {
                            withEnv(['file=""',
                                     'gbl_file=""',
                                     'ota_file=""',
                                     'bin_path=""']){

                                    technology.tokenize(",").each{ tech_ ->   
                                        boards.tokenize(",").each{ brd ->
                                            
                                            if(tech_ == "WiFi"){
                                                wifiPlatforms.tokenize(",").each{ platform -> 
                                                    if (brd == "BRD4161A" && (platform != "91x" && platform != "917_soc")){
                                                        genFiles.call(appName, tech_, brd, platform)
                                                    }
                                                    else if (brd == "BRD4187C" && platform != "917_soc"){
                                                        genFiles.call(appName, tech_, brd, platform)
                                                    }
                                                    else if (brd == "BRD4325B" && platform == "917_soc"){
                                                        genFiles.call(appName, tech_, brd, platform)
                                                    }
                                                }
                                            }
                                            else if (tech_ == "openThread" && brd != "BRD4325B"){
                                                genFiles.call(appName, tech_, brd, "")
                                            }
                                    
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

                                    zip -r "${file}" out -x *.gbl *.ota 
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
        // Build Unify Matter Bridge
        //---------------------------------------------------------------------
        parallelNodesBuild["Unify Matter Bridge"] = {this.buildUnifyBridge()}

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
        def wifiNCPBoards = [:]
        def wifiSOCBoards = [:]

        // Build only for release candidate branch
        if (env.BRANCH_NAME.startsWith('RC_')) {
            wifiNCPBoards = [ "BRD4161A", "BRD4163A", "BRD4164A", "BRD4170A", "BRD4186C", "BRD4187C" ]
            wifiSOCBoards = [ "BRD4325B" ]
        } else {
            wifiNCPBoards = [ "BRD4161A", "BRD4187C" ]
            wifiSOCBoards = [ "BRD4325B" ]
        }

        def wifiNCPApps = [ "lighting-app", "lock-app", "thermostat", "window-app" ]
        def wifiSOCApps = [ "lighting-app" , "lock-app", "light-switch-app", "window-app" ]

        def wifiNCPRadios = [ "rs9116", "SiWx917", "wf200" ]

        // NCP Builds
        wifiNCPApps.each { appName ->
            wifiNCPBoards.each { board ->
                wifiNCPRadios.each { rcp ->
                    // Platform = efr32 for all NCP mode combos
                    def platform = "efr32"

                    // MG24 + SiWx917: name the example as "xxx_wifi_91x"
                    // MG24 + 9116: name the example as "xxx_wifi_rs9116"
                    // MG12 + 9116: name the example as "xxx_wifi_rs9116" so that it only applies to RS9116 (we don't support MG12 + SiWx917)
                    // MGxx + WF00: name the example as "xxx_wifi_wf200"
                    def radioName = "${rcp}"  // MGxx + WF200
                    if ((board == "BRD4186C" || board == "BRD4187C") && rcp == "SiWx917") { // MG24 + SiWx917
                        radioName = "91x"
                    } else if ((board == "BRD4186C" || board == "BRD4187C") && rcp == "rs9116") { // MG24 + rs9116
                        radioName = "rs9116"
                    } else if ((board == "BRD4161A" || board == "BRD4163A" || board == "BRD4164A" || board == "BRD4170A") && rcp == "rs9116") { // MG12 + rs9116
                        radioName = "rs9116"
                    } else if ((board == "BRD4161A" || board == "BRD4163A" || board == "BRD4164A" || board == "BRD4170A") && rcp == "SiWx917") { // MG12 + SiWx917 is not supported
                        return
                    }
                    // MG12 + WF200: set is_debug=false and chip_logging=false, otherwise it does not fit (not a problem for MG24 + WF200, also MG24 + WF200 init fails with is_debug=false)
                    // MG24 + RS9116/SiWx917: disable LCD and ext flash due to common SPI pin multiplexing issue
                    // MG24 + WF200: disable libshell due to VCOM pin multiplexing issue
					def args = ""
                    // TODO : Disabling all logs currently makes the build fail. But flash size is close to the limit. Once fixed re-disable logs
                    if ((board == "BRD4161A" || board == "BRD4163A" || board == "BRD4164A" || board == "BRD4170A") && rcp == "wf200")  // MG12 + WF200
                    {
                        // TODO : MG12 + lock-app + WF200 does not currently fit within flash so disabling chip logging as well
                        if (appName == "lock-app")
                        {
                            args = "is_debug=false chip_logging=false"
                        }
                        else
                        {
                            args = "is_debug=false"
                        }
                    }
                    else if ((board == "BRD4186C" || board == "BRD4187C") && (rcp == "SiWx917" || rcp == "rs9116"))  // MG24 + SiWx917/RS9116
                    {
                        args = "disable_lcd=true use_external_flash=false chip_enable_ble_rs911x=true"
                    }
                    else if ((board == "BRD4186C" || board == "BRD4187C") && rcp == "wf200")   // MG24 + WF200
                    {
                        args = "chip_build_libshell=false"
                    }
                    parallelNodesBuild["WiFi " + appName + " " + board + " " + rcp]      = { this.buildWiFiExample(platform, appName, board, rcp, args, radioName, false)   }
                }
            }
        }

        // SOC Builds
        wifiSOCApps.each { appName ->
            wifiSOCBoards.each { board ->
                // Platform = SiWx917 for all SOC mode combos
                def platform = "SiWx917"

                // Name the examples as "xxx_wifi_917_soc"
                // SiWx917 is the only radio in use right now
                def radioName = "917_soc"

                // No additional arguments for building with BLE commissioning for SiWx917 SoC
                def args = ""
                parallelNodesBuild["WiFi " + appName + " " + board]      = { this.buildWiFiExample(platform, appName, board, false, args, radioName, false)   }
            }
        }

        //---------------------------------------------------------------------
        // Build Custom examples
        //---------------------------------------------------------------------
        def silabsCustomExamplesOpenThread = ["onoff-plug-app", "sl-newLight", "template", "lighting-lite-app"]
        def silabsCustomExamplesWifi = ["onoff-plug-app"]

        def customWifiRCP = ["rs9116", "SiWx917" ,"wf200"]

        if (env.BRANCH_NAME.startsWith('RC_')) {
            boardsForCustomWifi       = ["BRD4161A", "BRD4163A", "BRD4164A", "BRD4170A", "BRD4186C", "BRD4187C"]
            boardsForCustomWifiSoC    = ["BRD4325B"]
        } else {
             boardsForCustomWifi       = ["BRD4161A", "BRD4187C"]
             boardsForCustomWifiSoC    = ["BRD4325B"]
        }

        // Openthread custom examples
        silabsCustomExamplesOpenThread.each { example ->
            parallelNodesBuild["Custom OpenThread " + example] = { this.buildSilabsCustomOpenThreadExamples(example)   }
        }

        // Build OpenThread Silabs Sensor App
        parallelNodesBuild["Silabs Sensor "] = { this.buildSilabsSensorApp()   }



        // Wifi custom examples
        silabsCustomExamplesWifi.each { example ->
            boardsForCustomWifi.each    { board ->
                customWifiRCP.each        { rcp ->

                    // Platform = efr32 for all NCP mode combos
                    def platform = "efr32"

                    def radioName = "${rcp}"  // MGxx + WF200
                    if ((board == "BRD4186C" || board == "BRD4187C") && rcp == "SiWx917") { // MG24 + SiWx917
                        radioName = "91x"
                    } else if ((board == "BRD4186C" || board == "BRD4187C") && rcp == "rs9116") { // MG24 + rs9116
                        radioName = "rs9116"
                    } else if ((board == "BRD4161A" || board == "BRD4163A" || board == "BRD4164A" || board == "BRD4170A") && rcp == "rs9116") { // MG12 + 9116
                        radioName = "rs9116"
                    } else if ((board == "BRD4161A" || board == "BRD4163A" || board == "BRD4164A" || board == "BRD4170A") && rcp == "SiWx917") { // MG12 + SiWx917 is not supported
                        return
                    }

					def args = ""
                    if ((board == "BRD4161A" || board == "BRD4163A" || board == "BRD4164A" || board == "BRD4170A") && rcp == "wf200")
                    {
                        // TODO : Disabling all logs currently makes the build fail. But flash size is close to the limit. Once fixed re-disable logs
                        args = "is_debug=false"
                    }
                    else if ((board == "BRD4186C" || board == "BRD4187C") && (rcp == "rs9116" || rcp == "SiWx917"))
                    {
                        args = "disable_lcd=true use_external_flash=false chip_enable_ble_rs911x=true"
                    }
                    else if ((board == "BRD4186C" || board == "BRD4187C") && rcp == "wf200")
                    {
                        args = "chip_build_libshell=false"
                    }
                    parallelNodesBuild["Custom WiFi " + example + " " + board + " " + rcp]       = { this.buildWiFiExample(platform, example, board, rcp, args, radioName, true)   }
                }
            }
        }

        // Custom SOC Builds
        silabsCustomExamplesWifi.each { appName ->
            boardsForCustomWifiSoC.each { board ->
                // Platform = SiWx917 for all SOC mode combos
                def platform = "SiWx917"

                // Name the examples as "xxx_wifi_917_soc"
                // SiWx917 is the only radio in use right now
                def radioName = "917_soc"

                // No additional arguments for building with BLE commissioning for SiWx917 SoC
                def args = ""
                parallelNodesBuild["WiFi " + appName + " " + board]      = { this.buildWiFiExample(platform, appName, board, false, args, radioName, true)   }
            }
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
    stage("Generate GBL and OTA files")
    {
        advanceStageMarker()
        /*
        Generate .gbl and .ota files for the following combinations
        openThread
            BRD4161A and BRD4187C
        WiFi
            mg12 + wf200/rs9116             ( one per each combo)
            mg24 + wf200/rs9116/917/917_soc ( one per each combo)
        */
        generateGblFileAndOTAfiles()
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
        parallelNodes['lighting rs9116 BRD4161A']   = { this.utfWiFiTestSuite('gsdkMontrealNode','utf_matter_ci','INT0014944','lighting-app','wifi','BRD4161A','rs9116','',"/manifest","--tmconfig tests/.sequence_manager/test_execution_definitions/matter_wifi_ci_sequence.yaml") }
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
