# stack-lemp
(Linux, Nginx, MySQL, PHP)

Linux operating system
Nginx (Pronounced as Engine-X) web server
MySQL (RDS) database server
PHP-fpm for dynamic data processing


# Architecture

This stack will deploy a php application on X Amazon EC2 instances behind an ALB load balancer, using RDS database and optional ElasticCache/s3 medias bucket.

<img src="https://raw.githubusercontent.com/cycloid-community-catalog/stack-lemp/master/diagram.png" width="400">

  * **ALB**: Amazon application loadbalancer
  * **ASG**: Autoscaling group for fronts
  * **front**: EC2 instances from builded AMI
  * **RDS** (optional): Amazon RDS database (mysql)
  * **Elasticache** (optional): Amazon Elasticache (redis)
  * **S3 bucket** (optional): public medias bucket

> **Pipeline** The pipeline contains a manual approval between terraform plan and terraform apply.
> That means if you trigger a terraform plan, to apply it, you have to go on terraform apply job
> and click on the `+` button to trigger it.

# Requirements

In order to run this task, couple elements are required within the infrastructure:

* Having a VPC with private & public subnets containing a bastion server that can access instances by SSH
* Having an S3 bucket for terraform remote states
* Having an S3 bucket for magento code WITH versioning enable


# Details

**Pipeline**

  * Run packer to build debian Amazon AMI with nginx, php-fpm and telegraph metrics (port 9100 prometheus format).

**Terraform**

Create:

  * ALB (loadbalancer)
  * ASG with launch_template of fronts
  * RDS (optional)
  * Elasticache (optional)
  * S3 bucket (optional) + Iam

**Ansible**

  * Playbook and packer config to build a debian image with telegraf, fluentd, nginx and php-fpm installed


# Troubleshooting

## Test ansible role with molecule

Requires a bucket which contains a build of magento sources and AWS accesskey

virtualenv if needed
```
virtualenv    .env  --clear
source .env/bin/activate

pip install ansible==2.7
pip install molecule
pip install docker-py
```

Run the test
```
cd ansible

export AWS_SECRET_ACCESS_KEY=AKI...
export AWS_ACCESS_KEY_ID=....

export DEPLOY_BUCKET_NAME=cycloid-deploy
export DEPLOY_BUCKET_OBJECT_PATH=catalog-lemp-app/ci/lemp-app.tar.gz
export DEPLOY_BUCKET_REGION=eu-west-1

# Run molecule
molecule destroy
molecule converge
molecule verify
```
