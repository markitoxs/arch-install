pipeline {
  agent any
  stages {
    stage('terraform plan') {
      parallel {
        stage('terraform plan') {
          steps {
            input(message: 'Do you want to execute?', ok: 'Yes')
          }
        }
        stage('path echo') {
          steps {
            sh '''echo $PATH

'''
          }
        }
      }
    }
    stage('get version') {
      steps {
        sh 'terraform --version'
      }
    }
  }
}