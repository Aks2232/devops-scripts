#!/bin/bash
# AWS Inventory Script - lists all your resources

REGION="ap-south-1"

# Function to print a section header
print_header() {
    echo ""
    echo "================================"
    echo "  $1"
    echo "================================"
}

# EC2 Instances
print_header "EC2 INSTANCES"
aws ec2 describe-instances --region $REGION --query 'Reservations[*].Instances[*].{ID:InstanceId,State:State.Name,Type:InstanceType,IP:PublicIpAddress}' --output table

# S3 Buckets
print_header "S3 BUCKETS"
BUCKETS=$(aws s3 ls)
COUNT=0
while read -r line; do
    COUNT=$((COUNT + 1))
    echo "  $COUNT. $line"
done <<< "$BUCKETS"
echo "  Total: $COUNT buckets"

# IAM Users
print_header "IAM USERS"
aws iam list-users --query 'Users[*].UserName' --output table

# Security Groups
print_header "SECURITY GROUPS"
aws ec2 describe-security-groups --region $REGION --query 'SecurityGroups[*].{Name:GroupName,ID:GroupId,Description:Description}' --output table

echo ""
echo "Inventory complete!"
