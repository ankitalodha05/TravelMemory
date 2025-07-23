resource "aws_instance" "frontend" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name
  security_groups = [aws_security_group.frontend_sg.name]
  user_data = file("./scripts/frontend_setup.sh")
  tags = { Name = "FrontendServer" }
}

resource "aws_instance" "backend" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name
  security_groups = [aws_security_group.backend_sg.name]
  user_data = file("./scripts/backend_setup.sh")
  tags = { Name = "BackendServer" }
}
