#!/bin/bash
# hello-go-deploy-azure-vm destroy-pipeline.sh

fly -t ci destroy-pipeline --pipeline hello-go-deploy-azure-vm
