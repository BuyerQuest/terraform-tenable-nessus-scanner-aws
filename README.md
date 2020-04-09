# Terraform Module for Tenable.io's Nessus Scanner on AWS

This module will set up the latest release of [Tenable.io's preauthorized Nessus scanner from the AWS marketplace](https://aws.amazon.com/marketplace/pp/B01LXCD58S?qid=1532453752682). It will also update your machine if you run it again after the release of a newer version of the AMI.

Terraform modules don't always have the options you need out of the box, and I threw this together pretty quickly for use in my environment. However, as long as you can specify a VPC and a subnet, you should be able to use it.

## Versioning

This module supports Terraform 0.12 or later. See the branches list for older versions of Terraform.

To pin a version of this module, [use a ref link](https://www.terraform.io/docs/modules/sources.html#selecting-a-revision) to pin a commit or tag. Tags are the date of a release, nothing fancy.

# Usage

In tenable.io's web UI, grab your linking key from [the **Scans > Scanners** page](https://cloud.tenable.com/app.html#/scans/scanners)

### Inputs

Add this module to your terraform project's source code and provide the following:
  - Tenable Linking Key
  - VPC ID
  - Subnet ID
  - (Optional) Instance type, defaults to m5.xlarge
  - (Optional) Instance name, defaults to nessus-scanner
  - (Optional) Scanner name (a friendly name to show in the Tenable.io UI), defaults to Instance name.
  - (Optional) A map of tags to apply to the instance

### Outputs

The module creates a security group, and you can access that group's id with the `security_group_id` output. Useful for opening up the AWS firewalls to allow scanning.

#### Example:

```hcl
module "nessus_scanner" {
  source = "github.com/BuyerQuest/terraform-tenable-nessus-scanner-aws"

  scanner_name        = "My AWS Nessus Scanner"
  tenable_linking_key = "pvwk5qf5bwsuperfakekeypqv3zcovanqnuawebmv23rj9fofsdcul7aaa"
  vpc_id              = "vpc-31896b55"
  subnet_id           = "subnet-4204d234"
  instance_type       = "t3.xlarge"
  instance_name       = "my-nessus-scanner"

  instance_tags = {
    Role        = "security-scanner"
    Projects    = "tenable"
  }
}
```
