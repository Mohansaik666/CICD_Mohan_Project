pipeline {
    agent any

    environment {
        REGISTRY = "docker.io/mohanck6666"
        FRONTEND_IMAGE = "${REGISTRY}/frontend:latest"
        BACKEND_IMAGE  = "${REGISTRY}/backend:latest"
        K8S_NAMESPACE  = "ecommerce"
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/your-repo/CICD_Mohan_Project.git'
            }
        }

        stage('Build Frontend') {
            steps {
                sh 'docker build -t $FRONTEND_IMAGE ./frontend'
            }
        }

        stage('Build Backend') {
            steps {
                sh 'docker build -t $BACKEND_IMAGE ./backend'
            }
        }

        stage('Push Images') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
                    sh 'docker push $FRONTEND_IMAGE'
                    sh 'docker push $BACKEND_IMAGE'
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                withKubeConfig([credentialsId: 'kubeconfig-creds']) {
                    sh 'kubectl apply -f k8s/configmaps -n $K8S_NAMESPACE'
                    sh 'kubectl apply -f k8s/secrets -n $K8S_NAMESPACE'
                    sh 'kubectl apply -f k8s/deployments -n $K8S_NAMESPACE'
                    sh 'kubectl apply -f k8s/services -n $K8S_NAMESPACE'
                }
            }
        }
    }
}
