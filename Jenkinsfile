pipeline {
  agent any
  stages {
    stage('Build') {
      parallel {
        stage('Build one') {
          steps {
            sh 'echo "Hello world"'
          }
        }
        stage('Second Build') {
          steps {
            echo 'Hello new'
          }
        }
      }
    }
    stage('Test') {
      steps {
        sleep 20
      }
    }

    stage('') {
      steps {
        fileExists 'file.txt'
      }
    }

  }
  environment {
    Key = 'value'
  }
}
