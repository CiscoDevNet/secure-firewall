########################################
# Key Pair
########################################

# Create a UserKeyPair for EC2 instance
resource "tls_private_key" "key_pair" {
  algorithm = "RSA"
  rsa_bits  = 4096
  #algorithm = "ED25519"
}

# Save the private key on local file
resource "local_file" "this" {
  content       = tls_private_key.key_pair.private_key_pem
  filename      = "${var.env_name}-private-key.pem"
  file_permission = 0600
}
# Save the public key on AWS
resource "aws_key_pair" "public_key" {
  key_name   = "${var.env_name}-${random_string.id.result}-key"
  public_key = tls_private_key.key_pair.public_key_openssh
  tags = {
    Name: "ftd-autoscale-public-key-pair"
  }
}

resource "random_string" "id" {
  length      = 4
  min_numeric = 4
  special     = false
  lower       = true
}
