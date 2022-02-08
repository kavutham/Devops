pipeline {
    agent any
    //environment {
    //  GIT_COMMIT_SHORT = sh(script: "printf \$(git rev-parse --short ${GIT_COMMIT})", returnStdout: true)
    //}
    parameters {
    string(name: 'versionid', defaultValue: '1.0', description: 'Provide version ID')
    }
    tools { 
        maven 'Maven' 
        jdk 'JAVA_17' 
    }
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
        stage('SonarQube analysis') {
          environment {
            SCANNER_HOME = tool 'Sonar-scanner'
            }
          steps {
            withSonarQubeEnv(credentialsId: 'sonar-jenkins_token', installationName: 'localsonar') {
            bat "${SCANNER_HOME}/bin/sonar-scanner -Dsonar.projectKey=jenkins-test -Dsonar.projectName=jenkins-test -Dsonar.sources=src/ -Dsonar.java.binaries=target/classes/ -Dsonar.exclusions=src/test/java/****/*.java  -Dsonar.projectVersion=${BUILD_NUMBER}-${params.versionid}" //-Dsonar.java.libraries=/var/lib/jenkins/.m2/**/*.jar"
            }
            }
        }
        stage('Squality Gate') {
          steps {
                **sleep(10)  /* Added 10 sec sleep that was suggested in few places*/**
                script{
                    timeout(time: 10, unit: 'MINUTES') {
                        def qg = waitForQualityGate abortPipeline: true
                        if (qg.status != 'OK') {
                            echo "Status: ${qg.status}"
                            error "Pipeline aborted due to quality gate failure: ${qg.status}"
                        }
                    }
                }
            }
          //steps {
            //timeout(time: 5, unit: 'MINUTES') {
            //waitForQualityGate abortPipeline: true
            //}
        }
        }
        stage('Deploy') {
          steps {
            bat "echo Deployed version ${params.versionid} Successfully"
            }
        }
    }
}
