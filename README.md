# bootcamp_devops-projet-final
PROJET FIL ROUGE BOOTCAMP DEVOPS EAZYTRAINING

## 1) Introduction
To have the source code of ic-webapp App go to https://github.com/sadofrazer/ic-webapp

## 2) Containerization of the web application
You can pull one version of build image application by typing:
> docker pull julios2/ic-webapp

## 3) Part 1: Deployment of the different applications in a Kubernetes cluster
### a) Architecture
Types et rôles de chacune des ressources (A..H):
- Ressource A: Service utilisé pour exposer à l'extérieur du cluster la ressource B (ic-webapp)
- Ressource B: Deployment (02 réplicas) qui est joiniable ou est pointé par les ressources C et G
- Ressource C: Service permettant de joindre la ressource D
- Ressource G: Service permettant de joindre la ressourc H
- Ressource D: Deployment (02 réplicas) joiniable via la ressource C et connecté à la ressource F via la ressource E
- Ressource H: Pod joiniable via la ressource G et connecté à la ressource F via la ressource E
- Ressource E: Service permettant de joindre la ressource F
- Ressource F: Pod joiniable via la ressource E


## 3) Part 2: Setting up a CI pipeline with Jenkins

### Jenkins Plugins to install 
- Docker
- Docker Pipeline
- docker-build-step

### Job Pipeline characteristics

**Secrets parameters**
- snyk_token
- dockerhub-pwd

*Trigger* : Scrutation de l'outil (* * * * *) ou webhook (A configurer dans Github)

*Pipeline* : - Definition : Pipeline script from SCM > GIT - Branche : */main - Script Path : Jenkinsfile

## 4) Part 2: Setting up a CD with Ansible and Terraform

### Prérequis
- S'assurer de la présence du VPC par défaut en région Virginie du Nord, ainsi que son Network et Security Group par default.
- Générer des credentials dans AWS (access_key, ecret_key et une key_pair)
- Configurer les secret et paramètres dans Jenkins

### Setting up Ansible sources files
Before you launch the Jenkins Pipeline, you must set or update **hosts variables** and **release.txt** for **prod** environment.

### Configuration du Jenkinsfile pour intégrer le déploiement Ansible

##### Secret et paramètres
En plus des paramètres et tokens utilisé à la partie CI, on aura aussi besoin des paramètres suivants : 


|                      | Type        |Default Value   | Description               |
|----------------------|-------------|----------------|---------------------------|
| vault_key            | secret text |      N/A       | Mot de pass vault ansible |
| sudopass             | secret text |      N/A       | mdp pour le become user   |
| aws_access_key_id    | secret text |      N/A       | access key aws            |
| aws_secret_access_key | secret text |      N/A       | secret key aws            |
| private_aws_key      | secret file |      N/A       | Clés privé  ec2-user      |

##### Ports applicatif configuré
- ic-webapp : 8000
- odoo : 8069
- pgadmin : 5050