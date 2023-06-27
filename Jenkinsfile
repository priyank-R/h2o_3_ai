pipeline {
  agent none
  environment {
    GITHUB_URL= 'https://github.com/priyank-R/h2o_3_ai.git'
    H2O_IMAGE_URL = 'public.ecr.aws/e5d0c9b0/hpc_hpe:h2o_3_ai'

  }
  stages {
    stage('Checkout') {
      steps {
        git branch: 'master', url: "$GITHUB_URL"
      }
    agent any

    }

    stage('Podman build / push') {
      steps {
        sh "podman build -t $H2O_IMAGE_URL" + "_latest ."
        sh "podman push $H2O_IMAGE_URL" + "_latest"
      }
    agent any

    }

    stage('Podman pull and run') {
      steps {
        sh "podman pull $H2O_IMAGE_URL" + "_latest"
        sh "podman stop h2o3ai"
        sh "podman rm -f h2o3ai"
        sh "podman run -p 54321:54321 -p 54322:54322 --name h2o3ai -dit $H2O_IMAGE_URL" + "_latest"
      }
    agent any

    }

  }
}