pipeline {
  agent {
    node {
      label 'ecs'
    }

  }
  stages {
    stage('terraform plan') {
      steps {
        input(message: 'Do you want to execute?', ok: 'Yes')
      }
    }
    stage('get version') {
      steps {
        sh 'terraform --version'
      }
    }
  }
}