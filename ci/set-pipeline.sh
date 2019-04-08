#!/bin/bash
# hello-go-deploy-azure-vm set-pipeline.sh

fly -t ci set-pipeline -p hello-go-deploy-azure-vm -c pipeline.yml --load-vars-from ../../../../../.credentials.yml
