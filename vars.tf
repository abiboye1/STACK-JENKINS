variable "AWS_ACCESS_KEY" {}
variable "AWS_SECRET_KEY" {}
# variable "AWS_REGION" {}
# variable "ami" {}

variable "environment" {
  default = "dev"
}

# variable "vpc_id" {
#   default = aws_vpc.main.id
# }


variable "system" {
  default = "Retail Reporting"
}

variable "subsystem" {
  default = "CliXX"
}

variable "availability_zone" {
  type = list(string)
  default = ["us-east-1a", "us-east-1c"]
}

variable "subnets_cidrs" {
  type = list(string)
  default = [
    "172.31.80.0/20"
  ]
}

variable "instance_type" {
  default = "t2.micro"
}

variable "PATH_TO_PRIVATE_KEY" {
  default = "my_key"
}

variable "PATH_TO_PUBLIC_KEY" {
  default = "my_key.pub"
}

variable "OwnerEmail" {
  default = "yomioye007@gmail.com"
}

variable "AMIS" {
  type = map(string)
  default = {
    us-east-1 = "ami-image-1.0"
    us-west-2 = "ami-06b94666"
    eu-west-1 = "ami-844e0bf7"
  }
} 

variable "subnet" {
  default = [
    "subnet-084af3f094dd68af5",
    "subnet-0968e42ba44d724f5",
    "subnet-0a446bdb58c6c05c4",
    "subnet-0b6dd1ae9c524e818"
  ]
}

variable "project" {
  default =  "CliXX-ASP"
}

variable "subnet_ids" {
  type = list(string)
  default = [ 
    "subnet-084af3f094dd68af5",
    "subnet-0968e42ba44d724f5",
    "subnet-0a446bdb58c6c05c4",
    "subnet-0b6dd1ae9c524e818"
    ]
}

variable "stack_controls" {
  type = map(string)
  default = {
    # ec2_create    = "Y"
    blog_create   = "N"
    clixx_create  = "Y"
    # ebs_create    = "Y"
  }
}

variable "EC2_Components" {
  type = map(string)
  default = {
    volume_type           = "gp2"
    volume_size           = 30
    delete_on_termination = true
    encrypted             = "true"
    instance_type         = "t2.micro"
  }
}

variable "num_ebs_volumes" {
  description = "Number of EBS volumes to create"
  default     = 3  
}

variable "ebs_volumes" {
  description = "Map of availability zones and corresponding sizes for EBS volumes"
  type        = map
  default     = {
    "us-east-1a" = 8
    "us-east-1a" = 8
    "us-east-1a" = 8
  }
}

variable "blog_snapshot_id" {
    default = "arn:aws:rds:us-east-1:730335195244:snapshot:snap-03-04" 
}

variable "clixx_snapshot_id" {
    default = "arn:aws:rds:us-east-1:730335195244:snapshot:my-clixx-snapshot-abib" 
}


# variable "db_user_clixx" {}

# variable "db_user_blog" {}

# variable "db_password" {}

# variable "db_name" {}

variable "dev_names" {
  default = ["sdf", "sdg", "sdh", "sdi", "sdj"]
}

variable "clixx-db-identifier" {
  default = "clixx-retail-app"
  type    = string
}

variable "blog-db-identifier" {
  default = "wordpress-blog"
  type    = string
}