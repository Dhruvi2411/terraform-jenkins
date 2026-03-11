resource "aws_s3_bucket" "first_bucket" {

  bucket = "first-bucket-${terraform.workspace}-11-03-26"

  tags = {
    "Resource Owner"    = "Dhruvi"
    "Create Date"       = "11 March 2026"
    "Business Unit"     = "eInfochips"
    "Sub Business Unit" = "PES-IA"
    "Project Name"      = "Testing and Learning"
    "Delivery Manager"  = "Shahid Raza"
  }

}

resource "aws_s3_bucket_acl" "example" {
  bucket = aws_s3_bucket.first_bucket.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "versioning_example" {
  bucket = aws_s3_bucket.first_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}