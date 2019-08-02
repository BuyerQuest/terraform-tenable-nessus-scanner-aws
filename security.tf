## Create the Nessus Security Groups ##

resource "aws_security_group" "nessus-security-group" {
  name        = "${local.instance_tags["Name"]}-security"
  description = "Security group for the Nessus VM Scanner Server instance (Deny all inbound)"
  vpc_id      = var.vpc_id
}

# The documentation for Tenable on AWS recommends a security group with
# no entries in it, but mine had a problem without the egress rule.

## Outbound traffic ##
resource "aws_security_group_rule" "nessus-allow-outbound" {
  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = aws_security_group.nessus-security-group.id
}
