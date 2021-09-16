#!/bin/bash

aws ecr delete-repository --repository-name estore_service_registry --force
aws ecr delete-repository --repository-name estore_db_registry --force
aws ecr create-repository --repository-name estore_service_registry --image-scanning-configuration scanOnPush=true --region us-east-1
aws ecr create-repository --repository-name estore_db_registry --image-scanning-configuration scanOnPush=true --region us-east-1
echo "********** Creating build ********** "
mvn clean install
echo "********** Database:: Building Docker file for Database & Push to container registry ********** "
cd postgre
pwd
docker rmi 647240904064.dkr.ecr.us-east-1.amazonaws.com/estore_db_registry:v1
docker image rm estorepostgredb
docker build -t estorepostgredb .
docker tag estorepostgredb 647240904064.dkr.ecr.us-east-1.amazonaws.com/estore_db_registry:v1
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 647240904064.dkr.ecr.us-east-1.amazonaws.com
docker push 647240904064.dkr.ecr.us-east-1.amazonaws.com/estore_db_registry:v1

echo "********** SERVICE:: Building Docker file & Push to container registry ********** "
cd ..
pwd
docker rmi 647240904064.dkr.ecr.us-east-1.amazonaws.com/estore_service_registry:v1
docker image rm estore
docker build -t estore .
docker tag estore 647240904064.dkr.ecr.us-east-1.amazonaws.com/estore_service_registry:v1
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 647240904064.dkr.ecr.us-east-1.amazonaws.com
docker push 647240904064.dkr.ecr.us-east-1.amazonaws.com/estore_service_registry:v1
echo "********** Delete existing K8S deployments ********** "
kubectl delete -f postgresql-configmap.yaml 
kubectl delete -f postgres.yml 
kubectl delete -f postgresql-service.yaml 
kubectl delete -f estore.yml 
echo "********** Deploy new versions********** "
kubectl apply -f postgresql-configmap.yaml
kubectl apply -f postgres.yml
kubectl apply -f postgresql-service.yaml
kubectl apply -f estore.yml
echo "********** Deployed  new versions..Wait for 30 seconds to access service********** "
sleep 30s
kubectl get svc
kubectl get pods

