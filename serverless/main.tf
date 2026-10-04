terraform {
    required_providers{
        aws = {
            source = "hashicorp/aws"
            version = "~> 6.0"
        }
    }
}

provider "aws" {
    region = "us-east-1"
}

resource "aws_iam_role" "lambda_role" {
    name = "terraform-lambda-role"

    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Effect = "Allow"
                Principal = {
                    Service = "lambda.amazonaws.com"
                },
                Action = "sts:AssumeRole"

            }
        ]
    })
}

resource "aws_iam_role_policy_attachment" "lambda_basic"{
    role = aws_iam_role.lambda_role.name
    policy_arn ="arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_lambda_function" "hello" {
    function_name = "hello-terraform"

    filename = "code/lambda.zip"
    source_code_hash = filebase64sha256("code/lambda.zip")

    runtime = "python3.13"
    handler = "lambda_function.lambda_handler"
    role = aws_iam_role.lambda_role.arn
}