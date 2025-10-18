provider "aws" {
	access_key = "test"
	secret_key = "test"
	region 	   = "us-east-1"

  # LocalStack configuration
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  skip_metadata_api_check     = true
  s3_use_path_style           = true
  
  endpoints {
    s3         = "http://localhost:4566"
    dynamodb   = "http://localhost:4566"
    lambda     = "http://localhost:4566"
    apigateway = "http://localhost:4566"
    iam        = "http://localhost:4566"
    ec2        = "http://localhost:4566"
    # Add other services as needed
  }
}
