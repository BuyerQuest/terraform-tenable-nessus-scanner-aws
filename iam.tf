## Nessus IAM role ##

resource "aws_iam_role" "nessus-server-role" {
  name               = "${var.instance_name}-role"
  assume_role_policy = data.aws_iam_policy_document.nessus-instance-assume-role-policy.json
}

# Role assumption policy
data "aws_iam_policy_document" "nessus-instance-assume-role-policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

## Role policy/permissions ##

# Attach canned ec2 read-only policy to the IAM role
resource "aws_iam_role_policy_attachment" "nessus-ec2-read-only" {
  role       = aws_iam_role.nessus-server-role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess"
}

## Instance Profile ##

# Assign the role to the instance profile
resource "aws_iam_instance_profile" "nessus-server-profile" {
  name = "${var.instance_name}-profile"
  role = aws_iam_role.nessus-server-role.name
}

