#!/bin/bash

sshpass -p PASSWORD ssh ubuntu@MAIN_IP "kubectl apply -f /home/ubuntu/.kube/deploy/"