pipeline {
    agent none
    tools {
        maven "mymvn"
    }
    environment{
        git_repo ='https://github.com/Kdargan/addressbook_Preethi.git'
        kdslave2 ='ec2-user@54.157.152.161'
        kdslave1 ='ec2-user@54.235.12.190'
        DEST_PATH ='/home/ec2-user'
            }        
stage('Compile') {
    agent any
            steps {
                    script{
                    sshagent(['Kdslave1']){
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
                script{
                    sshagent(['Kdslave1']) {
               echo "In-progress Pakage"   
                sh 'mvn package'
                }
            }
            }
            }
stage('Test') {
    agent any
     steps {
                script{
                    sshagent(['Kdslave2']) {
            echo "In-progress Test"
            sh "scp -o StrictHostKeyChecking=no kdslave2_configfile.sh ${kdslave2}:${DEST_PATH}"
            sh "ssh -o StrictHostKeyChecking=no  ${kdslave2} 'bash ~/kdslave2_configfile.sh'"
                sh 'mvn test'
                }
            }
            }
}
stage('Install') {
    agent any
       steps {
                script{
                    sshagent(['Kdslave2']) {
               echo "In-progress install"       
                sh 'mvn install'
                }
                    }
                }
}
}
