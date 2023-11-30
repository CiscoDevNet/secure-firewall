####################
# S3 Operations
####################

# Generate Random Tag

resource "random_pet" "random_prefix" {
  prefix = var.env_name
  length = 1
}

# Create S3  Buckets

resource "aws_s3_bucket" "ngfw_gwlb_autoscale_bucket" {
  bucket = "${random_pet.random_prefix.id}-ftd-gwlb-autoscale-bucket"
}

# Add S3 Objects

resource "aws_s3_object" "lambda_layer_files" {
  bucket = aws_s3_bucket.ngfw_gwlb_autoscale_bucket.id
  key    = "autoscale_layer.zip"
  source = "${path.module}/target/autoscale_layer.zip"
  etag = filemd5("${path.module}/target/autoscale_layer.zip")
}

resource "aws_s3_object" "autoscale_manager_files" {
  bucket = aws_s3_bucket.ngfw_gwlb_autoscale_bucket.id
  key    = "autoscale_manager.zip"
  source = "${path.module}/target/autoscale_manager.zip"
  etag = filemd5("${path.module}/target/autoscale_manager.zip")
}
/*
resource "aws_s3_object" "custom_metric_fmc_files" {
  bucket = aws_s3_bucket.ngfw_gwlb_autoscale_bucket.id
  key    = "custom_metric_fmc.zip"
  source = "${path.module}/target/custom_metric_fmc.zip"
  etag = filemd5("${path.module}/target/custom_metric_fmc.zip")
}
*/
resource "aws_s3_object" "lifecycle_ftdv_files" {
  bucket = aws_s3_bucket.ngfw_gwlb_autoscale_bucket.id
  key    = "lifecycle_ftdv.zip"
  source = "${path.module}/target/lifecycle_ftdv.zip"
  etag = filemd5("${path.module}/target/lifecycle_ftdv.zip")
}