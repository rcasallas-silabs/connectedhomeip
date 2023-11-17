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
        booleanParam(name: 'ECOSYSTEM_AUTOMATION_TEST', defaultValue: false, description: 'Set to true to generate additional SQA images for ecosystem testing'),
        // Allows the building of everything
        booleanParam(name: 'COMPLETE_BUILD', defaultValue: false, description: 'Set to true to build everything')
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
gsdkImage = "artifactory.silabs.net/gsdk-docker-production/gsdk_nomad_containers/gsdk_23q2:latest"

// Build everything
completeBuild = false

//This object will be populated by reading the pipeline_metadata.yml file
pipelineMetadata = null

// Populated with silabs_ci_scripts/pipeline/soc/apps.json & boards.json
appsToBuild = null
supportedBoards = null

// Populated with silabs_ci_scripts/pipeline/soc/soc.groovy
socFunctions = null


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
                 extensions                       : scm.extensions +  [$class: 'ScmName', name: 'matter'] +
                                                    // Shallow clone due to submodule URL conflicts
                                                    // Commit IDs/refs within submodules are resolved when running checkout_submodule.py script below
                                                    [cloneOption(honorRefspec: true, noTags: true, shallow: true)], 
                 userRemoteConfigs                : scm.userRemoteConfigs]                                          

        // Sync all submodule and ensure they are in proper state
        sh """
            git fetch || true && git fetch --tags
            git submodule sync --recursive
            git submodule foreach --recursive -q git reset --hard -q
        """
        
        sh 'git --version'
        sh 'git submodule update --init third_party/openthread/ot-efr32/'
        sh 'cd ./third_party/openthread/ot-efr32'
        // Switch Origin for the gecko_sdk to reduce dowload and cost
        sh 'git submodule set-url ./third_party/silabs/gecko_sdk https://stash.silabs.com/scm/embsw/gecko_sdk_release.git'
        sh 'cd ../../../'
        sh 'git submodule set-url ./third_party/silabs/gecko_sdk https://stash.silabs.com/scm/embsw/gecko_sdk_release.git'

        // Matter Init --Checkout relevant submodule
        sh 'scripts/checkout_submodules.py --shallow --platform efr32 linux'

        // Set Pipeline configuration
        pipelineMetadata = readYaml(file: 'pipeline_metadata.yml')
        completeBuild = env.BRANCH_NAME.startsWith('RC_') || params.COMPLETE_BUILD

        socFunctions = load './silabs_ci_scripts/pipeline/soc.groovy'
        appsToBuild = readJSON file: ('./silabs_ci_scripts/pipeline/apps.json')
        supportedBoards = readJSON file: ('./silabs_ci_scripts/pipeline/boards.json')

        dir('commander'){
            checkout scm: [$class               : 'GitSCM',
                            branches            : [[name: pipelineMetadata.commander_info.commanderBranch]],
                            browser             : [$class: 'Stash', repoUrl: pipelineMetadata.commander_info.browserUrl],
                            userRemoteConfigs   : [[credentialsId: 'svc_gsdk', url: pipelineMetadata.commander_info.gitUrl]]]

            sh "git checkout ${pipelineMetadata.commander_info.commanderTag}"
        }
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
        def build_args = ""
        def archname = arch - 'hf'
        if(arch != "amd64") {
            build_args = "--args='target_cpu=\"\\\"${archname}\\\"\"'"
        }
        sh "../../../scripts/run_in_build_env.sh \"${env_exports}; gn gen ${out_path} ${build_args}\""
        sh "../../../scripts/run_in_build_env.sh \"${env_exports}; ninja -C ${out_path}\""
    }
}

def buildUnify(arch, triples, app, compile_tests)
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

                    def unify_matter_docker = docker.image('artifactory.silabs.net/gsdk-docker-production/unify-cache/unify-matter:1.1.4-' + arch)
                    stage('unify ' + arch) {
                        dir(dirPath) {
                            unify_matter_docker.inside("-u root -v${unifyCheckoutDir}:/unify")
                            {
                                withEnv(['PW_ENVIRONMENT_ROOT=' + dirPath])
                                {
                                    // Build libunify
                                    echo "Build libunify for " + arch
                                    def toolchain = ""
                                    if(arch != "amd64") {
                                        toolchain = "-DCMAKE_TOOLCHAIN_FILE=../cmake/${arch}_debian.cmake"
                                    }
                                    sh 'cd /unify && cmake -DCMAKE_INSTALL_PREFIX=$PWD/stage_' + arch + ' -GNinja '+ toolchain + ' -B build_unify_' + arch + '/ -S components -DBUILD_TESTING=OFF'
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
                                        buildUnifyApp(arch, app, pkg_config_export, "silabs_examples/unify-matter-" + app + "/linux", "../../../out/silabs_examples/unify-matter-" + app + "/" + arch + "_debian_bullseye")

                                        // Complie and Execute Unit Tests
                                        if(compile_tests) {
                                            dir ("silabs_examples/unify-matter-" + app + "/linux")
                                            {
                                                sh "../../../scripts/run_in_build_env.sh \"${pkg_config_export}; ../../unify-matter-common/scripts/compile_tests.sh -t amd64\""
                                                sh "export LD_LIBRARY_PATH=/unify/stage_amd64/lib; ../../unify-matter-common/scripts/run_tests.sh -b out/amd64_test"
                                            }
                                        }
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
                                            def out_path = "../../out/examples/chip-tool/" + arch + "_debian_bullseye"
                                            def build_args = ""
                                            def archname = arch - 'hf'
                                            if(arch != "amd64") {
                                                build_args = "--args='target_cpu=\"\\\"${archname}\\\"\"'"
                                            }
                                            sh "../../scripts/run_in_build_env.sh \"${pkg_config_export}; gn gen ${out_path} ${build_args}\""
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


                            def  ci_path="${WORKSPACE}/matter/out/"+name+"/OpenThread/standard/"
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
                                    sh "cp out/${appName}/OpenThread/standard/${board}/*.s37 ../manifest"
                            }

                            withVault([vaultSecrets: secrets])
                            {
                                withEnv([
                                    // vars required for publish to database
                                    'UTF_QUEUE_SERVER_URL=amqps://' + SL_USERNAME + ':' + SL_PASSWORD + '@utf-queue-central.silabs.net:443/%2f',
                                    "UTF_PRODUCER_APP_ID=$BUILD_TAG",
                                    "RELEASE_NAME=$RELEASE_NAME",
                                    "STACK_NAME=matter",
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
    def wifiSoCBoards = ["BRD4325B", "BRD4325C", "BRD4338A"]
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

                                dir('commander'){
                                    checkout scm: [$class               : 'GitSCM',
                                                    branches            : [[name: pipelineMetadata.commander_info.commanderBranch]],
                                                    browser             : [$class: 'Stash', repoUrl: pipelineMetadata.commander_info.browserUrl],
                                                    userRemoteConfigs   : [[credentialsId: 'svc_gsdk-ssh', url: pipelineMetadata.commander_info.gitUrl]]]

                                    sh "git checkout ${pipelineMetadata.commander_info.commanderTag}"
                                    commanderPath = sh(script: "find " + pwd() + " -name 'commander' -type f -print",returnStdout: true).trim()
                                    echo commanderPath
                                }
                            }



                            dir('matter')
                            {
                                stashFolder = 'WiFiExamples-'+appName+'-'+board+'-'+wifi_module
                                unstash stashFolder
                                unstash 'ChipTool'

                                chiptoolPath = sh(script: "find " + pwd() + " -name 'chip-tool' -print",returnStdout: true).trim()
                                echo chiptoolPath

                                if (wifiSoCBoards.contains(board)){
                                    stashFolder = 'WiFiExamples-'+appName+'-'+board+'-'+wifi_module
                                    unstash stashFolder

                                    sh "cp saved_workspace/out/standard/${board}/WiFi/*.rps ../manifest"
                                } else {
                                    sh "cp out/${appName}_wifi_${wifi_module}/${board}/*.s37 ../manifest"
                                }

                            }

                            withVault([vaultSecrets: secrets])
                            {
                                withEnv([
                                    // vars required for publish to database
                                    'UTF_QUEUE_SERVER_URL=amqps://' + SL_USERNAME + ':' + SL_PASSWORD + '@utf-queue-central.silabs.net:443/%2f',
                                    "UTF_PRODUCER_APP_ID=$BUILD_TAG",
                                    "RELEASE_NAME=$RELEASE_NAME",
                                    "STACK_NAME=matter",
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
                                    'DEBUG=true',
                                    "UTF_COMMANDER_PATH=${commanderPath}",
                                    "TCM_SIMPLICITYCOMMANDER=${commanderPath}",
                                    "SECMGR_COMMANDER_PATH=${commanderPath}"
                                ])
                                {
                                    catchError(buildResult: 'UNSTABLE',
                                               catchInterruptions: false,
                                               message: "[ERROR] One or more tests have failed",
                                               stageResult: 'UNSTABLE')
                                    {

                                        sh 'printenv'
                                        sh """
                                            echo ${TESTBED_NAME}
                                            ${commanderPath} --version
                                            ./workspace_setup.sh
                                            pwd
                                            ls
                                            ${commanderPath} --version
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
            def commanderPath = dirPath + "/commander/commander"
            // Closure to generate the gbl and ota files
            def genFiles = {app, tech, board, radioName ->

                sh """
                        ls ${workspaceTmpDir}
                        pwd
                        ${commanderPath} --version

                        if [ "${tech}" = "OpenThread" ] ; then
                            bin_path="${dirPath}/${saved_workspace}/out/OTA/ota_automation_out/${app}/${board}/OpenThread/"
                            file="\$(find \$bin_path/ -name \\*.s37 | grep -o '[^/]*\$')"
                        else
                            bin_path="${dirPath}/${saved_workspace}/out/OTA/ota_automation_out/${app}/${board}/WiFi/"
                            file="\$(find \$bin_path/ -name efr32-${radioName}-lighting-example.s37 | grep -o '[^/]*\$')"
                        fi

                        gbl_file="\$(basename \$file .s37).gbl"
                        ota_file="\$(basename \$file .s37).ota"

                        ${commanderPath} gbl create \$bin_path/\$gbl_file --app \$bin_path/\$file
                        ${dirPath}/src/app/ota_image_tool.py create -v 0xFFF1 -p 0x8005 -vn 2 -vs 2.0 -da sha256 \$bin_path/\$gbl_file \$bin_path/\$ota_file

                        ls -al \$bin_path

                    """
                return 0
            }

            withDockerRegistry([url: "https://artifactory.silabs.net ", credentialsId: 'svc_gsdk']){
                sh "docker pull $gsdkImage"
            }

            dir(dirPath) {
                try{
                    withDockerContainer(image: gsdkImage)
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
            def boards = "BRD4325B,BRD4338A"
            if (completeBuild){
                boards = boards + ",BRD4325C"
            }
            def wifiPlatforms = "917_soc"
            def appName = "lighting,lock,light-switch,onoff-plug,window"
            def stashExample = "lighting-app"
            def workspaceTmpDir = createWorkspaceOverlay(advanceStageMarker.getBuildStagesList(),
                                                            buildOverlayDir)
            def dirPath = workspaceTmpDir + createWorkspaceOverlay.overlayMatterPath
            def saveDir = 'matter/'

            def commanderPath = dirPath + "/commander/commander"

            // Closure to generate the rps files
            def genRpsFiles = {app, board, radioName ->

                sh """
                        ls ${workspaceTmpDir}
                        pwd
                        ${commanderPath} --version

                        bin_path_std="${dirPath}/${saved_workspace}/out/standard/${board}/WiFi/"
                        bin_path_release="${dirPath}/${saved_workspace}/out/release/${board}/WiFi/"
                        file_std="\$(find \$bin_path_std/*${app}*.s37 | grep -o '[^/]*\$')"
                        file_release="\$(find \$bin_path_release/*${app}*.s37 | grep -o '[^/]*\$')"

                        rps_file_std="\$(basename \$file_std .s37).rps"
                        rps_file_release="\$(basename \$file_release .s37).rps"

                        ${commanderPath} rps create \$bin_path_std/\$rps_file_std --app \$bin_path_std/\$file_std
                        ${commanderPath} rps create \$bin_path_release/\$rps_file_release --app \$bin_path_release/\$file_release

                        ls -al \$bin_path_std
                        ls -al \$bin_path_release

                    """
                return 0
            }

            withDockerRegistry([url: "https://artifactory.silabs.net ", credentialsId: 'svc_gsdk']){
                sh "docker pull $gsdkImage"
            }

            dir(dirPath) {
                try{
                    withDockerContainer(image: gsdkImage)
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
                                        // generating the RPS file for 917 SoC
                                        genRpsFiles.call(app, brd, platform)
                                    }
                                }
                                // stashing the lighting rps file which will be used later in the utf
                                stash name : 'WiFiExamples-' + stashExample + '-' + brd + '-917_soc', includes: "saved_workspace/out/standard/" + "${brd}" + "/WiFi/*lighting*.rps"
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
                    if (completeBuild){
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

                                    # Upload Build Binaries

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

                                    echo 'Uploading build binaries to UBAI... '
                                    ubai_upload_cli --client-id jenkins-gsdk-pipelines-Matter --file-path "${file}"  --metadata app_name matter \
                                            --metadata branch ${JOB_BASE_NAME} --metadata build_number ${BUILD_NUMBER} --metadata stack matter --metadata target matter  --username ${SL_USERNAME} --password ${SL_PASSWORD}

                                    if [ $? -eq 0 ]; then
                                        echo 'Build binaries successfully uploaded to UBAI... '
                                    else
                                        echo FAIL
                                    fi

                                    # Upload Provisioning tool

                                    file="provision.zip"
                                    cd ..
                                    rm -f "${file}"
                                    zip -r "${file}" "provision" -x "provision/config/latest.json" -x "provision/support/*" -x "provision/modules/__pycache__/*" -x "provision/temp/*"

                                    echo 'Uploading provisioning tool to UBAI... '
                                    ubai_upload_cli --client-id jenkins-gsdk-pipelines-Matter --file-path "${file}"  --metadata app_name matter_provision \
                                            --metadata branch ${JOB_BASE_NAME} --metadata build_number ${BUILD_NUMBER} --metadata stack matter --metadata target matter  --username ${SL_USERNAME} --password ${SL_PASSWORD}

                                    if [ $? -eq 0 ]; then
                                        echo 'Provisioning tool successfully uploaded to UBAI... '
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

    // This stage can fails but it should carry on neitherless.
    // SQA tests are still valuable data even if a single board fail.
    stage("Build")
    {
        advanceStageMarker()
        try {

            //---------------------------------------------------------------------
            // Build Unify Matter Bridge and PC
            //---------------------------------------------------------------------
            if(params.BUILD_UNIFY_MATTER == true || completeBuild) {
                parallelNodesBuild["Unify Matter Bridge ARM64"] =
                {
                    // Currently official supported platform
                    this.buildUnify("arm64","aarch64-linux-gnu", "bridge", false)
                }
                parallelNodesBuild["Unify Matter PC ARM64"] =
                {
                    // Currently official supported platform
                    this.buildUnify("arm64","aarch64-linux-gnu", "pc", false)
                }
                parallelNodesBuild["Unify Matter Bridge ARMHF"] =
                {
                    this.buildUnify("armhf","arm-linux-gnueabihf", "bridge", false)
                }
                parallelNodesBuild["Unify Matter PC ARMHF"] =
                {
                    this.buildUnify("armhf","arm-linux-gnueabihf", "pc", false)
                }
                parallelNodesBuild["Unify Matter Bridge AMD64"] =
                {
                    this.buildUnify("amd64","x86_64-linux-gnu", "bridge", true)
                }
                parallelNodesBuild["Unify Matter PC AMD64"] =
                {
                    this.buildUnify("amd64","x86_64-linux-gnu", "pc", true)
                }
            }
            //---------------------------------------------------------------------
            // Build SoC Examples
            //---------------------------------------------------------------------
            appsToBuild.apps.each { app ->
                parallelNodesBuild["Matter " + app.name ]      = { socFunctions.genericSoCMatterBuild(app, supportedBoards)   }
            }

            //---------------------------------------------------------------------
            // Build Tooling
            //---------------------------------------------------------------------
            parallelNodesBuild['Build Chip-tool and OTA-Provider '] = { this.buildChipToolAndOTAProvider()   }

            parallelNodesBuild.failFast = false
            parallel parallelNodesBuild
        } catch (err) {
            unstable(message: "Some build failures occured")
        }

    }

    // Code Size should only be on silabs branch and release candidate branch
    if (env.BRANCH_NAME.startsWith('silabs') || env.BRANCH_NAME.startsWith('RC_')) {
        stage("Code Size analysis")
        {
            advanceStageMarker()
            exportIoTReports()
        }
    }
    def parallelNodesImages = [:]

    if(params.OTA_AUTOMATION_TEST == true || env.BRANCH_NAME.startsWith('RC_')){
        stage("Generate Gbl/Ota files"){
            advanceStageMarker()
            generateGblFileAndOTAfiles()
        }
    }

    // This stage can fail should the SiW917 builds fail.
    // Do not stop the pipeline if this is the case.
    // SQA test can still run on OpenThread boards.
    stage("Generate RPS files")
    {
        // Generating the RPS file for 917 SoC
        advanceStageMarker()
        try {
            generateRpsFiles()
        } catch (err) {
            unstable(message: "Some build failures occured")
        }

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
        parallelNodes['lighting Thread BRD4187C']   = { this.utfThreadTestSuite('gsdkMontrealNode','utf_matter_thread','matter_thread','lighting','thread','BRD4187C','',"/manifest-4187-thread","--tmconfig tests/.sequence_manager/test_execution_definitions/matter_thread_ci_sequence.yaml") }
        // parallelNodes['lighting Thread BRD2703A']   = { this.utfThreadTestSuite('gsdkMontrealNode','utf_matter_thread_2',
        //                                                                         'matter_thread_2','lighting-app','thread','BRD2703A','',
        //                                                                         "/manifest-2703-thread",
        //                                                                         "--tmconfig tests/.sequence_manager/test_execution_definitions/matter_thread_ci_sequence.yaml") }
        parallelNodes['lighting Thread BRD4161A']   = { this.utfThreadTestSuite('gsdkMontrealNode','utf_matter_thread_4','matter_thread_4','lighting','thread','BRD4161A','',"/manifest-4161-thread","--tmconfig tests/.sequence_manager/test_execution_definitions/matter_thread_ci_sequence.yaml") }
        parallelNodes['lighting 917-SoC BRD4338A']   = { this.utfWiFiTestSuite('gsdkMontrealNode','utf_matter_wifi_917soc_ci_2','matter_wifi_917soc_ci_2','lighting-app','wifi','BRD4338A','917_soc','',"/manifest-917soc","--tmconfig tests/.sequence_manager/test_execution_definitions/matter_wifi_ci_sequence.yaml") }
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
