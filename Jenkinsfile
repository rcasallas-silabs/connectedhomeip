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

        dir('third_party/silabs/matter_support/matter/efr32'){
             stash name: 'BootLoader', includes: 'bootloader_binaries/*.*'
        }

        sh 'du -sk'

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
                 branches:   [[name: 'ver_1.2.1-103-g34db9516-unify-matter-bridge']],
                 extensions: [[$class: 'CloneOption', depth: 1, noTags: false, reference: '', shallow: true],
                                [$class: 'SubmoduleOption', disableSubmodules: false, parentCredentials: true,
                                recursiveSubmodules: true, reference: '', shallow: true, trackingSubmodules: false]],
                    userRemoteConfigs: [[credentialsId: 'svc_gsdk', url: 'https://bitbucket-cph.silabs.com/scm/stash/uic/uic.git']]]
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

def buildOpenThreadExample(app, board)
{
    actionWithRetry {
        node(buildFarmLargeLabel)
        {
            def workspaceTmpDir = createWorkspaceOverlay(advanceStageMarker.getBuildStagesList(),
                                                            buildOverlayDir)
            def dirPath = workspaceTmpDir + createWorkspaceOverlay.overlayMatterPath
            def saveDir = 'matter/'
            def buildRelease = true
            def releaseString = "\"chip_detail_logging=false chip_automation_logging=false chip_progress_logging=false is_debug=false disable_lcd=true chip_build_libshell=false enable_openthread_cli=false chip_openthread_ftd=true\""

            dir(dirPath) {
                withDockerContainer(image: "connectedhomeip/chip-build-efr32:0.5.64", args: "-u root")
                {
                    // CSA Examples build
                    withEnv(['PW_ENVIRONMENT_ROOT='+dirPath])
                    {
                        try {
                            sh "./scripts/examples/gn_efr32_example.sh ./examples/${app}/efr32 ./out/CSA/${app}/OpenThread/standard ${board}"

                            if(buildRelease) {
                                sh "./scripts/examples/gn_efr32_example.sh ./examples/${app}/efr32 ./out/CSA/${app}/OpenThread/release ${board} ${releaseString}"
                            }
                        } catch (e) {
                            deactivateWorkspaceOverlay(advanceStageMarker.getBuildStagesList(),
                                                       workspaceTmpDir,
                                                       saveDir,
                                                       '-name no-files')
                            throw e
                        }
                    }
                }

                stash name: 'OpenThreadExamples-'+app+'-'+board, includes: 'out/CSA/*/OpenThread/**/*.s37 '

            }
            deactivateWorkspaceOverlay(advanceStageMarker.getBuildStagesList(),
                                       workspaceTmpDir,
                                       'matter/out/',
                                       '-name "*.s37" -o -name "*.map"')
        }
    }
}



def buildSilabsCustomOpenThreadExamples(app, board)
{
    actionWithRetry {
        node(buildFarmLargeLabel)
        {
            def workspaceTmpDir = createWorkspaceOverlay(advanceStageMarker.getBuildStagesList(),
                                                            buildOverlayDir)
            def dirPath = workspaceTmpDir + createWorkspaceOverlay.overlayMatterPath
            def saveDir = 'matter/'
            dir(dirPath) {
                withDockerContainer(image: "connectedhomeip/chip-build-efr32:0.5.64", args: "-u root")
                {
                    // Custom Silabs build
                    withEnv(['PW_ENVIRONMENT_ROOT='+dirPath])
                    {
                        try {
                            sh "./scripts/examples/gn_efr32_example.sh ./silabs_examples/${app}/efr32 ./out/silabs/${app}/OpenThread/ ${board}"
                        } catch (e) {
                            deactivateWorkspaceOverlay(advanceStageMarker.getBuildStagesList(),
                                                       workspaceTmpDir,
                                                       saveDir,
                                                       '-name no-files')
                            throw e
                        }
                    }
                }
                stash name: 'CustomOpenThreadExamples', includes:  'out/**/*.s37 '


            }
            deactivateWorkspaceOverlay(advanceStageMarker.getBuildStagesList(),
                                       workspaceTmpDir,
                                       'matter/out/',
                                       '-name "*.s37" -o -name "*.map"')
        }
    }
}

def buildWiFiExample(name, board, wifi_radio)
{
    actionWithRetry {
        node(buildFarmLargeLabel)
        {
            def workspaceTmpDir = createWorkspaceOverlay(advanceStageMarker.getBuildStagesList(),
                                                            buildOverlayDir)
            def dirPath = workspaceTmpDir + createWorkspaceOverlay.overlayMatterPath
            def saveDir = 'matter/'
            dir(dirPath) {
                withDockerContainer(image: "connectedhomeip/chip-build-efr32:0.5.64", args: "-u root")
                {
                    // CSA Examples build
                    withEnv(['PW_ENVIRONMENT_ROOT='+dirPath])
                    {
                        try {
                            // TODO remove enable_openthread_cli once master is updated.
                            sh "./scripts/examples/gn_efr32_example.sh examples/${name}/efr32/ out/${name}_wifi_${wifi_radio} ${board} \" disable_lcd=true use_external_flash=false enable_openthread_cli=true\" --wifi ${wifi_radio}"
                        } catch (e) {
                            deactivateWorkspaceOverlay(advanceStageMarker.getBuildStagesList(),
                                                       workspaceTmpDir,
                                                       saveDir,
                                                       '-name no-files')
                            throw e
                        }
                    }
                }

                stash name: 'WiFiExamples-'+name+'-'+board+'-'+wifi_radio, includes: 'out/**/*.s37 '

            }
            deactivateWorkspaceOverlay(advanceStageMarker.getBuildStagesList(),
                                       workspaceTmpDir,
                                       'matter/out/',
                                       '-name "*.s37" -o -name "*.map"')
        }
    }
}

def buildChipTool()
{
        actionWithRetry {
        node(buildFarmLabel)
        {
            def workspaceTmpDir = createWorkspaceOverlay(advanceStageMarker.getBuildStagesList(),
                                                            buildOverlayDir)
            def dirPath = workspaceTmpDir + createWorkspaceOverlay.overlayMatterPath
            def saveDir = 'matter/'
            dir(dirPath) {
                withDockerContainer(image: "nexus.silabs.net/connectedhomeip/chip-build-crosscompile:22",args: "-u root")
                {
                  	withEnv(['PW_ENVIRONMENT_ROOT='+dirPath])
                    {
                        try {
                            sh 'rm -rf ./.environment'
                            sh 'pwd'
                            sh 'git config --global --add safe.directory $(pwd)'
                            sh 'git config --global --add safe.directory $(pwd)/third_party/pigweed/repo'
                            sh './scripts/build/gn_bootstrap.sh'
                            sh './scripts/run_in_build_env.sh  "./scripts/build/build_examples.py --target linux-arm64-clang-chip-tool-ipv6only build"'
                        } catch (e) {
                            deactivateWorkspaceOverlay(advanceStageMarker.getBuildStagesList(),
                                                       workspaceTmpDir,
                                                       saveDir,
                                                       '-name no-files')
                            throw e
                        }
                    }
                }

                stash name: 'ChipTool', includes: 'out/**/chip-tool'

            }
            deactivateWorkspaceOverlay(advanceStageMarker.getBuildStagesList(),
                                       workspaceTmpDir,
                                       'matter/out/',
                                       '-name "chip-tool"')
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
                def unify_bridge_docker = docker.image('nexus.silabs.net/unify-cache/unify-matter:1.0.1-armhf')
                dir(dirPath)
                {
                    unify_bridge_docker.inside("-u root -v${unifyCheckoutDir}:/unify")
                    {
                        withEnv(['PW_ENVIRONMENT_ROOT='+dirPath])
                        {
                            echo "Build libunify"
                            sh 'cd /unify && cmake -DCMAKE_INSTALL_PREFIX=$PWD/stage -GNinja -DCMAKE_TOOLCHAIN_FILE=../cmake/armhf_debian.cmake  -B build_unify_armhf/ -S components'
                            sh 'cd /unify && cmake --build build_unify_armhf'
                            sh 'cd /unify && cmake --install build_unify_armhf --prefix $PWD/stage'

                            echo "Build Unify Matter Bridge"
                            sh 'rm -rf ./.environment'
                            sh 'git config --global --add safe.directory $(pwd)'
                            sh 'git config --global --add safe.directory $(pwd)/third_party/pigweed/repo'
                            def pkg_config_export = "export PKG_CONFIG_PATH=:/unify/stage/share/pkgconfig:/usr/lib/arm-linux-gnueabihf/pkgconfig"
                            dir ("silabs_examples/unify-matter-bridge/linux")
                            {
                                def out_path = "../../../out/silabs_examples/unify-matter-bridge/armhf_debian_buster"
                                sh "../../../scripts/run_in_build_env.sh \"${pkg_config_export}; gn gen ${out_path} --args='target_cpu=\\\"arm\\\"'\""
                                sh "../../../scripts/run_in_build_env.sh \"${pkg_config_export}; ninja -C ${out_path}\""
                            }
                            dir ("examples/chip-tool")
                            {
                                def out_path = "../../out/examples/chip-tool/armhf_debian_buster"
                                sh "../../scripts/run_in_build_env.sh \"${pkg_config_export}; gn gen ${out_path} --args='target_cpu=\\\"arm\\\"'\""
                                sh "../../scripts/run_in_build_env.sh \"${pkg_config_export}; ninja -C ${out_path}\""
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
                                            saveDir,
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
            dir(dirPath) {
                withDockerContainer(image: "connectedhomeip/chip-build-efr32:0.5.64", args: "-u root")
                {
                    try {
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
                                sh """unset OTEL_EXPORTER_OTLP_ENDPOINT
                                    code_size_analyzer_cli \
                                    --map_file ./out/CSA/${app}/OpenThread/${version}/BRD4187C/*.map \
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
                                --map_file ./out/CSA/window-app/OpenThread/${version}/BRD4161A/*.map \
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

                        // Generate report for WiFi implementation MG24 BRD4186C + RS9116
                        wifiSizeTrackingApp.each { app ->
                            sh """unset OTEL_EXPORTER_OTLP_ENDPOINT
                                code_size_analyzer_cli \
                                --map_file out/${app}_wifi_rs911x/BRD4186C/*.map \
                                --stack_name matter \
                                --target_part efr32mg24b210f1536im48 \
                                --compiler gcc \
                                --target_board BRD4186C \
                                --app_name ${app}-WiFi-MG24 \
                                --service_url https://code-size-analyzer.silabs.net \
                                --branch_name ${env.BRANCH_NAME} \
                                --build_number b${env.BUILD_NUMBER} \
                                --output_file ${app}-WiFi-MG24.json \
                                --store_results True \
                                --verify_ssl False
                            """
                        }


                    } catch (e) {
                        deactivateWorkspaceOverlay(advanceStageMarker.getBuildStagesList(),
                                                    workspaceTmpDir,
                                                    saveDir,
                                                    '-name no-files')
                        throw e
                    }

                    // Create dummy files to forward workspace to next stage
                    sh 'touch ./bugfix.txt'

                }
            }
            deactivateWorkspaceOverlay(advanceStageMarker.getBuildStagesList(),
                                       workspaceTmpDir,
                                       'matter/',
                                       '-name "bugfix.txt"')
        }
    }
}

def openThreadTestSuite(devicegoup, name, board)
{
    globalLock(credentialsId: 'hwmux_token_matterci', deviceGroup: devicegoup)
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
                                unstash 'BootLoader'

                                bootloaderPath=pwd()+'/bootloader_binaries'
                                echo 'bootloaderPath: '+bootloaderPath

                                sh '''
                                 pwd && ls -R
                                 chiptoolPath=`find $PWD -name "chip-tool" -print `
                                 echo chiptoolPath

                                '''
                            //  unstash 'CustomOpenThreadExamples'

                            }


                            def  ci_path="${WORKSPACE}/matter/out/CSA/"+name+"/OpenThread/standard/"
                            echo "ci_path: "+ci_path

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
                                    "BOOTLOADER_PATH=${bootloaderPath}",
                                    "_JAVA_OPTIONS='-Xmx3072m'"
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

def utfThreadTestSuite(devicegoup,testbed_name,app_name, matter_type , board, test_suite, manifestyaml,  testsequenceyaml )
{
    globalLock(credentialsId: 'hwmux_token_matterci', deviceGroup: devicegoup) {
       node("gsdkMontrealNode")
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

                            // dir('utf_core')
                            // {
                                // sh '''
                                // git checkout develop
                                // git pull
                            //    '''
                            //
                            // }

                            dir('matter')
                            {
                                    sh 'pwd '
                                    stashFolder = 'OpenThreadExamples-'+app_name+'-'+board
                                    echo "unstash folder: "+stashFolder
                                    unstash stashFolder
                                    unstash 'ChipTool'
                                    unstash 'BootLoader'

                                    bootloaderPath=pwd()+'/bootloader_binaries'
                                    echo 'bootloaderPath: '+bootloaderPath

                                    sh '''
                                    pwd && ls -R
                                    chiptoolPath=`find $PWD -name "chip-tool" -print `
                                    echo $chiptoolPath
                                    '''

                                    sh "cp out/CSA/${app_name}/OpenThread/standard/${board}/*.s37 ../manifest"

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
                                    "TESTBED_NAME=${testbed_name}",
                                    "BUILD_URL=$BUILD_URL",
                                    "JENKIN_RUN_NUM=$BUILD_NUMBER",
                                    "JENKINS_JOB_NAME=$JOB_NAME",
                                    "JENKINS_SERVER_NAME=$JENKINS_URL",
                                    "JENKINS_TEST_RESULTS_URL=$JOB_URL$BUILD_NUMBER/testReport",
                                    // vars required for matter test execution (?)
                                    "BOARD_ID=${board}",
                                    "MATTER_APP_EXAMPLE=${app_name}",
                                    'RUN_SUITE=true',
                                    "MATTER_TYPE = ${matter_type}",
                                    'PUBLISH_RESULTS=true', // unneeded?
                                    'RUN_TCM_SETUP=false',  // unneeded?
                                    "MATTER_CHIP_TOOL_PATH=${chiptoolPath}" ,
                                    "BOOTLOADER_PATH=${bootloaderPath}",
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
                                            executor/launch_utf_tests.sh --publish_test_results true --harness  ${TESTBED_NAME}.yaml --executor_type local --pytest_command "pytest --tb=native tests${test_suite} --manifest manifest${manifestyaml}.yaml ${testsequenceyaml}"
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


def utfWiFiTestSuite(devicegoup, testbed_name, app_name, matter_type, board, wifi_module, test_suite,manifestyaml,  testsequenceyaml)
{
    globalLock(credentialsId: 'hwmux_token_matterci', deviceGroup: devicegoup) {
       node("gsdkMontrealNode")
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

                            // dir('utf_core')
                            // {
                                // sh '''
                                // git checkout develop
                                // git pull
                            //    '''
                            //
                            // }

                            dir('matter')
                            {
                                stashFolder = 'WiFiExamples-'+app_name+'-'+board+'-'+wifi_module
                                unstash stashFolder
                                unstash 'ChipTool'
                                unstash 'BootLoader'

                                bootloaderPath=pwd()+'/bootloader_binaries'
                                echo 'bootloaderPath: '+bootloaderPath

                                sh '''
                                  pwd && ls -R
                                  chiptoolPath=`find $PWD -name "chip-tool" -print `
                                  echo $chiptoolPath
                                 '''

                                sh "cp out/${app_name}_wifi_${wifi_module}/${board}/*.s37 ../manifest"

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
                                    "TESTBED_NAME=${testbed_name}",
                                    "BUILD_URL=$BUILD_URL",
                                    "JENKIN_RUN_NUM=$BUILD_NUMBER",
                                    "JENKINS_JOB_NAME=$JOB_NAME",
                                    "JENKINS_SERVER_NAME=$JENKINS_URL",
                                    "JENKINS_TEST_RESULTS_URL=$JOB_URL$BUILD_NUMBER/testReport",
                                    // vars required for matter test execution (?)
                                    "BOARD_ID=${board}",
                                    "MATTER_APP_EXAMPLE=${app_name}",
                                    'RUN_SUITE=true',
                                 //   "MATTER_TYPE = ${matter_type}",
                                    'MATTER_TYPE = wifi',
                                    'PUBLISH_RESULTS=true', // unneeded?
                                    'RUN_TCM_SETUP=false',  // unneeded?
                                    "MATTER_CHIP_TOOL_PATH=${chiptoolPath}" ,
                                    "BOOTLOADER_PATH=${bootloaderPath}",
                                    'DEBUG=true'
                                ])
                                {
                                    catchError(buildResult: 'UNSTABLE',
                                               catchInterruptions: false,
                                               message: "[ERROR] One or more tests have failed",
                                               stageResult: 'UNSTABLE')
                                    {
                                      //  pytestParam="\"pytest --tb=native tests${test_suite} --manifest manifest${manifestyaml}.yaml ${testsequenceyaml}\""
                                        sh """
                                            echo ${TESTBED_NAME}
                                            ./workspace_setup.sh
                                            executor/launch_utf_tests.sh --publish_test_results true --harness  ${TESTBED_NAME}.yaml --executor_type local --pytest_command "pytest --tb=native tests${test_suite} --manifest manifest${manifestyaml}.yaml ${testsequenceyaml}"
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

def pushToNexus()
{
    actionWithRetry {
        node(buildFarmLabel)
        {
            def workspaceTmpDir = createWorkspaceOverlay(advanceStageMarker.getBuildStagesList(),
                                                            buildOverlayDir)
            def dirPath = workspaceTmpDir + createWorkspaceOverlay.overlayMatterPath
            def saveDir = 'matter/'

            dir(dirPath) {
                try{
                    withCredentials([usernamePassword(credentialsId: 'svc_gsdk', passwordVariable: 'SL_PASSWORD', usernameVariable: 'SL_USERNAME')])
                    {

                        sh '''#!/usr/bin/env bash
                            set -o pipefail
                            set -x
                            pwd
                            file="build-binaries.zip"

                            zip -r "${file}" out
                            ls -al

                            status_code=$(curl -s  -w "%{http_code}" --upload-file "$file" \
                                            -X PUT "https://nexus.silabs.net/repository/matter/${JOB_BASE_NAME}/${BUILD_NUMBER}/$file"\
                                            -u $SL_USERNAME:$SL_PASSWORD -H 'Content-Type: application/octet-stream'
                                            )
                                    if [[ "$status_code" -ne 201 ]] ; then
                                            echo "$file File upload was not successful.\nStatus Code: $status_code"
                                            exit 1
                                    else
                                            echo "$file File upload was successful."
                                    fi

                        '''
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
        def openThreadBoards = [:]

        // Build only for release candidate branch
        if (env.BRANCH_NAME.startsWith('RC_')) {
            openThreadBoards = ["BRD4161A", "BRD4162A", "BRD4163A", "BRD4164A", "BRD4166A", "BRD4186C", "BRD4187C", "BRD2703A", "BRD4316A", "BRD4317A", "BRD4319A"]
        } else {
            openThreadBoards = ["BRD4161A", "BRD4166A", "BRD4187C", "BRD2703A","BRD4316A", "BRD4319A" ]
        }
        def openThreadApps = ["lighting-app", "lock-app", "light-switch-app", "window-app"]

        openThreadApps.each { appName ->
            openThreadBoards.each { board ->
                parallelNodesBuild["OpenThread " + appName + " " + board]      = { this.buildOpenThreadExample(appName, board)   }

            }
        }

        //---------------------------------------------------------------------
        // Build WiFi Examples
        //---------------------------------------------------------------------
        def wifiBoards = [:]

        // Build only for release candidate branch
        if (env.BRANCH_NAME.startsWith('RC_')) {
            wifiBoards = ["BRD4161A", "BRD4186C", "BRD4187C"]
        } else {
            wifiBoards = ["BRD4161A", "BRD4186C"]
        }

        def wifiApps = [ "lighting-app", "lock-app", "thermostat"]

        //TODO FIX ME Enable WF200 once silabs branch is updated with CSA for MG24 and WF200 support
        def wifiRCP = ["rs911x"]
        //  def wifiRCP = ["rs911x", "wf200"]

        wifiApps.each { appName ->
            wifiBoards.each { board ->
                wifiRCP.each { rcp ->
                    parallelNodesBuild["WiFi " + appName + " " + board + " " + rcp]      = { this.buildWiFiExample(appName, board, rcp)   }
                }
            }
        }

        //---------------------------------------------------------------------
        // Build Custom examples
        //---------------------------------------------------------------------
        def boardsForCustom = [:]
        def silabsExamples = ["onoff-plug-app", "sl-newLight", "template"]

        if (env.BRANCH_NAME.startsWith('RC_')) {
            boardsForCustom = ["BRD4161A", "BRD4186C", "BRD4187C", "BRD4166A"]
        } else {
             boardsForCustom = ["BRD4161A", "BRD4186C", "BRD4166A"]
        }

        silabsExamples.each { example ->
            boardsForCustom.each { board ->
                parallelNodesBuild["Custom " + example + " " + board]      = { this.buildSilabsCustomOpenThreadExamples(example, board)   }
            }
        }

        //---------------------------------------------------------------------
        // Build Tooling
        //---------------------------------------------------------------------
        parallelNodesBuild['Build Chip-tool ']           = { this.buildChipTool()   }

        parallelNodesBuild.failFast = false
        parallel parallelNodesBuild

    }

    if (env.BRANCH_NAME == "silabs" ) {
        stage("Code Size analysis")
        {
            advanceStageMarker()
            exportIoTReports()
        }
    }

    stage("Push to Nexus")
    {
        advanceStageMarker()
        pushToNexus()
    }
     stage('SQA')
    {
      // advanceStageMarker()
        //even openthread test in parallel, they actually run in sequence as they are using same raspi
        def parallelNodes = [:]
        parallelNodes['lighting Thread BRD4187C']   = { this.utfThreadTestSuite('utf_matter_thread','matter_thread','lighting-app','thread','BRD4187C','',"/manifest-4187-thread","--tmconfig tests/.sequence_manager/test_execution_definitions/matterci_test_sequence_thread.yaml") }
        parallelNodes['lighting Thread BRD4161A']   = { this.utfThreadTestSuite('utf_matter_thread','matter_thread','lighting-app','thread','BRD4161A','',"/manifest-4161-thread","--tmconfig tests/.sequence_manager/test_execution_definitions/matterci_test_sequence_thread_4161.yaml") }
        parallelNodes['lighting Thread BRD2703A']   = { this.utfThreadTestSuite('utf_matter_thread_2','matter_thread_2','lighting-app','thread','BRD2703A','',"/manifest-2703-thread","--tmconfig tests/.sequence_manager/test_execution_definitions/matterci_test_sequence_thread.yaml") }
        parallelNodes['lighting rs9116 BRD4161A']   = { this.utfWiFiTestSuite('utf_matter_ci','INT0014944','lighting-app','wifi','BRD4161A','rs911x','',"/manifest","--tmconfig tests/.sequence_manager/test_execution_definitions/matterci_test_sequence.yaml") }

        parallelNodes.failFast = false
        parallel parallelNodes

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
