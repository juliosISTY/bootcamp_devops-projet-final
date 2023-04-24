pipeline {
    environment {
        ID_DOCKER = "julios2"
        IMAGE_NAME = "ic-webapp"
        SOURCES_PATH = "./sources/ic-webapp"
        DOCKERFILE_NAME = "Dockerfile_v2"
        INTERNAL_PORT = 8080
        EXTERNAL_PORT = 80
    }
    agent none
    stages {
        stage('Build image') {
            agent any
            steps {
                script {
                    sh '''
                        export IMAGE_TAG=$( awk 'NR==3 {print $2}' $SOURCES_PATH/release.txt )
                        docker build --no-cache -t ${ID_DOCKER}/$IMAGE_NAME:$IMAGE_TAG -f $SOURCES_PATH/$DOCKERFILE_NAME $SOURCES_PATH
                    '''
                }
            }
        }
        stage('Run container based on builded image') {
            agent any
            steps {
                script {
                    sh '''
                        echo "Clean Environment"
                        docker rm -f $IMAGE_NAME || echo "container does not exist"
                        export IMAGE_TAG=$( awk 'NR==3 {print $2}' $SOURCES_PATH/release.txt )
                        docker run -d -p ${EXTERNAL_PORT}:${INTERNAL_PORT} --name $IMAGE_NAME ${ID_DOCKER}/$IMAGE_NAME:$IMAGE_TAG
                        sleep 5
                    '''

                }
            }
        }
        stage('Test image') {
            agent any
            steps {
                script {
                    sh '''
                        curl -I 172.17.0.1 | grep -i "200"
                    '''

                }
            }
        }
        stage('Clean container') {
            agent any
            steps {
                script {
                    sh '''
                        docker stop $IMAGE_NAME
                        docker rm $IMAGE_NAME
                    '''

                }
            }
        }

        stage ('Login and Push Image on docker hub') {
              agent any
            environment {
               DOCKERHUB_PASSWORD  = credentials('dockerhub-pwd')
            }
            steps {
                script {
                    sh '''
                        export IMAGE_TAG=$( awk 'NR==3 {print $2}' $SOURCES_PATH/release.txt )
                        echo $DOCKERHUB_PASSWORD | docker login -u $ID_DOCKER --password-stdin
                        docker push ${ID_DOCKER}/$IMAGE_NAME:$IMAGE_TAG
                    '''
                }
            }
        }
    }
}