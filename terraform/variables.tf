#Variables file specifying variable types and default values
#Check conf.tfvars (this will will be automatically loaded unless other file is specified)



variable "awsregion" {
  description = "AWS region used to create resources"
  type = "string"
  #default value is optional but if no default provided, the variable is considered required and terraform will error
  default = "us-east-1"
}


#VPC variables

variable "cidr" {
  description = "VPC CIDR block"
  type = "string"
}

variable "enable_dns_support" {
  description = "Should be true if you want DNS resolution supported by VPC. Default value for user created VPCs is true."
  default = true
}

variable "enable_dns_hostnames" {
  description = "True means the instances launched in that VPC will get a public DNS hostname" 
  default = false
}

variable "vpc_resource_tags" {
  description = "Map of tags for all instances launched inside the created VPC"
  type = "map"
  default = {
    "Scope" = "LicentaPatri"
    "Provisioner" = "terraform"
  }
}

variable "vpc_name" {
  description = "Name tag for created VPC"
  type = "string"
}

#Variables for public subnet configuration
variable "public_subnet_cidr_block" {
  description = "CIDR block for public subnet"
  type = "list"
}

#Should be list of availability zones for high availabilty configuration
variable "subnet_avz" {
  description = "Availability zone for public subnet"
  type = "list"
}

variable "private_subnet_cidr_block" {
  description = "CIDR block for private subnet"
  type = "list"
}
