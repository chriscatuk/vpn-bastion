#!/bin/bash
# List amis names
# Useful to choose the latest name before using get_amis.sh

amiName="amzn-ami-hvm-*-x86_64-gp2";
region="eu-west-2"

echo ""
echo "     >>> Searching in $region for $amiName <<<"
echo ""

aws ec2 describe-images --owners amazon --region $region \
	--filters "Name=name,Values=$amiName" \
	--query 'Images[*].{ID:ImageId,Name:Name}' --output text

echo ""