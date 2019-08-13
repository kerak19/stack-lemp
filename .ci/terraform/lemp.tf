module "lemp" {
  #####################################
  # Do not modify the following lines #
  source = "./module-lemp"

  project            = var.project
  env                = var.env
  customer           = var.customer
  deploy_bucket_name = var.deploy_bucket_name

  #####################################

  #. vpc_id (required):
  #+ Amazon VPC id on which create each components.
  vpc_id = "<vpc-id>"

  #. private_subnets_ids (required, array):
  #+ Amazon subnets IDs on which create each components.
  private_subnets_ids = ["private-subnets"]

  #. public_subnets_ids (required, array):
  #+ Amazon subnets IDs on which create each components.
  public_subnets_ids = ["public-subnets"]

  #. bastion_sg_allow (optional):
  #+ Amazon source security group ID which will be allowed to connect on Fronts port 22 (SSH).
  bastion_sg_allow = "<bastion-sg>"

  #. metrics_sg_allow (optional): ""
  #+ Additionnal security group ID to assign to servers. Goal is to allow monitoring server to query metrics.
  metrics_sg_allow = "<prometheus-sg>"

  #. keypair_name (requiredl): cycloid
  #+ Name of an existing AWS SSH keypair to use to deploy EC2 instances.
  keypair_name = "cycloid"

  ###
  # fronts
  ###

  #. front_count (optional): 1
  #+ Desired number of front servers
  front_count = "1"

  #. front_type (optional): t3.small
  #+ Type of instance to use for front servers
  front_type = "t3.small"

  #. front_ebs_optimized (optional, bool): false
  #+ Whether the Instance is EBS optimized or not, related to the instance type you choose.
  front_ebs_optimized = false
  #. front_disk_size (optional): 30
  #+ Disk size of front servers.

  #. application_ssl_cert (optional):
  #+ ARN of an Amazon cert (ACM) to use for the loadbalancer.

  #. front_asg_max_size (optional): 5
  #+ Maximum number of front server allowed in the AutoScaling group.

  ###
  # rds / mysql
  ###

  #. create_rds (optional, bool): false
  #+ Define if we want to create or not an RDS database.

  #. rds_database (optional): application
  #+ RDS database name.

  #. rds_password (optional): ChangeMePls
  #+ RDS password. expected value is "${var.rds_password}" to get it from the pipeline.

  #. rds_disk_size (optional): 10
  #+ RDS disk size.

  #. rds_multiaz (optional, bool): false
  #+ If the RDS instance is multi AZ enabled.

  #. rds_subnet_group (optional):
  #+ RDS subnet group name to use. If not specified, create a dedicated group with private_subnets_ids.

  #. rds_type (optional): db.t3.small
  #+ RDS database instance size.

  #. rds_username (optional): application
  #+ RDS database username.

  #. rds_engine (optional): mysql
  #+ RDS database engine to use.

  #. rds_engine_version (optional): 5.7.16
  #+ The version of the RDS database engine

  #. rds_backup_retention (optional): 7
  #+ The days to retain backups for. Must be between 0 and 35. When creating a Read Replica the value must be greater than 0

  #. rds_parameters (optional): default.mysql5.7
  #+ Name of the RDS parameters group to use.

  ###
  # ElastiCache / redis
  ###

  #. create_elasticache (optional, bool): true
  # Define if we want to create or not an Amazon ElastiCache

  #. cache_subnet_group (optional):
  #+ Name of the Amazon ElastiCache subnet group to use. If not specified, create a dedicated group with private_subnets_ids.

  #. elasticache_type (optional): cache.t2.micro
  #+ Instance size to use for ElastiCache nodes.

  #. elasticache_nodes (optional): 1
  #+ Number of nodes in the ElastiCache cluster.

  #. elasticache_parameter_group_name (optional): default.redis5.0
  #+ ElastiCache group parameter name to use.

  #. elasticache_engine_version (optional): 5.0.0
  #+ Version of the ElastiCache engine

  #. elasticache_engine (optional): redis
  #+ Type of the ElastiCache engine

  #. elasticache_port (optional): 6379
  #+ Port of the ElastiCache

  ###
  # S3 medias
  ###

  #. create_s3_medias (optional, bool): false
  #+ Create a S3 bucket dedicated to medias for the LEMP application


  # for ami id for testing purpose
  front_ami_id = "front_ami_id"
}
