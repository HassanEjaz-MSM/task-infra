locals {
  role     = "java-app"
  vpc_name = "test-vpc"
  alb_name = "test-alb"
}

module "test-vpc" {
  source                     = "../modules/vpc-basic/"
  vpc_name                   = local.vpc_name
}

module "sg_pub" {
  source                     = "../modules/sg/"
  tcp_ports                  = "22,8080"
  cidrs                      = flatten(["0.0.0.0/0"])
  security_group_name        = "sg_pub"
  vpc_id                     = module.test-vpc.vpc_id
}

module "sg_priv" {
  source                     = "../modules/sg/"
  tcp_ports                  = "22,8080,5432"
  cidrs                      = flatten([module.test-vpc.vpc_cidr])
  security_group_name        = "sg_priv"
  vpc_id                     = module.test-vpc.vpc_id
}

module "alb" {
  source                     = "../modules/alb/"
  name                       = local.alb_name
  security_groups            = flatten([module.sg_pub.sg_id])
  vpc_id                     = module.test-vpc.vpc_id
  subnets                    = [module.test-vpc.public_subnet,module.test-vpc.public2_subnet]
}

module "jumpbox"{
  source                     = "../modules/jumpbox"
  ami                        = "ami-07ebfd5b3428b6f4d"
  key_name                   = "test"
  subnet_id                  = module.test-vpc.public_subnet
  sg                         = flatten([module.sg_pub.sg_id])

}

module "aurora-postgresql" {
  source                     = "../modules/aurora-postgresql"
  pgdb_name                  = "pgdb"
  pgdb_username              = "postgres"
  pgdb_password              = "postgres"
  create_monitoring_iam_role = true
  instance_count             = 1
  vpc_id                     = module.test-vpc.vpc_id
  subnet_ids                 = [module.test-vpc.priv1, module.test-vpc.priv2]
  ingress_blocks             = flatten(["10.68.2.160/27", "10.68.2.128/27"])
}

module "java-app" {
  source                     = "../modules/asg-basic"
  image_id                   = "ami-07ebfd5b3428b6f4d"
  instance_type              = "t3.micro"
  security_groups            = [module.sg_priv.sg_id]
  max_size                   = "4"
  min_size                   = "2"
  vpc_zone_identifier        = [module.test-vpc.priv1, module.test-vpc.priv2]
  key_name                   = "test"
  tg_arn                     = [module.alb.target_group_arn]
  db_host                    =  module.aurora-postgresql.pgdb_endpoint
}

