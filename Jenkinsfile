// Test repo created by KD
pipeline {
    agent none

    tools {
        maven "mymvn" // Ensure 'mymvn' is correctly configured in Jenkins
    }

    environment {
        GIT_REPO   = 'https://github.com/Kdargan/addressbook_Preethi.git'
        Kdslave1   = 'ec2-user@54.235.12.190' // Use uppercase for environment variable names
        KDSLAVE2   = 'ec2-user@54.157.152.161' // Use uppercase for environment variable names
        DEST_PATH  = '/home/ec2-user'
    }

    stages {
        stage('Checkout') {
            agent any
            steps {
                script {
                    sshagent(['Kdslave1']) { // Ensure 'Kdslave1' is correctly configured in Jenkins
                        echo "In-progress Checkout"
                        // Checkout code from the repository
                        git branch: 'master', url: "${GIT_REPO}"
                    }
                }
            }
        }

        stage('Compile') {
            agent any
            steps {
                script {
                    sshagent(['Kdslave1']) {
                        echo "In-progress Compile"
                        sh 'mvn clean' // Clean the project
                        sh 'mvn compile' // Compile the project
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
                        sh 'mvn package' // Package the project
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
                        sh 'ls -l' // List files for debugging
                        // Copy the script to the remote machine
                        sh "scp -o StrictHostKeyChecking=no kdslave2_configfile.sh ${KDSLAVE2}:${DEST_PATH}"
                        sh "ssh -o StrictHostKeyChecking=no ${KDSLAVE2} 'bash ${DEST_PATH}/kdslave2_configfile.sh'"
                        sh 'mvn test' // Run tests
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
                        sh 'mvn install' // Install the package
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
