#!/usr/bin/env groovy

def call(String buildVersion, String sonarPro, Object checkmarxpro, Object gitPro, String jfrogPro, Object ECRPro, Object stageToggle, Object envPro){
pipeline{
    agent{
        node {
            label 'linux'
        }
    }
    tools{
        maven envPro.mavenVersion
        jdk envPro.jdkVersion
    }
    stages{
        stage('git pull'){
            steps{
                step([$class: 'WsCleanup',disableDeferredwipeout: true])
                println 'Started checkout from Git'
                git branch: gitPro.gitProjectBranch, credentialsId: gitPro.gitCredentials, poll: false, url: gitPro.gitUrl
                println 'Completed checkout from Git'
            }
        }
        stage('Build and Test'){
            steps{
                println "build process start ${buildVersion}"
                sh "mvn clean test"
            }
            println "build and test is completed"
        }
        stage('Generate documentation'){
            when {
                expression { stageToggle.generateSite}
            }
            steps{
                println 'Generate site documentation'
                sh 'mvn site:site'
            }
            println 'completed site documentation'
        }
        stage('static code analysis'){
            when{
                expression { stageToggle.sonarQualityCheck}
            }
            steps{
                println 'start sonarqube check'{
                    withSonarQubeEnv(installationName: sonarInstallationName){
                        sh 'mvn clean package sonar:sonar'
                    }
                }
                println 'completed sonarqube check'
                sleep 20
            }
        }
        stage('quality gateway'){
            when {
                expression { stageToggle.sonarQualityCheck}
            }
            steps{
                println 'starting quality gate'
                timeout(time: 15, unit: 'MINUTES'){
                    waitForQualityGate abortPipeline: true
                }
            }
            println 'completed quality gate'
        }
        stage('checkmarx check'){
            when {
                expression { stageToggle.checkmarxAnalysis}
            }
           step([$class: 'CxScanBuilder',
                    comment: '',
                    credentialsId: '',
                    excludeFolders: checkmarxpro.checkMarxExcludeFolder,
                    excludeOpenSourceFolders: '',
                    exclusionsSetting: 'global',
                    failBuildOnNewResults: false,
                    failBuildOnNewSeverity: 'MEDIUM',
                    filterPattern: '''!**/_cvs/**/*, !Checkmarx/Reports/*.*''',
                    fullScanCycle: 10,
                    groupId: checkmarxpro.checkMarxgroupId,
                    includeOpenSourceFolders: '',
                    osaArchiveIncludePatterns: '*.zip, *.war, *.ear, *.tgz',
                    osaInstallBeforeScan: false,
                    password: '{}',
                    preset: '36',
                    projectName: checkmarxpro.checkMarxProjectName,
                    sastEnabled: true,
                    serverUrl: checkmarxpro.checkMarxServerURL,
                    sourceEncoding: '1',
                    username: '',
                    vulnerabilityThresholdResult: 'FAILURE',
                    waitForResultsEnabled: true])                    
            }
            stage('push to jfrog'){
                steps{
                    println 'push to artifactory'
                    sh 'mvn version:set -DnewVersion=${buildVersion}'
                    sh 'mvn clean deploy ${MAVEN_OPTS}'
                }
                println 'publish the artifact into jfrog'
            }
            stage('push to ecr'){
                when {
                    expression { stageToggle.pushToECR}
                }
                steps{
                    sh 'docker login -u AWS -p $(aws ecr get-login-password --region us-east-1)'
                    sh 'docker build -t ecr-repo:${env.BUILD_NUMBER}' -f dockerfile-path 
                    sh 'docker push ecr-repo:${buildVersion}'
                }
            }
            stage('change manifest file '){
                when {
                    expression { envPro.env == 'dev'}
                }
                steps{
                    git credentialsId: GIT_CREDENTIALS_ID, url: 'https://github.com/meeran2019/microservice-architecture/tree/develop/helm'
                    sh """
                        cd helm
                        sed -i 's|image: .*|image: ecr-repo:${buildVersion}|' ${env}/values.yaml
                    """
                    // Commit and push the changes
                    sh """
                        git add ${env}/values.yaml
                        git commit -m "Update Docker image tag for ${env} environment"
                        git push origin HEAD
                    """

                }
            }

        }

    }
}
}