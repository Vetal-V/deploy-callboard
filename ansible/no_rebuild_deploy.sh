#!/bin/bash

sshpass -p $password ssh $username@$public_ip1 "kubectl apply -f /home/ubuntu/.kube/deploy/"
sshpass -p $password ssh $username@$public_ip1 "kubectl autoscale deployment frontend --cpu-percent=50 --min=2 --max=25"