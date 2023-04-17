
variable "ami_org_id" {
  type    = string
  default = "arn:aws:organizations::210778840360:organization/o-aloscqyzuy"
}

variable "application_environment" {
  type    = string
  default = "production"
}

variable "application_name" {
  type    = string
  default = "golden-image"
}

variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "kms_key_arn" {
  type      = string
  default   = "arn:aws:kms:us-east-1:869825878781:key/1a304bb5-9d1b-4f79-82e3-46356663036d"
  sensitive = true
}

variable "kms_key_id" {
  type      = string
  default   = "alias/ec2-generalkey"
  sensitive = true
}

variable "os" {
  type    = string
  default = "AL2"
}

variable "security_group_id" {
  type      = string
  default   = "sg-085a2cbb4f6387885"
  sensitive = true
}

variable "subnet_id" {
  type      = string
  default   = "subnet-09c393462bff719f8"
  sensitive = true
}

variable "vpc_id" {
  type      = string
  default   = "vpc-01e54f4d8403a217c"
  sensitive = true
}

data "amazon-ami" "golden_image" {
  filters = {
    name                = "amzn2-ami-kernel-5.10-hvm-2.0.20220606.1-x86_64-gp2"
    root-device-type    = "ebs"
    virtualization-type = "hvm"
  }
  most_recent = true
  owners      = ["amazon"]
  region      = "${var.aws_region}"
}

source "amazon-ebs" "golden_image" {
  ami_description             = "Default image for PicPay application"
  ami_name                    = "golden-image-{{isotime \"2006-01-02-03-04-05\"}}"
  ami_org_arns                = ["${var.ami_org_id}"]
  ami_regions                 = ["${var.aws_region}"]
  associate_public_ip_address = true
  communicator                = "ssh"
  encrypt_boot                = true
  force_delete_snapshot       = false
  force_deregister            = false
  instance_type               = "t2.micro"
  kms_key_id                  = "${var.kms_key_id}"
  region                      = "${var.aws_region}"
  region_kms_key_ids = {
    "${var.aws_region}" = "${var.kms_key_arn}"
  }
  run_tags = {
    Application = "${var.application_name}"
    Environment = "${var.application_environment}"
    Layer       = "devops"
    Name        = "builder-${var.application_name}"
    bu          = "security"
    project     = "golden-image"
    squad       = "SRE"
    tribe       = "CloudOps"
  }
  run_volume_tags = {
    Application = "${var.application_name}"
    Environment = "${var.application_environment}"
    Layer       = "devops"
    Name        = "builder-${var.application_name}"
    bu          = "security"
    project     = "golden-image"
    squad       = "SRE"
    tribe       = "CloudOps"
  }
  security_group_id = "${var.security_group_id}"
  source_ami        = "${data.amazon-ami.golden_image.id}"
  ssh_username      = "ec2-user"
  subnet_id         = "${var.subnet_id}"
  tags = {
    Application = "${var.application_name}"
    Environment = "${var.application_environment}"
    Layer       = "devops"
    Name        = "picpay-${var.os}"
  }
  vpc_id = "${var.vpc_id}"
  aws_polling {
   delay_seconds = 80
   max_attempts  = 10
  }
}

build {
  sources = ["source.amazon-ebs.golden_image"]

  provisioner "ansible" {
    extra_arguments = ["-e", "aws_region='${var.aws_region}'", "-e", "environment='${var.application_environment}'", "-e", "application_name='${var.application_name}'", "-e", "@group_vars/all.yml", "-e", "@hosts_vars/${var.application_name}-vars.yml"]
    playbook_file   = "playbooks/application.yaml"
    user            = "packer"
  }

}
