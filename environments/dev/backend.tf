terraform {
  backend "s3" {
    bucket         = "my-project-terraform-state-683668078297-team03"
    key            = "dev/terraform.tfstate"
    region         = "ap-northeast-2"
    encrypt        = true
    dynamodb_table = "my-project-terraform-lock"
  }
}
