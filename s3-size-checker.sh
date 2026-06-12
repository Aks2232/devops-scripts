#!/bin/bash
# Check size of all S3 buckets

echo "=== S3 Bucket Size Report ==="
echo "Date: $(date)"
echo ""

BUCKETS=$(aws s3 ls | awk '{print $3}')

for BUCKET in $BUCKETS; do
    SIZE=$(aws s3 ls s3://$BUCKET --recursive --summarize 2>/dev/null | grep "Total Size" | awk '{print $3, $4}')
    COUNT=$(aws s3 ls s3://$BUCKET --recursive --summarize 2>/dev/null | grep "Total Objects" | awk '{print $3}')
    echo "Bucket: $BUCKET"
    echo "  Objects: $COUNT"
    echo "  Size: $SIZE"
    echo ""
done

echo "Report complete!"
