resource "aws_instance" "ebs_instance" {
  ami             = var.ami
  instance_type   = var.instance_type
  subnet_id       = module.vpc.public_subnet_id[0]
  key_name        = var.instance_key_name
  security_groups = [aws_security_group.instance_sg.id]

  user_data = base64encode(templatefile("${path.module}/instance.tpl", {
    device    = var.device_name
    vg        = var.vg_name
    lv        = var.lv_name
    data_path = var.data_path
  }))

  tags = local.tags

  lifecycle {
    ignore_changes = [
      security_groups
    ]
  }

  depends_on = [
    aws_ebs_volume.instance_ebs
  ]
}

resource "aws_security_group" "instance_sg" {
  name        = "instance security group"
  description = "port 22 allow traffic"
  vpc_id      = module.vpc.vpc_id

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

  tags = local.tags
}

resource "aws_volume_attachment" "instance_ebs_attachment" {
  device_name = var.device_name
  volume_id   = aws_ebs_volume.instance_ebs.id
  instance_id = aws_instance.ebs_instance.id
}
