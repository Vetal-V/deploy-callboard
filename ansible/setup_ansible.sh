#!/bin/bash

cd ../terraform
public_ip1=`terraform output -json public_ip | jq '.[0]' | xargs` 
public_ip2=`terraform output -json public_ip | jq '.[1]' | xargs`
username=`terraform output -json username | xargs`
password=`terraform output -json password | xargs`

cd ../ansible/
sed -i "s/MAIN_IP/$public_ip1/" hosts
sed -i "s/WORKER_IP/$public_ip2/" hosts
sed -i "s/USERNAME/$username/" hosts
sed -i "s/PASSWORD/$password/" hosts