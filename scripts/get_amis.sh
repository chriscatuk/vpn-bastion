#!/bin/bash
# List ami ids of this images in all regions
# In a format for variable.tf

# Find latest names with get_latest_amis_names.sh
amiName="amzn-ami-hvm-2017.09.1.20180307-x86_64-gp2";

echo ""
echo "     >>> Searching in all regions for for $amiName <<<"
echo ""

echo "# $amiName"
echo "variable \"amis\" {"
echo "  type = \"map\""
echo "  default = {"


for i in `aws ec2 describe-regions --region eu-west-2 --query 'Regions[*].{Name:RegionName}' --output text`
	do
		echo -n "    \"$i\" = \""

		output=`aws ec2 describe-images --owners amazon --region $i \
			--filters "Name=name,Values=$amiName" \
			--query 'Images[*].{ID:ImageId}' --output text`

		echo "$output\""
	done

echo "  }"
echo "}"

echo ""
