# Automatisation via Kubernetes

- On créé les répertoires devant servir de volumes et on set les droits. Pour des besoins de faciliter, on va attribuer tous les droits sur ces folders.

```shell
        sudo mkdir -p /k8s_data/odoo-web-data /k8s_data/postgres-data /k8s_data/pgadmin-data
        sudo chmod 777 -R  /k8s_data/odoo-web-data /k8s_data/postgres-data /k8s_data/pgadmin-data
```
- Lancement de la stack 
```shell
        cd kubernetes
        HOST_IP=$(ip -4  a show enp0s8 | grep inet | awk '{print $2}' | awk -F'/' '{print $1}')   
        kubectl apply -f {{deployment.yml}} # de façon croissante (en respectant les dépendances)
```
- Test dans le navigateur de votre machine, taper http://<votre_ip_machine>:30010 pour vérifier le fonctionnement