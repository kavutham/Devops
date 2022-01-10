pipeline {
    agent any
    }
    stages {
        stage('Build') {
            steps {
                'mvn -B -DskipTests clean package'
            }
        }
        stage('Test') {
            steps {
                'mvn test'
            }
            post {
                always {
                    junit 'target/surefire-reports/*.xml'
                }
            }
        }
        stage ('Invoke_otherpipeline') {
            steps {
                build job: 'demopipeline'//, parameters: [string(name: 'param1', value: "value1")]
            }
        }
        stage('Deploy') {
            steps {
                echo 'Deployed Successfully'
            }
        }
    }
