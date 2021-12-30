pipeline {
    agent any
    parameters {
    string(name: 'versionid', defaultValue: '1.0', description: 'Provide version ID')
  }
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
                bat "echo Deployed version ${params.versionid} Successfully"
            }
        }
    }
}
