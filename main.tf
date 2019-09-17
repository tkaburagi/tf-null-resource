terraform {
  required_version = "~> 0.12"
}

provider "aws" {
	access_key = var.access_key
	secret_key = var.secret_key
	region = var.region
}


resource "null_resource" "invoked_by_user_creation" {
	triggers = {
		iam_user = aws_iam_user.lb.id
	}
	provisioner "local-exec" {
		command = "echo INVOKED"
	}

}

resource "aws_iam_user" "lb" {
	name = "loadbalancer"
	path = "/system/"

	tags = {
		tag-key = "tag-value"
	}
}

resource "aws_iam_access_key" "lb" {
	user = aws_iam_user.lb.name
}

resource "aws_iam_user_policy" "lb_ro" {
	name = "test"
	user = aws_iam_user.lb.name

	policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ec2:Describe*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_instance" "hello-tf-instance" {
	ami = "ami-06d9ad3f86032262d"
	count = 1
	instance_type = "t2.micro"
}