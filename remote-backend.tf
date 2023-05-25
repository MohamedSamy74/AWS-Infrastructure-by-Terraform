resource "aws_s3_bucket" "terraform-state" {
    bucket = "sami-terraform-state-bucket"
    object_lock_enabled = true
    lifecycle {
      prevent_destroy = true
    }
}

resource "aws_s3_bucket_versioning" "versioning_enabled" {
  bucket = aws_s3_bucket.terraform-state.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_dynamodb_table" "terraform-locks" {
  name           = "terraform-locks-table"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}

terraform {
  backend "s3" {
    bucket = "sami-terraform-state-bucket"
    key    = "dev/terraform.tfstate"
    region = "us-east-1"
    dynamodb_table = "terraform-locks-table"
    encrypt = true
  }
}
