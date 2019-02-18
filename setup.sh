#!/bin/bash

sudo apt update && sudo apt upgrade -y

sudo apt install -y python3 python3-pip httpie yamllint

sudo snap install helm kubectl terraform --classic

sudo pip3 install -r requirements.txt