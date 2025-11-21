terraform {
  backend "s3" {
    bucket         = "terraform-remote-state-humera"  # <-- your S3 bucket name
    key            = "terraform.tfstate"            # state file name in S3
    region         = "us-east-1"                     # bucket region
    dynamodb_table = "terraform-lock"               # DynamoDB table for locking
    encrypt        = true                            # encrypt state file
  }
}
