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
            SCANNER_HOME = tool 'Sonar-scanner';
            withSonarQubeEnv(credentialsId: 'sonar-jenkins', installationName: 'localsonar') {
            bat '''${SCANNER_HOME}/bin/sonar-scanner \
            -Dsonar.projectKey=jenkins-test \
            -Dsonar.projectName=jenkins-test \
            -Dsonar.sources=src/ \
            -Dsonar.java.binaries=target/classes/ \
            -Dsonar.exclusions=src/test/java/****/*.java \
            -Dsonar.java.libraries=/var/lib/jenkins/.m2/**/*.jar
            -Dsonar.projectVersion=${BUILD_NUMBER}-${params.versionid} '''
            }
            }
        }
        stage('Squality Gate') {
          steps {
            timeout(time: 1, unit: 'MINUTES') {
            waitForQualityGate abortPipeline: true
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
