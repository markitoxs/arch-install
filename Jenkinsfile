pipeline {
  agent any
  stages {
    stage('get version') {
      steps {
        sh 'terraform --version'
      }
    }
    stage('determine current') {
      steps {
        pwd()
      }
    }
    stage('print current') {
      steps {
        sh 'echo $PWD'
      }
    }
  }
}