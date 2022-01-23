pipeline {
    agent {
        docker { image 'gradle:6.7-jdk11' }
    }
    stages {
        stage('Build Docker') {
            steps {
                script{
                image= docker.build("test-image", "./Demo/example")
            }
            }
        }
        stage('Run Dockerimage'){
            steps{
                script{
                image.run(["-p 9091:9091"])
            }
            }
        }
    }
}
