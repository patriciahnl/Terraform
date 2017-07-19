#Variables file

variable "awsregion" {
  description = "AWS region used to create resources"
  type = "string"
  #default value is optional but if no default provided, the variable is considered required and terraform will error
  default = "us-east-1"
}
