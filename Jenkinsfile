pipeline {
    agent none
    stages {
        stage('Git Checkout'){
            agent { label 'appserver'}
            git credentialsId: 'kevinwood75', url: 'https://github.com/woodez/woodez-corp-web.git', branch: 'master'
        }
        stage('Build Docker Image'){
            agent { label 'appserver' }
            sh 'docker build -t kwood475/woodez-corp-web:2.0.0 .'
        }
        stage('Push Docker Image'){
            agent { label 'appserver'}
            withCredentials([string(credentialsId: 'docker-pwd', variable: 'dockerhub')]) {
               sh "docker login -u kwood475 -p ${dockerhub}"
            }
            sh 'docker push kwood475/woodez-corp-web:2.0.0'
        }
        stage('Remove old Container release'){
            agent { label 'appserver' }
            sh 'docker stop woodez-corp'
            sh 'docker rm woodez-corp'
        }

        stage('Release Container on Server'){
            agent { label 'appserver' }
            sh 'docker run --name woodez-corp -p 80:80 -d kwood475/woodez-corp-web:2.0.0'

        } 
    }
}
