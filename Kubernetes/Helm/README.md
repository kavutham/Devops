## HELM

    helm repo add bitnami https://charts.bitnami.com/bitnami
    helm env --> displays the localtion/path of all repo and config
    helm install my-apache bitnami/apache --version 8.0.2
    helm list
    helm rollback my-apache 1 

    helm create my-ghost-app
    helm template --debug my-ghost-app --> to dry-run

    helm install -f my-ghost-app/values.prod.yaml my-ghost-prod ./my-ghost-app/