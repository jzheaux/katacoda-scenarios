#!/bin/bash
# Standard environment initialization script. Assumes the installation path (the cp portion) has been
# created by Katacoda via a environment.uieditorpath key. (ex: "uieditorpath": "/root/code/spring-mvc")

UI_PATH=/root/code 	# This should match your index.json key

git clone -q https://github.com/jzheaux/oreilly-spring-security-rest-apis.git
rm -rf $UI_PATH && cp -R /root/oreilly-spring-security-rest-apis /root/code
cd /root/code
mvn compile
apt update
apt install -y httpie
clear
