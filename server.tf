## Nessus VM Scanner Server Provision ##

# Generate cloud-init
data "template_file" "nessus-user-data" {
  template = "${file("${path.module}/templates/user-data.json.tpl")}"

  vars {
    name     = "${var.scanner_name}"
    key      = "${var.tenable_linking_key}"
    iam_role = "${aws_iam_role.nessus-server-role.name}"
  }
}

# Find the latest AMI by product code
data "aws_ami" "nessus-image" {
  most_recent = true

  filter {
    name   = "product-code"
    values = ["4m4uvwtrl5t872c56wb131ttw"]
  }
}

# Create the instance
resource "aws_instance" "nessus-scanner" {
  ami                    = "${data.aws_ami.nessus-image.id}"
  vpc_security_group_ids = ["${aws_security_group.nessus-security-group.id}"]
  iam_instance_profile   = "${aws_iam_instance_profile.nessus-server-profile.name}"
  subnet_id              = "${var.subnet_id}"
  user_data              = "${data.template_file.nessus-user-data.rendered}"
  instance_type          = "${var.instance_type}"

  tags = {
    Name = "${var.instance_name}"
  }

  root_block_device = {
    volume_type = "gp2"
    volume_size = "50"
  }
}
