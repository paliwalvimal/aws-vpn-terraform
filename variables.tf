variable "aws_region_list" {
  type = "map"
  default = {
    "1"= "us-east-1"
    "2"= "us-east-2"
    "3"= "us-west-1"
    "4"= "us-west-2"
    "5"= "ca-central-1"
    "6"= "eu-west-1"
    "7"= "eu-west-2"
    "8"= "eu-central-1"
    "9"= "ap-southeast-1"
    "10"= "ap-southeast-2"
    "11"= "ap-northeast-1"
    "12"= "ap-northeast-2"
    "13"= "ap-south-1"
    "14"= "sa-east-1"
  }
}
variable "aws_profile" {
  default = "temp"
}
variable "instance_type" {
  default = "t2.micro"
}
