#!groovy
@Library('gsdk-shared-lib@master')
import groovy.json.JsonSlurper
properties([disableConcurrentBuilds()])

buildOverlayDir = ''
//TO DO, this is for SQA UTF testing, this value should get from db or somewhere instead of hardcoded
RELEASE_NAME='22Q4-GA'
stashFolder = ''
chiptoolPath = ''
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
        sh 'scripts/checkout_submodules.py --shallow --recursive --platform efr32'
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

                stash name: 'OpenThreadExamples-'+app+'-'+board, includes: 'out/CSA/*/OpenThread/release/**/*.map ,'+
                                                                                      'out/CSA/*/OpenThread/standard/**/*.s37 ,' +
                                                                                      'out/CSA/*/OpenThread/release/**/*.s37 '

            }
            deactivateWorkspaceOverlay(advanceStageMarker.getBuildStagesList(),
                                       workspaceTmpDir,
                                       'matter/out/',
                                       '-name "*.s37" -o -name "*.map"')
        }
    }
}



def buildSilabsCustomOpenThreadExamples(board)
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
                            sh "python3 ./silabs_ci_scripts/build_custom_examples.py \"${board}\""
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
                withDockerContainer(image: "nexus.silabs.net/connectedhomeip/chip-build-crosscompile:latest",args: "-u root")
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

                sh 'pip3 install code_size_analyzer_client-python'
                sh 'python3 ./silabs_ci_scripts/iot_reports.py'
                sh 'find ./ -name "*.json"'

                    if (env.BRANCH_NAME == "silabs") {
                        // TODO : @Gabe Ash When you got time.
                        // Path to samba share : smb://usfs01/Shared/QA/ArchiveBuilds/code_size/matter_non-gsdk

                        // sh 'cp -rf ./out/iot_reports/*  <path to samba share/b${BUILD_NUMBER}/>'
                        // sh 'touch <path to samba share/b${BUILD_NUMBER}/COMPLETE'
                    }
                    else {
                        sh 'echo "Not uploading reports"'
                    }

                    // Create dummy files to forward workspace to next stage
                    sh 'touch ./bugfix.txt'
            }
            deactivateWorkspaceOverlay(advanceStageMarker.getBuildStagesList(),
                                       workspaceTmpDir,
                                       'matter/',
                                       '-name "bugfix.txt"')
        }
    }
}

def openThreadTestSuite(name, board)
{
    lock('Matter-Testbed') 
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
                                stashFolder = 'OpenThreadExamples-'+name+"-app-"+board
                                echo "unstash folder: "+stashFolder
                                unstash stashFolder
                                unstash 'ChipTool'
                                sh '''
                                 pwd && ls -R
                                 chiptoolPath=`find $PWD -name "chip-tool" -print `
                                 echo chiptoolPath
                                '''
                            //  unstash 'CustomOpenThreadExamples'

                            }


                            def  ci_path="${WORKSPACE}/matter/out/CSA/"+name+"-app/OpenThread/standard/"
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
                                    stashFolder = 'OpenThreadExamples-'+app_name+"-app-"+board
                                    echo "unstash folder: "+stashFolder
                                    unstash stashFolder
                                    unstash 'ChipTool'

                                    sh '''
                                    pwd && ls -R
                                    chiptoolPath=`find $PWD -name "chip-tool" -print `
                                    echo $chiptoolPath
                                    '''

                                    sh "cp out/CSA/${app_name}-app/OpenThread/standard/${board}/*.s37 ../manifest"

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
                                stashFolder = 'WiFiExamples-'+app_name+'-app-'+board+'-'+wifi_module
                                unstash stashFolder
                                unstash 'ChipTool'
                                sh '''
                                  pwd && ls -R
                                  chiptoolPath=`find $PWD -name "chip-tool" -print `
                                  echo $chiptoolPath
                                 '''
                                
                                sh "cp out/${app_name}-app_wifi_${wifi_module}/${board}/*.s37 ../manifest"

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

    stage('Build OpenThread Examples')
    {
        advanceStageMarker()
        // build library dependencies
        def parallelNodes = [:]
        def openThreadBoards = [:]

        if (env.BRANCH_NAME == "silabs") {
            openThreadBoards = ["BRD4161A", "BRD4162A", "BRD4163A", "BRD4164A", "BRD4166A", "BRD4186C", "BRD4187A", "BRD4187C", "BRD2703A"]
        } else {
            openThreadBoards = ["BRD4161A", "BRD4166A", "BRD4187A", "BRD4187C", "BRD2703A" ]
        }
        def openThreadApps = ["lighting-app", "lock-app", "light-switch-app", "window-app"]

        openThreadApps.each { appName ->
            openThreadBoards.each { board ->
                parallelNodes[appName + " " + board]      = { this.buildOpenThreadExample(appName, board)   }

            }
        }


        parallelNodes.failFast = false
        parallel parallelNodes
    }

    stage("Build WiFi Examples")
    {
        advanceStageMarker()
        def parallelNodes = [:]
        def wifiBoards = [:]

        if (env.BRANCH_NAME == "silabs") {
            wifiBoards = ["BRD4161A", "BRD4186C", "BRD4187C"]
        } else {
            wifiBoards = ["BRD4161A", "BRD4186C"]
        }

        def wifiApps = [ "lighting-app", "lock-app", "thermostat"]

        // TODO FIX ME Enable WF200 once silabs branch is updated with CSA for MG24 and WF200 support
        def wifiRCP = ["rs911x"]
        // def wifiRCP = ["rs911x", "wf200"]

        wifiApps.each { appName ->
            wifiBoards.each { board ->
                wifiRCP.each { rcp ->
                    parallelNodes[appName + " " + board + " " + rcp]      = { this.buildWiFiExample(appName, board, rcp)   }
                }
            }
        }

        parallelNodes.failFast = false
        parallel parallelNodes

    }


    // TODO re-enable when PR #70 is merged
    // stage("Build Custom examples")
    // {
    //     advanceStageMarker()
    //     // build library dependencies
    //     def parallelNodes = [:]
    //     def boardsForCustom = [:]

    //     if (env.BRANCH_NAME == "silabs") {
    //         boardsForCustom = ["BRD4161A", "BRD4186C", "BRD4187C"]
    //     } else {
    //         boardsForCustom = ["BRD4161A", "BRD4186C"]
    //     }

    //     boardsForCustom.each { board ->
    //         parallelNodes[board]      = { this.buildSilabsCustomOpenThreadExamples(board)   }
    //     }

    //     parallelNodes.failFast = false
    //     parallel parallelNodes
    // }

    stage("Build Tooling")
    {
        advanceStageMarker()
        // build library dependencies
        def parallelNodes = [:]


        parallelNodes['Build Chip-tool ']           = { this.buildChipTool()   }

        parallelNodes.failFast = false
        parallel parallelNodes

    }

    // TODO JIRA : MATTER-69
    // if (env.BRANCH_NAME == "silabs") {
    //     stage("Code Size analysis")
    //     {
    //         advanceStageMarker()
    //         exportIoTReports()
    //     }
    // }

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

        parallelNodes['Junit lighting BRD4161A']       = { this.openThreadTestSuite("lighting","BRD4161A") }
        parallelNodes['Junit lighting BRD4187A']       = { this.openThreadTestSuite("lighting","BRD4187A")   }

        parallelNodes['lighting Thread BRD4187C']   = { this.utfThreadTestSuite('utf_matter_thread','matter_thread','lighting','thread','BRD4187C','',"/manifest-4187-thread","--tmconfig tests/.sequence_manager/test_execution_definitions/matterci_test_sequence_thread.yaml") }
        parallelNodes['lighting Thread BRD4161A']   = { this.utfThreadTestSuite('utf_matter_thread','matter_thread','lighting','thread','BRD4161A','',"/manifest-4161-thread","--tmconfig tests/.sequence_manager/test_execution_definitions/matterci_test_sequence_thread_4161.yaml") }
        parallelNodes['lighting Thread BRD2703A']   = { this.utfThreadTestSuite('utf_matter_thread_2','matter_thread_2','lighting','thread','BRD2703A','',"/manifest-2703-thread","--tmconfig tests/.sequence_manager/test_execution_definitions/matterci_test_sequence_thread.yaml") }

        parallelNodes['lighting rs9116 BRD4161A']   = { this.utfWiFiTestSuite('utf_matter_ci','INT0014944','lighting','wifi','BRD4161A','rs911x','',"/manifest","--tmconfig tests/.sequence_manager/test_execution_definitions/matterci_test_sequence.yaml") }

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
