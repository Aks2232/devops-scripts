#!/bin/bash
# Create IAM user and add to a group

echo "=== IAM User Creator ==="
echo ""

# Ask for username
echo "Enter username to create:"
read USERNAME

# Check if user already exists
EXISTING=$(aws iam get-user --user-name $USERNAME 2>&1)
if [ $? -eq 0 ]; then
    echo "❌ User $USERNAME already exists!"
    exit 1
fi

# Show available groups
echo ""
echo "Available groups:"
aws iam list-groups --query 'Groups[*].GroupName' --output text
echo ""

# Ask which group
echo "Enter group name to add user to:"
read GROUP

# Create the user
echo ""
echo "Creating user: $USERNAME"
aws iam create-user --user-name $USERNAME

# Add to group
echo "Adding $USERNAME to group: $GROUP"
aws iam add-user-to-group --user-name $USERNAME --group-name $GROUP

# Verify
echo ""
echo "✅ Done! User details:"
aws iam get-user --user-name $USERNAME --query 'User.{Name:UserName,Created:CreateDate}' --output table

echo ""
echo "Group membership:"
aws iam list-groups-for-user --user-name $USERNAME --query 'Groups[*].GroupName' --output text
