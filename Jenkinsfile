pipeline {
    agent {
        docker { image 'gradle:6.7-jdk11' }
    }
    stages {
        stage('Build Docker') {
            steps {
                image= docker.build("test-image", "./Demo/example")
            }
        }
        stage('Run Dockerimage'){
            steps{
                image.run([-p 9091:9091])
            }
        }
    }
}
