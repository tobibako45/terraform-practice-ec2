data aws_ssm_parameter amzn2_ami {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

# resource aws_instance demo {
#   ami           = data.aws_ssm_parameter.amzn2_ami.value
#   instance_type = "t2.micro"
#   subnet_id     = "subnet-06edf236c91e429a9"
#   tags = {
#     Name = "ec2-terrafor-test"
#   }
# }

resource "aws_instance" "terraform-web" {                # EC2インスタンスに関する記述。コード内ではterraform-webという名前でアクセスできる
  count         = 1                                      # インスタンスの数
  ami           = data.aws_ssm_parameter.amzn2_ami.value # どのAMIをベースにインスタンスを作成するか、ID指定
  instance_type = "t2.micro"                             # インスタンスタイプ指定
  subnet_id     = "subnet-06edf236c91e429a9"
  tags = {
    Name = "ec2-terraform" # タグに Name: ec2-terraform をセット
  }
}

# resource "aws_instance" "sandbox" {
#   count         = 1
#   ami           = "ami-785c491f" # Ubuntu 16.04 LTS official ami
#   instance_type = "t2.micro"
#   subnet_id     = "subnet-06edf236c91e429a9"
#   tags = {
#     # Name = "${format("sandbox-%02d", count.index + 1)}"
#     Name = "${format("vvvvvvvv-modified sandboxbox-%02d", count.index + 1)}"
#   }
# }
