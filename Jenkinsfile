pipeline {
    environment {
        ID_DOCKER = "julios2"
        IMAGE_NAME = "ic-webapp"
        SOURCES_PATH = "./sources/ic-webapp"
        PGADMIN_SOURCE_VARS = "./sources/ansible/roles/pgadmin_role/vars/main.yml"
        IC_WEBAPP_SOURCE_VARS = "./sources/ansible/roles/ic-webapp/vars/main.yml"
        DOCKERFILE_NAME = "Dockerfile_v2"
        INTERNAL_PORT = 8080
        EXTERNAL_PORT = 80
        PROJECT_NAME = "projet_final"
    }
    agent none
    stages {
        /*stage('Build image') {
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
        stage('Scan Image with  SNYK') {
            agent any
            environment{
                SNYK_TOKEN = credentials('snyk_token')
            }
            steps {
                script{
                    sh '''
                        export IMAGE_TAG=$( awk 'NR==3 {print $2}' $SOURCES_PATH/release.txt )
                        echo "Starting Image scan ${ID_DOCKER}/$IMAGE_NAME:$IMAGE_TAG ..."
                        echo There is Scan result :
                        SCAN_RESULT=$(docker run --rm -e SNYK_TOKEN=$SNYK_TOKEN -v /var/run/docker.sock:/var/run/docker.sock snyk/snyk:docker snyk test --docker $ID_DOCKER/$IMAGE_NAME:$IMAGE_TAG --json ||  if [[ $? -gt "1" ]];then echo -e "Warning, you must see scan result \n" ;  false; elif [[ $? -eq "0" ]]; then   echo "PASS : Nothing to Do"; elif [[ $? -eq "1" ]]; then   echo "Warning, passing with something to do";  else false; fi)
                        echo "Scan ended"
                    '''
                }
            }
        }
        stage('Run container based on building image') {
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
        }*/
        stage ('Build EC2 instance on AWS with Terraform') {
            agent {
                docker { image 'jenkins/jnlp-agent-terraform'}
            }
            environment {
                AWS_ACCESS_KEY_ID = credentials('aws_access_key_id')
                AWS_SECRET_ACCESS_KEY = credentials('aws_secret_access_key')
                PRIVATE_AWS_KEY = credentials('private_aws_key')
            }
            steps {
                script {
                    sh '''
                        echo "Generating aws credentials"
                        echo "Delete older if exist"
                        rm -rf devops.pem ~/.aws
                        mkdir -p ~/.aws
                        echo "[default]" > ~/.aws/credentials
                        echo -e "aws_access_key_id=$AWS_ACCESS_KEY_ID" >> ~/.aws/credentials
                        echo -e "aws_secret_access_key=$AWS_SECRET_ACCESS_KEY" >> ~/.aws/credentials
                        chmod 400 ~/.aws/credentials
                        echo "Generating aws private key"
                        cp $PRIVATE_AWS_KEY devops.pem
                        chmod 400 devops.pem
                        cd ./sources/terraform/app
                        terraform init
                        terraform destroy --auto-approve
                        #terraform plan
                        #terraform apply --auto-approve
                    '''
                }
            }
        }
        /*stage ('Preparing Dev environment') {
            agent any
            steps {
                script {
                    sh '''
                        echo "Generating host_vars for EC2 server"
                        echo "ansible_host: $( awk '{print $2}' /var/jenkins_home/workspace/projet_final/public_ip.txt )" > sources/ansible/host_vars/aws_ec2_server.yml
                        echo -e "Update image_tag in $IC_WEBAPP_SOURCE_VARS"
                        echo "image_tag: '1.0'" > $IC_WEBAPP_SOURCE_VARS
                        echo -e "Update host_odoo_ip and host_pgadmin_ip in $IC_WEBAPP_SOURCE_VARS"
                        echo "host_odoo_ip: $( awk '{print $2}' /var/jenkins_home/workspace/projet_final/public_ip.txt )" >> $IC_WEBAPP_SOURCE_VARS
                        echo -e "host_pgadmin_ip: $( awk '{print $2}' /var/jenkins_home/workspace/projet_final/public_ip.txt )" >> $IC_WEBAPP_SOURCE_VARS

                    '''
                }
            }
        }
        stage('Preparing Ansible environment') {
            agent any
            environment {
                VAULT_KEY = credentials('vaultkey')
            }
            steps {
                script {
                    sh '''
                        echo "Generating vault key"
                        echo -e $VAULT_KEY > vault.key
                    '''

                }
            }
        }
        stage ('Deploy applications in Dev environment') {
            agent { docker { image 'registry.gitlab.com/robconnolly/docker-ansible:latest' } }
            stages{
                stage('Test all playbooks syntax'){
                    steps {
                        script {
                            sh '''
                                apt update
                                apt install sshpass -y
                                export ANSIBLE_CONFIG=$(pwd)/sources/ansible/ansible.cfg
                                ansible-lint -x 306 sources/ansible/playbooks/* || echo passing linter
                            '''
                        }
                    }
                }
                stage('Install requirements: Docker and python library for docker'){
                    steps {
                        script {
                            sh '''
                                export ANSIBLE_CONFIG=$(pwd)/sources/ansible/ansible.cfg
                                ansible-playbook sources/ansible/playbooks/install_docker.yml --tags dev --vault_password_file vault.key --private-key devops.pem
                            '''
                        }
                    }
                }
                stage('Deploy Odoo application in Dev'){
                    steps {
                        script {
                            sh '''
                                export ANSIBLE_CONFIG=$(pwd)/sources/ansible/ansible.cfg
                                ansible-playbook sources/ansible/playbooks/deploy_odoo.yml --vault_password_file vault.key --private-key devops.pem
                            '''
                        }
                    }
                }
                stage('Deploy Pgadmin application in Dev'){
                    steps {
                        script {
                            sh '''
                                export ANSIBLE_CONFIG=$(pwd)/sources/ansible/ansible.cfg
                                ansible-playbook sources/ansible/playbooks/deploy_pgadmin.yml --vault_password_file vault.key --private-key devops.pem
                            '''
                        }
                    }
                }
                stage('Deploy ic-webapp application in Dev'){
                    steps {
                        script {
                            sh '''
                                export ANSIBLE_CONFIG=$(pwd)/sources/ansible/ansible.cfg
                                ansible-playbook sources/ansible/playbooks/deploy_ic_webapp.yml --vault_password_file vault.key --private-key devops.pem
                            '''
                        }
                    }
                }
            }
        }
        stage ('Removal Dev environment') {
            agent {
                docker { image 'jenkins/jnlp-agent-terraform'}
            }
            steps {
                script {
                    timeout(time: 30, unit: "MINUTES"){
                        input message: "Do you confirm removal of Dev environment on AWS ?", ok: 'Yes'
                    }
                    sh '''
                        cd sources/terraform/app
                        terraform destroy --auto-approve
                        rm sources/ansible/host_vars/aws_ec2_server.yml
                        echo "Dev environment successful remove"
                    '''
                }
            }
        }*/
        /*stage ('Preparing Prod environment') {
            agent any
            environment {
                HOST_ODOO_IP_PROD = "127.0.0.1"   /*default value you can ignore*/
            /*    HOST_PGADMIN_IP_PROD = "127.0.0.1"    /*default value you can ignore*/
            /*}
            steps {
                script {
                    sh '''
                        echo -e "Update host_postgres_ip in $PGADMIN_SOURCE_VARS"
                        echo -e "host_postgres_ip: $HOST_ODOO_IP_PROD" > $PGADMIN_SOURCE_VARS
                        echo -e "Update image_tag in $IC_WEBAPP_SOURCE_VARS"
                        echo "image_tag: '2.0'" > $IC_WEBAPP_SOURCE_VARS
                        echo -e "Update host_odoo_ip and host_pgadmin_ip in $IC_WEBAPP_SOURCE_VARS"
                        echo -e "host_odoo_ip: $HOST_ODOO_IP_PROD" >> $IC_WEBAPP_SOURCE_VARS
                        echo -e "host_pgadmin_ip: $HOST_PGADMIN_IP_PROD" >> $IC_WEBAPP_SOURCE_VARS

                    '''
                }
            }
        }*/
        /*stage ('Deploy applications in Prod environment') {
            agent { docker { image 'registry.gitlab.com/robconnolly/docker-ansible:latest' } }
            when {
                       expression { GIT_BRANCH == 'origin/main' }
                    }
            environment {
                SUDOPASS = credentials('sudopass')
            }
            stages{
                stage('Install requirements: Docker and python library for docker'){
                    steps {
                        script {
                            timeout(time: 30, unit: "MINUTES"){
                                input message: "Do you confirm the MEP of applications ?", ok: 'Yes'
                            }
                            sh '''
                                apt update
                                apt install sshpass -y
                                export ANSIBLE_CONFIG=$(pwd)/sources/ansible/ansible.cfg
                                ansible-playbook sources/ansible/playbooks/install_docker.yml --tags on_labs --vault_password_file vault.key --extra-vars "ansible_sudo_pass=$SUDOPASS"
                            '''
                        }
                    }
                }
                stage('Deploy Odoo application in prod'){
                    steps {
                        script {
                            sh '''
                                export ANSIBLE_CONFIG=$(pwd)/sources/ansible/ansible.cfg
                                ansible-playbook sources/ansible/playbooks/deploy_odoo.yml --vault_password_file vault.key --extra-vars "ansible_sudo_pass=$SUDOPASS" -l odoo_server
                            '''
                        }
                    }
                }
                stage('Deploy Pgadmin application in prod'){
                    steps {
                        script {
                            sh '''
                                export ANSIBLE_CONFIG=$(pwd)/sources/ansible/ansible.cfg
                                ansible-playbook sources/ansible/playbooks/deploy_pgadmin.yml --vault_password_file vault.key --extra-vars "ansible_sudo_pass=$SUDOPASS" -l ic_webapp_and_pgadmin_server
                            '''
                        }
                    }
                }
                stage('Deploy ic-webapp application in prod'){
                    steps {
                        script {
                            sh '''
                                export ANSIBLE_CONFIG=$(pwd)/sources/ansible/ansible.cfg
                                ansible-playbook sources/ansible/playbooks/deploy_ic_webapp.yml --vault_password_file vault.key --extra-vars "ansible_sudo_pass=$SUDOPASS" -l ic_webapp_and_pgadmin_server
                            '''
                        }
                    }
                }
            }
        }*/
    }
}