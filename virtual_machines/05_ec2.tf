resource "aws_security_group" "instance_sg" {
    name = "step5_allow_ssh"
    description = "Allow SSH inbound traffic"
    vpc_id = aws_vpc.main_vpc.id

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_instance" "web_server" {
    ami = "ami-0d27e0fb3bac4d724"
    instance_type = "t3.micro"
    subnet_id = aws_subnet.public_subnet.id
    vpc_security_group_ids = [aws_security_group.instance_sg.id]
    tags = {
        Name = "step5-ec2-instance"
    }
}