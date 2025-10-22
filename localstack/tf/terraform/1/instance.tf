resource "aws_instance" "example1" {
  ami           = "ami-0d729a60"
  instance_type = "t3.micro"

  # Fix: Enable detailed monitoring
  monitoring = true

  # Fix: Enable EBS optimization (for supported instance types)
  ebs_optimized = true

  # Fix: Attach IAM role (create this resource first)
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name

  metadata_options {
    http_tokens   = "required"
    http_endpoint = "enabled"
  }

  root_block_device {
    encrypted = true
  }

  # Optional: Add tags
  tags = {
    Name = "example-instance"
  }
}
