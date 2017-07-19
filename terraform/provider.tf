#Provider configuration

provider "aws" {
  region = "${var.awsregion}"
  shared_credentials_file = "$HOME/.aws/credentials"
}
