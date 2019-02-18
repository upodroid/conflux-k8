#!/bin/bash

sudo apt update && sudo apt upgrade -y

sudo apt install -y python3 python3-pip httpie 

sudo snap install helm kubectl--classic

sudo pip3 install -r requirements.txt