# README #

This README would normally document whatever steps are necessary to get your application up and running.

### What is this repository for? ###

* 用於在bastion host上去取得ec2 ip and name並寫入/etc/hosts內

### How do I get set up? ###

* Summary of set up
    * give bastion host server role with ec2 readonly policy 
    * you need to install jq and aws cli
    * chmode +x /home/ubuntu/generatehostsfile.sh
    * init crontab
    * \*/5 * * * * /home/ubuntu/generatehostsfile.sh
