# Automatisation via docker-compose 

**Notes**

le docker-compose contient les variables ODOO_URL et PGADMIN_URL qui doivent etre renseignées avec l'ip machine de la VM vagrant. ce sont les lignes suivantes:
```shell
       - "ODOO_URL=http://${HOST_IP}:8069/"
       - "PGADMIN_URL=http://${HOST_IP}:5050/"
```
Du coup la variable d'env HOST_IP doit contenir cette IP machine. Sur notre infra, on va travailler avec l'interface enp0s8. Du coup la commande suivante permets de facilement récupérer cette IP machine:
> ip -4  a show enp0s8 | grep inet | awk '{print $2}' | awk -F'/' '{print $1}

## Lancement de la stack 
```shell
        cd docker-compose
        HOST_IP=$(ip -4  a show enp0s8 | grep inet | awk '{print $2}' | awk -F'/' '{print $1}')   
        docker-compose up -d -f {{docker-compose-file.yml}}
```
Test dans le navigateur de votre machine, taper http://<HOST_IP>:8080 pour vérifier le fonctionnement