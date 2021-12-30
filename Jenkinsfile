pipeline {
    agent any
    tools { 
        maven 'Maven' 
        jdk 'JAVA_17' 
    }
    stages {
        stage('Build') {
            steps {
                mvn -B -DskipTests clean package
            }
        }
        stage('Test') {
            steps {
                mvn test
            }
            post {
                always {
                    junit 'target/surefire-reports/*.xml'
                }
            }
        }
        stage('Deploy') {
            steps {
                echo 'Deployed Successfully'
            }
        }
    }
}
