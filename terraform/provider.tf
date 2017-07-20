#Provider configuration

provider "aws" {
  region = "${var.awsregion}"
  shared_credentials_file = "/home/vagrant/.aws/credentials"
  profile = "default"
}
