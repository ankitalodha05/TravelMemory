resource "aws_security_group" "frontend_sg" {
  name        = "frontend-sg"
  description = "Allow frontend traffic"
  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
