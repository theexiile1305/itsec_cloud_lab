#!/bin/bash
echo "executing terraform..."
terraform fmt
terraform apply

echo "uploading secrets..."
aws s3 cp A.txt s3://7875be2c-assignment-3/A.txt
aws s3 cp A.txt s3://7875be2c-assignment-3/C.txt
aws s3 cp A.txt s3://7875be2c-assignment-3/I.txt