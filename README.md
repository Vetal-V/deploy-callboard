# Deploy [Callboard](https://github.com/Vetal-V/Coursework-DS) to Kubernetes

## Pre Requirements
- Terraform
- Ansible
- Account Azure and Azure CLI (az)
- Docker

## Configure Kuberneter cluster
1. Get Azure login credentials:
    - login via web page:
        ```
        az login
        ```
    - save value `id` and run command replacing the value of `SUBSCRIPTION_ID` with `id`:
        ```
        az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/SUBSCRIPTION_ID"
        ```
    - now `id` is `subscription_id`, `appId` - `client_id`, `password` - `client_secret` and `tenant` - `tenant_id`.
  
2. Create file `./terraform/variables.tf` with the following content:
    ```
    variable "instance_count" {
        default = "2"
    }

    variable "location" {
        default = "eastus"
    }

    variable "subscription_id" {
        default = "YOUR_SUBSCRIPTION_ID"
    }

    variable "client_id" {
        default = "YOUR_CLIENT_ID"
    }

    variable "client_secret" {
        default = "YOUR_CLIENT_SECRET"
    }

    variable "tenant_id" {
        default = "YOUR_TANANT_ID"
    }

    variable "admin_username" {
        default = "ubuntu"
    }

    variable "admin_password" {
        default = "YOUR-STRONG-PASSWORD"
    }
    ```
3. Init terraform and download cloud dependencies:
    ```
    cd terraform
    terraform init
    ```
4. Apply the terraform changes required to reach the desired state of the configuration:
   ```
   terrform apply
   ```
5. Run script `./setup_ansible.sh` to configure Ansible hosts file:
   ```
   cd ../ansible/
   chmod +x setup_ansible.sh
   ./setup_ansible.sh
   ```
6. Configure Kubernetes cluster:
   ```
   ansible-playbook -i hosts -u ubuntu main.yml
   ```
7. Deploy callboard to k8s:
   - Set dependencies for Django admin user (this value for example) and name of Docker Hub repository:
        ```
        export ADMIN_USERNAME=admin
        export ADMIN_PASSWORD=adminpass
        export ADMIN_EMAIL=admin@test.com
        export DOCKER_REPO=vetalvr/callboard-kube
        ```
   - Deploy Backend(Django) and Frontend(Vue.js):
        ```
        chmod +x deploy.sh
        ./deploy.sh
        ```
8. To check the launch of backend you need to follow the link `GLOBAL_IP`:30000/admin (global ip of any machine, for example from file `hosts`):
![image](img/1.png)
9.  To check the launch of frontend you need to follow the link `GLOBAL_IP`:30100 (global ip of any machine, for example from file `hosts`)
![image](img/2.png)