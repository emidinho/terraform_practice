# Below is Backend block
terraform {
  backend "s3" {
    bucket         = "imm-b-m-w-awesome-batch-1" # created upfront
    key            = "project1/test/immbmw.tfstate"
    region         = "us-west-2"
    profile        = "default"
    dynamodb_table = "immb-terraform-table"
  }
}

#s3 bucket name dybamodb table has to be created in the same region and same account