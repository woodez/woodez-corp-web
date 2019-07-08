pipeline {
    agent none
    stages {
        stage('Send alert that build has started'){
            agent { label 'appserver'}
            steps {
                notifyStarted()
            }
        }
        
        stage('Git Checkout'){
            agent { label 'appserver'}
            steps {
                git credentialsId: 'kevinwood75', url: 'https://github.com/woodez/woodez-corp-web.git', branch: 'master'
            }
        }
        stage('Build Docker Image'){
            agent { label 'appserver' }
            steps {
                sh 'docker build -t kwood475/woodez-corp-web:2.0.0 .'
            }
        }
        stage('Push Docker Image'){
            agent { label 'appserver'}
            steps {
                withCredentials([string(credentialsId: 'docker-pwd', variable: 'dockerhub')]) {
                   sh "docker login -u kwood475 -p ${dockerhub}"
                }
                sh 'docker push kwood475/woodez-corp-web:2.0.0'
            }
        }
        
        stage('get appproval for prod release'){
            agent { label 'rasp' }
            steps {
                timeout(time: 30, unit: 'MINUTES') {
                    script {
                      def INPUT_PARAMS = input id: 'Release', message: 'Approve release to prod', ok: 'Approve', parameters: [booleanParam(defaultValue: true, description: 'approver status', name: 'approver_status')], submitter: 'kwood', submitterParameter: 'approvername'
                    }
                }  
            }
        }
        
        stage('Remove older container before release'){
            agent { label 'rasp' }
            steps {
                sh 'docker rm -f woodez-corp || true'
            }
        }

        stage('Release Container prod1'){
            agent { label 'rasp' }
            steps {
                sh 'docker run --name woodez-corp -p 8081:80 -d kwood475/woodez-corp-web:2.0.0'
            }
        } 
        
        stage('Release Container prod2'){
            agent { label 'appserver' }
            steps {
                sh 'docker rm -f woodez-corp || true'
                sh 'docker run --name woodez-corp -p 8081:80 -d kwood475/woodez-corp-web:2.0.0'
            }
        }

    }
}

def notifyStarted() {
  slackSend (color: '#FFFF00', message: "STARTED: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' (${env.BUILD_URL})")
}