pipeline {
  agent any
  stages {
    stage('terraform plan') {
      steps {
        input(message: 'Do you want to execute?', ok: 'Yes')
      }
    }
  }
}