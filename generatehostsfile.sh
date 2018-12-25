#!/bin/bash

# Generate hosts-file with private IP's in AWS ec2

# you need to install jq and aws cli
# chmode +x /home/ubuntu/generatehostsfile.sh
# refresh /etc/hosts every 5 minute
# */5 * * * * /home/ubuntu/generatehostsfile.sh

# Vars
hosts_file="/etc/hosts"
region="ap-northeast-1"
profile=""

# AWS call
described_instances=`aws --output json ec2 describe-instances --region ${region}`

#echo $described_instances

# jq
private_ips=`echo $described_instances | jq '.Reservations[] .Instances[] .PrivateIpAddress' | tr -d \"`

#echo $private_ips

hostnames=`echo $described_instances | jq '.Reservations[] .Instances[] .Tags[] | select(.Key == "Name").Value' | tr -d \"`

# Associative array
declare -a arr1
declare -a arr2

pcounter=0
for p in $private_ips
do
  arr1[$pcounter]=$p
  let pcounter=pcounter+1
done

hcounter=0
for h in $hostnames
do
  arr2[$hcounter]=$h
  let hcounter=hcounter+1
done

# clear /etc/hosts file
sed -i '11,$d' ${hosts_file}
# Do your thing
counter=0
for i in $private_ips
do
        found=`fgrep -c "${arr2[${counter}]}" ${hosts_file}`

        if [ "$i" != "null" ]; then

          if [ $found -eq 1 ]; then
            echo -e "${arr1[${counter}]}\t${arr2[${counter}]}-${found}" >> ${hosts_file}
          else
            echo -e "${arr1[${counter}]}\t${arr2[${counter}]}" >> ${hosts_file}
          fi
        fi

        let counter=counter+1
done