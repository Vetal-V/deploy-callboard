# Deploy [Callboard](https://github.com/Vetal-V/Coursework-DS) to Kubernetes

## Pre Requirements
- Terraform
- Ansible
- Account Azure and installed Azure CLI (az)
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
    default = "3"
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
   chmod +x setup_ansible.sh kubernetes-key.pem
   ./setup_ansible.sh
   ```
6. Run ansible playbook:
   ```
   ansible-playbook -i hosts -u ubuntu main.yml
   ```




ssh -i ./kubernetes-key.pem ubuntu@3.140.18.0


[main]
MAIN_IP ansible_user=USERNAME ansible_password=PASSWORD

[worker]
WORKER1_IP ansible_user=USERNAME ansible_password=PASSWORD 

[all:vars]
ansible_python_interpreter=/usr/bin/python3


docker build -t vetalvr/callboard-kube:django -f Dockerfile_django .