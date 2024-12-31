# LAMBDA
resource "aws_lambda_function" "lambda_function" {
  function_name = "${var.lambda_function_name}-${var.env}"
  role = aws_iam_role.lambda_exec_ecr_and_s3.arn
  image_uri = "${aws_ecr_repository.ecr_repo.repository_url}:latest"
  environment {
    variables = {
      ENV = var.env
    }
  }
}

resource "aws_cloudwatch_log_group" "lambda_function" {
  name = "/aws/lambda/${aws_lambda_function.lambda_function.function_name}"
  retention_in_days = 30
}

resource "aws_iam_role" "lambda_exec_ecr_and_s3" {
  name = "serverless_lambda"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Sid    = ""
      # This says that only lambda service can assume this role
      Principal = {
        Service = "lambda.amazonaws.com"
      }
      }
    ]
  })
}

# Attach basic execution policy
resource "aws_iam_role_policy_attachment" "policy_attachment_lambda_exec" {
  role       = aws_iam_role.lambda_exec_ecr_and_s3.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_policy" "lambda_ecr_policy" {
  name        = "lambda_ecr_policy"
  description = "Pull from ECR"

  policy = jsonencode({
    Version = "2012-10-17"
    # I wonder is it better to have a single policy with dynamo and lambda execute.
    Statement = [
      {
        "Effect": "Allow",
        "Action": "ecr:GetAuthorizationToken",
        "Resource": "*"
      },
      {
        Effect   = "Allow"
        Action = [
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage"
        ]
        Resource = aws_ecr_repository.ecr_repo.arn
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "policy_attachment_ecr" {
  role       = aws_iam_role.lambda_exec_ecr_and_s3.name
  policy_arn = aws_iam_policy.lambda_ecr_policy.arn
}

resource "aws_iam_policy" "lambda_s3_policy" {
  name        = "lambda_s3_policy"
  description = "S3 read and write"

  policy = jsonencode({
    Version = "2012-10-17"
    # I wonder is it better to have a single policy with dynamo and lambda execute.
    Statement = [
      {
        Effect   = "Allow"
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:DeleteObject"
        ]
        Resource = var.s3_bucket_details.arn
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "policy_attachment_s3" {
  role       = aws_iam_role.lambda_exec_ecr_and_s3.name
  policy_arn = aws_iam_policy.lambda_s3_policy.arn
}
