#!/bin/bash
# hello-go-deploy-azure set-pipeline.sh

fly -t ci set-pipeline -p hello-go-deploy-azure -c pipeline.yml --load-vars-from ../../../../../.credentials.yml
