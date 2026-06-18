#!/bin/bash

instance_ids=$(aws ec2 describe-instances \
  --filters "Name=instance-state-name,Values=running" "Name=tag:environment,Values=dev" \
  --query 'Reservations[*].Instances[].InstanceId' \
  --output text)

sorted_ids=$(echo "$instance_ids" | tr '\t' '\n' | sort)

counter=1
for id in $sorted_ids; do
    name="target-$(printf "%02d" $counter)"
    echo "Tagging $id as $name"
    aws ec2 create-tags \
      --resources "$id" \
      --tags "Key=Name,Value=$name"
    ((counter++))
done

echo "Done.. Ho gye sab rename"   