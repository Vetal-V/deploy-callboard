#!/bin/bash

cd ../terraform
public_ip1=`terraform output -json public_ip | jq '.[0]' | xargs` 
username=`terraform output -json username | xargs`
password=`terraform output -json password | xargs`

cd ../docker/

docker build --build-arg ADMIN_USERNAME=$ADMIN_USERNAME \
             --build-arg ADMIN_PASSWORD=$ADMIN_PASSWORD \
             --build-arg ADMIN_EMAIL=$ADMIN_EMAIL \
             -t vetalvr/callboard-kube:django-backend -f Dockerfile_django .

docker build --build-arg BACKEND_IP=$public_ip1 -t vetalvr/callboard-kube:vue-frontend -f Dockerfile_front .

docker push $DOCKER_REPO:django-backend
docker push $DOCKER_REPO:vue-frontend

sshpass -p $password ssh $username@$public_ip1 "kubectl apply -f /home/ubuntu/.kube/deploy/"
sshpass -p $password ssh $username@$public_ip1 "kubectl autoscale deployment frontend --cpu-percent=50 --min=2 --max=25"