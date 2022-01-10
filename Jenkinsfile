pipeline {
    agent {
        docker { image 'gradle:6.7-jdk11' }
    }
    stages {
        stage('Test') {
            steps {
                bat 'gradle --version'
            }
        }
    }
}
