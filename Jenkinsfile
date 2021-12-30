pipeline {
    agent any
    //tools { 
    //    maven 'Maven' 
    //    jdk 'JAVA_17' 
    //}
    stages {
        stage('Build') {
            steps {
                bat 'mvn -B -DskipTests clean package'
            }
        }
        stage('Test') {
            steps {
                bat 'mvn test'
            }
            post {
                always {
                    junit 'target/surefire-reports/*.xml'
                }
            }
        }
        stage('Deploy') {
            steps {
                bat 'java -jar target/java -jar target/my-app-1.0-SNAPSHOT.jar'
            }
        }
    }
}
