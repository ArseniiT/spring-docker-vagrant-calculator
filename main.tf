provider "aws" {
  region = "us-east-1"
  profile = "academy"
}

# SSH key pair
variable "ssh_key_path" {
  default = "~/.ssh/id_rsa.pub"
}

resource "aws_key_pair" "runner_key" {
  key_name   = "gitlab-runner-key"
  public_key = file(var.ssh_key_path)
}

resource "aws_security_group" "runner_sg" {
  name        = "gitlab-runner-sg"
  description = "Allow SSH and GitLab Runner access"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 instance for GitLab Runner
resource "aws_instance" "gitlab_runner" {
  ami           = "ami-04b4f1a9cf54c11d0"
  instance_type = "t2.micro"
  key_name      = aws_key_pair.runner_key.key_name
  security_groups = [aws_security_group.runner_sg.name]

  tags = {
    Name = "GitLab-Runner"
  }

  # start GitLab Runner configuration
  provisioner "local-exec" {
    command = "sleep 30 && ansible-playbook -i '${self.public_ip},' configure_runner.yml"
  }
}

output "runner_ip" {
  value       = aws_instance.gitlab_runner.public_ip
  description = "Public IP of the GitLab Runner"
}
