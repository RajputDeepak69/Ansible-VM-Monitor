#!/bin/bash

PEM_FILE="~/project.pem"
PUB_KEY=$(cat ~/.ssh/id_ed25519.pub)
USER="ubuntu"
INVENTORY_FILE="~/inventory/aws_ec2.yml"
HOSTS=$(ansible-inventory -i "$INVENTORY_FILE" --list | jq -r '._meta.hostvars[].ansible_host.__ansible_unsafe')

for HOST in $HOSTS; do
  echo "Injecting key into $HOST"

  ssh -o StrictHostKeyChecking=no -i "$PEM_FILE" "$USER@$HOST" "
    mkdir -p ~/.ssh && \
    grep -qxF '$PUB_KEY' ~/.ssh/authorized_keys || echo '$PUB_KEY' >> ~/.ssh/authorized_keys && \
    chmod 700 ~/.ssh && \
    chmod 600 ~/.ssh/authorized_keys
  "

done   