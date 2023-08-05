resource "aws_ebs_volume" "instance_ebs" {
  availability_zone = "ap-northeast-2a"
  size              = 10
  type              = "gp2"
  tags              = local.tags
}

resource "null_resource" "expand_disk" {
  triggers = {
    always_run = timestamp()
  }

  connection {
    type        = "ssh"
    user        = "ec2-user"
    password    = ""
    private_key = file("bhhan-instance-key.pem")
    host        = aws_instance.ebs_instance.public_ip
}
  provisioner "remote-exec" {
    inline = [
      "sudo pvresize ${var.device_name}",
      "sudo lvextend -l +100%FREE /dev/mapper/${var.vg_name}-${var.lv_name}",
      "sudo xfs_growfs /dev/mapper/${var.vg_name}-${var.lv_name}"
    ]
  }
}
