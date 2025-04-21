module "extract_semo" {
  source = "./extract_semo"
  env = var.env
  aws_region = var.aws_region
  s3_bucket_details = local.lambda_s3_bucket_info
}



