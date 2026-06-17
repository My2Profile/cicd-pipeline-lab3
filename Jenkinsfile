pipeline {
    agent any

    tools {
        nodejs 'NodeJS-7.8.0'
    }

    environment {
        IMAGE_TAG = 'v1.0'
    }

    stages {
        stage('Set environment') {
            steps {
                script {
                    if (env.BRANCH_NAME == 'main') {
                        env.APP_PORT = '3000'
                        env.IMAGE_NAME = 'nodemain'
                        env.CONTAINER_NAME = 'nodemain-container'
                    } else if (env.BRANCH_NAME == 'dev') {
                        env.APP_PORT = '3001'
                        env.IMAGE_NAME = 'nodedev'
                        env.CONTAINER_NAME = 'nodedev-container'
                    } else {
                        error "Unsupported branch: ${env.BRANCH_NAME}"
                    }

                    echo "Branch: ${env.BRANCH_NAME}"
                    echo "Image: ${env.IMAGE_NAME}:${env.IMAGE_TAG}"
                    echo "Container: ${env.CONTAINER_NAME}"
                    echo "Port: ${env.APP_PORT}"
                }
            }
        }

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build') {
            steps {
                sh 'npm install --no-progress'
            }
        }

        stage('Test') {
            steps {
                sh 'CI=true npm test -- --watchAll=false'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t ${IMAGE_NAME}:${IMAGE_TAG} .'
            }
        }

        stage('Deploy') {
            steps {
                sh '''
                    docker rm -f ${CONTAINER_NAME} || true
                    docker run -d \
                      --name ${CONTAINER_NAME} \
                      -p ${APP_PORT}:3000 \
                      ${IMAGE_NAME}:${IMAGE_TAG}
                '''
            }
        }
    }
}
