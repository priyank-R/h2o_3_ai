pipeline {
  agent none
  environment {
    GITHUB_URL= 'https://github.com/priyank-R/h2o_3_ai.git'
    H2O_IMAGE_URL = 'public.ecr.aws/e5d0c9b0/hpc_hpe:h2o_3_ai'
    ECR_CREDENTIALS = credentials('public.ecr.aws_e5d0c9b0')
  }
  stages {
    stage('Checkout') {
      steps {
        git branch: 'master', url: "$GITHUB_URL"
      }
    agent any

    }


    stage('Podman login') {
      steps {
        withEnv(['HTTP_PROXY=http://10.154.248.91:8080/', 'HTTPS_PROXY=http://10.154.248.91:8080/']) {
        sh 'echo $ECR_CREDENTIALS | podman login --username AWS public.ecr.aws/e5d0c9b0 --password-stdin'
      }
      }
    agent any

    }
    stage('Podman build / push') {
      steps {
        withEnv(['HTTP_PROXY=http://10.154.248.91:8080/', 'HTTPS_PROXY=http://10.154.248.91:8080/']) {
        sh "podman build --build-arg http_proxy=http://10.154.248.91:8080/ --build-arg https_proxy=http://10.154.248.91:8080/ -t $H2O_IMAGE_URL" + "_latest ."
        sh "podman push $H2O_IMAGE_URL" + "_latest"
      }
      }
    agent any

    }

    stage('Podman pull and run') {
      steps {
         withEnv(['HTTP_PROXY=http://10.154.248.91:8080/', 'HTTPS_PROXY=http://10.154.248.91:8080/']) {
        sh "podman pull $H2O_IMAGE_URL" + "_latest"
        sh "podman stop h2o3ai"
        sh "podman rm -f h2o3ai"
        sh "podman run -p 54321:54321 -p 54322:54322 --name h2o3ai -dit $H2O_IMAGE_URL" + "_latest"
      }
      }
    agent any

    }

  }
}