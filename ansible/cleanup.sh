#!/bin/bash
sed -i -e 's/present/absent/g' main.yaml
ansible-playbook main.yaml --tags "cluster"

