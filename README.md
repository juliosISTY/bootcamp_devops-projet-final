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


