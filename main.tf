provider "aws" {
  # access_key = "anaccesskey"
  # secret_key = "asecretkey"
  # shared_credentials_file = "~/.aws/credentials" # これでもいい。aws cli で設定したやつを読み込む
  region  = "ap-northeast-1" # Terraformのコードで環境を作成する対象のリージョン
  profile = "default"        # キーを指定せず、AWS CLIに設定したdefaultのcredentials情報を用いる
}


# # VPC
# resource "aws_vpc" "this" {
#   cidr_block           = "10.1.0.0/16"
#   instance_tenancy     = "default"
#   enable_dns_support   = "true"
#   enable_dns_hostnames = "true"
#   tags {
#     Name = "tf-example-vpc"
#   }
# }
