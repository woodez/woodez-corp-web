pipeline {
    agent none
    stages {
     stage("build on rasp") {
       agent { 
            label 'rasp'
       }
       stages {
            stage('Git Checkout'){
                steps {
                    git credentialsId: 'kevinwood75', url: 'https://github.com/woodez/woodez-corp-web.git', branch: 'master'
                }
            }
            stage('Build Docker Image'){
                steps { 
                    sh 'docker build -t kwood475/woodez-corp-web:2.0.0 .'
                }
            } 
            stage('Push Docker Image'){
                steps {
                    withCredentials([string(credentialsId: 'docker-pwd', variable: 'dockerhub')]) {
                       sh "docker login -u kwood475 -p ${dockerhub}"
                    }  
                    sh 'docker push kwood475/woodez-corp-web:2.0.0'
                }
            } 
        } 
     }
     stage("deploy to prod") {
       agent {
           label 'appserver'
       }
       stages {
         stage('Remove old Container release'){
             steps{
                sh 'docker stop woodez-corp'
                sh 'docker rm woodez-corp'
             }
         }
 
         stage('Release Container on Server'){
             steps{
                sh 'docker run --name woodez-corp -p 80:80 -d kwood475/woodez-corp-web:2.0.0'
             }
         }
       }
      }
    }
}
