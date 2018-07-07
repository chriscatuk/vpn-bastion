#!/bin/bash
# Add a key to all region
# Can be run safely even it the keys already exist in most regions
# Will add the key to missing regions
# Regions with the key will return "Already exists"

keyname="keyname"
keyMaterial="ssh-rsa AAAAB....aXkTgy4TMK+j"

for i in `aws ec2 describe-regions --region eu-west-2 --query 'Regions[*].{Name:RegionName}' --output text`
	do
		echo "******** $i ********";
		aws ec2 import-key-pair --key-name "$keyname" \
			--region $i \
			--public-key-material "$keyMaterial"

	done
