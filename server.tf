## Nessus VM Scanner Server Provision ##

# Generate cloud-init
locals {
  user_data_map = {
    name     = coalesce(var.scanner_name, local.instance_tags["Name"])
    key      = var.tenable_linking_key
    iam_role = aws_iam_role.nessus-server-role.name
    aws_scanner = true
  }
}

# Find the latest AMI by product code
data "aws_ami" "nessus-image" {
  most_recent = true
  owners      = ["aws-marketplace"]

  filter {
    name   = "product-code"
    values = ["8fn69npzmbzcs4blc4583jd0y"]
  }

  dynamic "filter" {
    for_each = var.extra_filters
    content {
      name   = filter.value.name
      values = filter.value.values
    }
  }
}

# Create the instance
resource "aws_instance" "nessus-scanner" {
  ami                    = data.aws_ami.nessus-image.id
  vpc_security_group_ids = [aws_security_group.nessus-security-group.id]
  iam_instance_profile   = aws_iam_instance_profile.nessus-server-profile.name
  subnet_id              = var.subnet_id
  user_data              = jsonencode(local.user_data_map)
  instance_type          = var.instance_type

  tags = local.instance_tags

  root_block_device {
    volume_type = "gp3"
    volume_size = "50"
  }
}

resource "aws_eip" "nessus-scanner-eip" {
  count    = var.use_eip ? 1 : 0
  vpc      = true
  instance = aws_instance.nessus-scanner.id

  tags = {
    Name = "${local.instance_tags["Name"]}_EIP"
  }
}
