def genericSoCMatterBuild(app, supportedBoards, ota_automation=false, ecosystem_automation=false)
{
    actionWithRetry {
        node(buildFarmLargeLabel)
        {
            def workspaceTmpDir = createWorkspaceOverlay(advanceStageMarker.getBuildStagesList(),
                                                            buildOverlayDir)
            def dirPath = workspaceTmpDir + createWorkspaceOverlay.overlayMatterPath
            def saveDir = 'matter/'
            def out_dir = saved_workspace
            def transportType = "OpenThread"
            def commanderPath = dirPath + "/commander/commander"

            withDockerRegistry([url: "https://artifactory.silabs.net ", credentialsId: 'svc_gsdk']){
                sh "docker pull $chipBuildEfr32Image"
            }

            try {
                supportedBoards.families.each { family ->
                    stage(app.name + ' ' + family.name) {
                        dir(dirPath) {
                            try {
                                withDockerContainer(image: chipBuildEfr32Image, args: "-u root")
                                {
                                    // CSA Examples build
                                    withEnv(['PW_ENVIRONMENT_ROOT='+dirPath,
                                             'COMMANDER_PATH='+commanderPath,
                                             'MATTER_ROOT='+dirPath])
                                    {
                                        app.appBuildArgs.each { appBuildArg ->
                                            family.boards.each { board ->
                                                if (! app.boards.contains(board.name) ) {
                                                    // Board not targeted for the sample app
                                                    return
                                                }


                                                board.options.each {option ->
                                                    if (! app.variants.contains("all"))
                                                    {
                                                        if (! app.variants.contains(option.name) )
                                                        {
                                                            // Board variant not needed for this app
                                                            return
                                                        }
                                                    }


                                                    board.rcp.each { rcp ->
                                                        if (! app.rcp.contains(rcp) ) {
                                                            // RCP not targeted for the sample app
                                                            return
                                                        }


                                                        if (family.isWiFi || rcp != "") {
                                                            transportType = "WiFi"
                                                        } else {
                                                            transportType = "OpenThread"
                                                        }

                                                        sh "echo Building ${board.name} type ${option.name}"

                                                        sh """./scripts/examples/gn_silabs_example.sh ${app.path} ./out/${app.name}/${transportType}/${option.name} ${board.name} ${appBuildArg.option} ${option.compilationFlags}
                                                                mkdir -p ${saved_workspace}/out/${option.name}/${board.name}/${transportType}
                                                                cp ./out/${app.name}/${transportType}/${option.name}/${board.name}/*.s37 ${saved_workspace}/out/${option.name}/${board.name}/${transportType}/
                                                                cp ./out/${app.name}/${transportType}/${option.name}/${board.name}/*.map ${saved_workspace}/out/${option.name}/${board.name}/${transportType}/
                                                        """
                                                        
                                                        if (family.isWiFi) // WiFi SoC generates as .rps file
                                                        {
                                                            sh """
                                                            cp ./out/${app.name}/${transportType}/${option.name}/${board.name}/*.rps ${saved_workspace}/out/${option.name}/${board.name}/${transportType}/
                                                            """
                                                        }

                                                        stash name: transportType + 'Examples-'+app.name+'-'+board.name, includes: 'out/**/*.s37,/out/**/*.rps '
                                                    }
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
                            '-name "*.s37" -o -name "*.map" -o -name "*.rps"')
        }
    }
}

return this
