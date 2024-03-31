provider "aws" {
  access_key = var.AWS_ACCESS_KEY
  secret_key = var.AWS_SECRET_KEY
  # region = local.db_creds.AWS_REGION
  region = "us-east-1"

assume_role {
  #the role ARN within Account A to assume role into. Created in step 1
  role_arn = "arn:aws:iam::730335195244:role/Engineer"

  }
}
