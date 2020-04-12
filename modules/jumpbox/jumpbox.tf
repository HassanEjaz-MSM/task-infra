# Define bastion inside the public subnet
resource "aws_instance" "jumpbox" {
    ami                         = var.ami
    instance_type               = "t2.micro"
    key_name                    = var.key_name
    subnet_id                   = var.subnet_id
    vpc_security_group_ids      = var.sg
    associate_public_ip_address = true
    source_dest_check           = false
    connection {
        type                    = "ssh"
        user                    = "ubuntu"
        private_key             = "${file("${path.module}/${var.pemfile}")}"
        host                    = aws_instance.jumpbox.public_ip
        agent                   = "false"
    }
    /*provisioner "file" {
        source                  = "${path.module}/userdata.sh"
        destination             = "/tmp/userdata.sh"
    }
    provisioner "remote-exec" {
        inline = [
        "sudo chmod +x /tmp/userdata.sh",
        "sudo /tmp/userdata.sh",
        ]
    }*/
    tags = {
        Name                    = "Jumpbox Host"
    }
}