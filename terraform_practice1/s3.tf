resource "aws_s3_bucket" "s3_bucket" {
  bucket = "emibucket-tf"

  tags = {
    Name = "My bucket"
  }
}
