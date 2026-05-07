data "aws_ami" "al2023_x86" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}
resource "aws_instance" "ac1-instance" {
  ami             = data.aws_ami.al2023_x86.image_id
  instance_type   = "t2.micro"
  vpc_security_group_ids = [ aws_security_group.ac1-sg.id ]
  subnet_id              = aws_subnet.ac1-private-subnet.id
  key_name        = "vockey"
  tags = {
    Name      = "ac1-instance"
    terraform = "True"
  }

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("/home/ec2-user/actuacionisc/labsuser.pem")
    host        = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum install httpd git curl",
      "git clone https://github.com/mauricioamendola/chaos-monkey-app.git",
      "sudo mv chaos-monkey-app/website/* /var/www/html/",
      "sudo systemctl enable httpd",
      "sudo systemctl start httpd"
      
    ]
  }
}

resource "aws_instance" "ac2-instance" {
  ami             = data.aws_ami.al2023_x86.image_id
  instance_type   = "t2.micro"
  vpc_security_group_ids = [ aws_security_group.ac1-sg.id ]
  subnet_id              = aws_subnet.ac1-private-subnet-2.id
  key_name        = "vockey"
  tags = {
    Name      = "ac2-instance"
    terraform = "True"
  }

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("/home/ec2-user/actuacionisc/labsuser.pem")
    host        = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum install httpd git curl",
      "git clone https://github.com/mauricioamendola/chaos-monkey-app.git",
      "sudo mv chaos-monkey-app/website/* /var/www/html/",
      "sudo systemctl enable httpd",
      "sudo systemctl start httpd"
      
    ]
  }
}