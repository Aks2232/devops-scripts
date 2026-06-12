#!/bin/bash
REGION="ap-south-1"
INSTANCE_ID="i-04bf3604535fa43ef"
PROBLEMS=0

echo "=============================="
echo "  AWS Health Check Report"
echo "  Date: $(date)"
echo "=============================="

echo ""
echo "[CHECK 1] EC2 Instance Status"
STATUS=$(aws ec2 describe-instances --instance-ids $INSTANCE_ID --region $REGION --query 'Reservations[0].Instances[0].State.Name' --output text)
if [ "$STATUS" == "running" ]; then
    echo "  ✅ Instance is running"
else
    echo "  ❌ Instance is $STATUS"
    PROBLEMS=$((PROBLEMS + 1))
fi

echo ""
echo "[CHECK 2] S3 Buckets"
BUCKET_COUNT=$(aws s3 ls | wc -l)
echo "  ✅ $BUCKET_COUNT buckets found"

echo ""
echo "[CHECK 3] Security Groups"
OPEN_RULES=$(aws ec2 describe-security-groups --region $REGION --query 'SecurityGroups[*].IpPermissions[*].IpRanges[?CidrIp==`0.0.0.0/0`]' --output text | wc -l)
if [ "$OPEN_RULES" -gt 2 ]; then
    echo "  ⚠️  WARNING: $OPEN_RULES rules open to the world"
    PROBLEMS=$((PROBLEMS + 1))
else
    echo "  ✅ Security groups look reasonable"
fi

echo ""
echo "[CHECK 4] IAM Users"
USER_COUNT=$(aws iam list-users --query 'Users[*].UserName' --output text | wc -w)
echo "  ✅ $USER_COUNT IAM users found"

echo ""
echo "=============================="
if [ "$PROBLEMS" -eq 0 ]; then
    echo "  ✅ All checks passed!"
else
    echo "  ⚠️  $PROBLEMS issue(s) found"
fi
echo "=============================="
