pipeline {
  agent any
  stages {
    stage('terraform plan') {
      steps {
        input(message: 'Yes or NO?', id: 'choice', ok: 'yes')
      }
    }
  }
}