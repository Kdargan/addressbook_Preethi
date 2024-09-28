// Test repo created by KD
pipeline {
    agent none

    tools {
        maven "mymvn"
    }

    environment {
        GIT_REPO   = 'https://github.com/Kdargan/addressbook_Preethi.git'
        KDSLAVE1   = 'ec2-user@54.235.12.190'
        KDSLAVE2   = 'ec2-user@54.157.152.161'
        DEST_PATH  = '/home/ec2-user'
    }

    stages {
        stage('Checkout') {
            agent any
            steps {
                git(
                    url: "${GIT_REPO}",
                    branch: 'master', // Update to 'main' if your default branch is 'main'
                    // No credentialsId needed for public repositories
                    changelog: false,
                    poll: false
                )
            }
        }

        stage('Compile') {
            agent any
            steps {
                script {
                    sshagent(['Kdslave1']) { // Ensure 'Kdslave1' is correctly configured in Jenkins
                        echo "In-progress Compile"
                        sh 'mvn clean'
                        sh 'mvn compile'
                    }
                }
            }
        }

        stage('Package') {
            agent any
            steps {
                script {
                    sshagent(['Kdslave1']) {
                        echo "In-progress Package"
                        sh 'mvn package'
                    }
                }
            }
        }

        stage('Test') {
            agent any
            steps {
                script {
                    sshagent(['Kdslave2']) { // Ensure 'Kdslave2' is correctly configured in Jenkins
                        echo "In-progress Test"
                        // Ensure 'kdslave2_configfile.sh' exists in the workspace
                        sh "scp -o StrictHostKeyChecking=no kdslave2_configfile.sh ${KDSLAVE2}:${DEST_PATH}"
                        sh "ssh -o StrictHostKeyChecking=no ${KDSLAVE2} 'bash ${DEST_PATH}/kdslave2_configfile.sh'"
                        sh 'mvn test'
                    }
                }
            }
        }

        stage('Install') {
            agent any
            steps {
                script {
                    sshagent(['Kdslave2']) {
                        echo "In-progress Install"
                        sh 'mvn install'
                    }
                }
            }
        }
    }

    post {
        success {
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed. Please check the logs.'
        }
    }
}
