node('rasp'){
    stage('Git Checkout'){
        git credentialsId: 'kevinwood75', url: 'https://github.com/woodez/woodez-corp-web.git', branch: 'master'
    }
    stage('Build Docker Image'){
        sh 'docker build -t kwood475/woodez-corp-web:2.0.0 .'
    }
    stage('Push Docker Image'){
        withCredentials([string(credentialsId: 'docker-pwd', variable: 'dockerhub')]) {
           sh "docker login -u kwood475 -p ${dockerhub}"
        }
        sh 'docker push kwood475/woodez-corp-web:2.0.0'
    }
    stage('Remove old Container release'){
        sh 'docker stop woodez-corp'
        sh 'docker rm woodez-corp'
    }

    stage('Release Container on Server'){
        sh 'docker run --name woodez-corp -p 80:80 -d kwood475/woodez-corp-web:2.0.0'

    }

}
