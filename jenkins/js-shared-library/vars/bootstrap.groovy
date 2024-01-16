#!/usr/bin/env groovy

def call(String buildVersion, Object gitProperties, Object stageToggle, String env){
pipeline {
    agent {
        node {
            label "name"
        }
    }
    stages{
        stage('npm install'){
            steps{
                sh """
                node --version
                npm --version
                npm install
                """
            }
        }
        stage('linting'){
            sh """
            npm run ${npmscripts.linting}
            """
        }
        stage('build'){
            steps{
            println "build the artifacts"
            sh """
            npm run ${npmscripts.ngbuild}
            """
        }
        }
        stage('push to artifactory'){
            steps{
                curl -u user:pwd -X PUT jfrog-url
            }
        }
        stage('publish to ecr'){
            when {
                expression { stageToggle.publishtoECR}
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