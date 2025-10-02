resource "aws_s3_bucket" "backend_terraform" {
   bucket= var.bucketname
    force_destroy = true

}


resource "aws_s3_bucket_versioning" "backend_terraform" {
  bucket = aws_s3_bucket.backend_terraform.id
  versioning_configuration {
    status = "Enabled"
  }
}