#!/bin/bash
# Standard environment initialization script. Assumes the installation path (the cp portion) has been
# created by Katacoda via a environment.uieditorpath key. (ex: "uieditorpath": "/root/code/spring-mvc")

UI_PATH=/root/code 	# This should match your index.json key

git clone -q https://github.com/jzheaux/oreilly-spring-security-rest-apis.git -p exercises-module-three
cd ${UI_PATH} && cp -R /root/oreilly-spring-security-rest-apis/* ./
mvn compile
apt update
apt install -y httpie
clear # To clean up Katacoda terminal noise
