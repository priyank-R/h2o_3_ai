pipeline {
  agent none
  environment {
    DOCKERHUB_CREDENTIALS = credentials('dockerhub_id')
    GITHUB_CREDENTIALS = credentials('github_id')
    REVISION = 24
    HARBOR_CREDENTIALS = credentials('harbor_id')

  }
  stages {
    stage('Checkout') {
      steps {
        git branch: 'main', url: 'https://github.com/RutikKalokhe/Image-Identification-Backend.git'
      }
    }

    stage('Docker build') {
      steps {
        sh "docker image prune -af"
        sh "docker image build -t 20.21.104.152/imageidentification/imagebackidentification:$REVISION ."
        sh "docker image tag 20.21.104.152/imageidentification/imagebackidentification:$REVISION sumithpe/imagebackidentification:$REVISION"
      }
    }

    stage('Push to harbor & docker') {
      steps {
        sh 'echo $HARBOR_CREDENTIALS_PSW | docker login 20.21.104.152 -u $HARBOR_CREDENTIALS_USR --password-stdin'
        sh "docker image push 20.21.104.152/imageidentification/imagebackidentification:$REVISION"
        sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
        sh "docker image push sumithpe/imagebackidentification:$REVISION"
      }
    }

    stage('Git update') {
      steps {
        script {
          catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE') {
            sh ''
            '
            cd / home / hpe / imageidentification / imageidentificationconfig
            git pull https: //"$GITHUB_CREDENTIALS_USR":"$GITHUB_CREDENTIALS_PSW"@github.com/sumit871996/imageidentificationconfig.git
              sh backendscript.sh "$REVISION"
            git add.
            git commit - m "updated backend deployment file"
            git push https: //"$GITHUB_CREDENTIALS_USR":"$GITHUB_CREDENTIALS_PSW"@github.com/sumit871996/imageidentificationconfig.git
              ''
            '
          }
        }
      }
    }

  }
}