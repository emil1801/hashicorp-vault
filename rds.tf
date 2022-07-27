provider "aws" {
	region = "us-east-1"
    access_key = "AKIAREHQL3A6Q5NRETVX"
    secret_key = "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"
}


data "aws_availability_zones" "all" {}


output "AZ" {
	value = data.aws_availability_zones.all.names
}




resource "aws_default_subnet" "default_az1" {
	availability_zone = data.aws_availability_zones.all.names[0]
	tags = {
		Name = "Subnet1"
	}
}
resource "aws_default_subnet" "default_az2" {
	availability_zone = data.aws_availability_zones.all.names[1]
	tags = {
		Name = "Subnet2"
	}
}
resource "aws_default_subnet" "default_az3" {
	availability_zone = data.aws_availability_zones.all.names[2]
	tags = {
		Name = "Subnet3"
	}
}

output "subnet1" {
	value = [ 
		aws_default_subnet.default_az1.id,
		aws_default_subnet.default_az2.id,
		aws_default_subnet.default_az3.id,
	]
}
terraform {
  backend "s3" {
    bucket = "terraform-state-hashicorp-vault"
    key    = "path/to/my/db"
    region = "us-east-1"
    access_key = "AKIAREHQL3A6Q5NRETVX"
    secret_key = "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"
  }
}
resource "aws_db_subnet_group" "db" {
	name = "db"
	subnet_ids = [
		aws_default_subnet.default_az1.id,
		aws_default_subnet.default_az2.id,
		aws_default_subnet.default_az3.id,
	]
}


resource "aws_db_instance" "default" {
	identifier = "dbname"
	allocated_storage = 20
	storage_type = "gp2"
	engine = "mysql"
	engine_version = "5.7"
	instance_class = "db.t2.micro"
	db_name = "mydb"
	username = "admin"
	password = random_password.random.result
	publicly_accessible = true
	db_subnet_group_name = aws_db_subnet_group.db.name
	skip_final_snapshot = true #used to delete the repo in the future without this you cant delete. There are bugs reported 
}