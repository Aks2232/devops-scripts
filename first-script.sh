#!/bin/bash
# My first bash script

echo "=== System Info ==="
echo "User: $(whoami)"
echo "Date: $(date)"
echo "Directory: $(pwd)"

echo ""
echo "=== AWS Account ==="
aws sts get-caller-identity --query 'Account' --output text

echo ""
echo "=== EC2 Status ==="
aws ec2 describe-instances --instance-ids i-04bf3604535fa43ef --region ap-south-1 --query 'Reservations[0].Instances[0].State.Name' --output text

echo ""
echo "=== S3 Buckets ==="
aws s3 ls