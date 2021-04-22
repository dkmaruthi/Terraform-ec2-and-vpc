provider "aws" {
  region =var.region
}

resource "aws_instance" "server" {
  count =2
  ami = var.ami
 instance_type = var.instance_type

 //to launch mutiple instances in different AZ you should add differet subnets

  subnet_id = "${element(var.subnet,count.index)}"
  key_name=aws_key_pair.key.id


// to give the server +1 ,it will add terrform 1 and terraform 2
  tags = {
    Name = "Terraform server ${count.index+1}"
  }
} 

  resource "aws_key_pair" "key" {
  key_name   = "sample"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDi3B2S8Kdp+da8N/00pnp2WyrZpTs9NLFTAynD0lP9YEiQ2BPNakJKBWuYgQFKbaQ9Vth7p8y3uySan2fbZNdCcQBrIALccoRQUhGV12loGvhTQ9MiSHh/3dmrV/LmDZyqaTFubcpvyYLA/13v4hl3XWUu//O6YzDTlWgt2zE0XYeQGg8azt/c86YCWKi/Vqk3yguMbBdby2tj+C1eZ+xgznfPS+xlV6aSsL9/06oR7LWti/az2Epoy72s1pf1p6QaUZm4S+pEgVEH+EZhLUjYc4y4jlFy60g7GqaD1N2yho15tkEjz0JHBoLvMZCr8k2wegFnphTUeBIh5s3dpI5J maruthi-pc@DESKTOP-NE419II"
  }