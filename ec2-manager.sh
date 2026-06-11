#!/bin/bash
# EC2 Manager - start, stop, or check your instance

INSTANCE_ID="i-04bf3604535fa43ef"
REGION="ap-south-1"

# Get current status
STATUS=$(aws ec2 describe-instances --instance-ids $INSTANCE_ID --region $REGION --query 'Reservations[0].Instances[0].State.Name' --output text)

echo "EC2 Instance: $INSTANCE_ID"
echo "Current Status: $STATUS"

if [ "$STATUS" == "running" ]; then
    echo "Instance is running. Want to stop it? (yes/no)"
    read ANSWER
    if [ "$ANSWER" == "yes" ]; then
        aws ec2 stop-instances --instance-ids $INSTANCE_ID --region $REGION
        echo "Stopping instance..."
    else
        echo "Keeping it running."
    fi
elif [ "$STATUS" == "stopped" ]; then
    echo "Instance is stopped. Want to start it? (yes/no)"
    read ANSWER
    if [ "$ANSWER" == "yes" ]; then
        aws ec2 start-instances --instance-ids $INSTANCE_ID --region $REGION
        echo "Starting instance..."
    else
        echo "Keeping it stopped."
    fi
else
    echo "Instance is in state: $STATUS. Wait and try again."
fi
