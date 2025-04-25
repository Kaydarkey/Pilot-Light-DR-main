# IAM Role that allows Lambda service to assume it
resource "aws_iam_role" "lambda_exec" {
  name = "lambda-rds-failover-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

# Attach AmazonRDSFullAccess policy to Lambda role (for managing RDS)
resource "aws_iam_role_policy_attachment" "rds_access" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonRDSFullAccess"
}

# Inline policy that allows Lambda to interact with Auto Scaling Groups
resource "aws_iam_role_policy" "asg_access" {
  name = "lambda-asg-policy"
  role = aws_iam_role.lambda_exec.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "autoscaling:UpdateAutoScalingGroup",
          "autoscaling:DescribeAutoScalingGroups"
        ],
        Resource = "*"
      }
    ]
  })
}

# Define the Lambda function using the role created above
resource "aws_lambda_function" "failover" {
  function_name    = "rds-failover-lambda"
  role             = aws_iam_role.lambda_exec.arn
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.9"
  filename         = var.lambda_file               
  source_code_hash = var.lambda_hash              
}

# Grant CloudWatch Logs access to Lambda so it can write logs
resource "aws_iam_role_policy_attachment" "cloudwatch_logs" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Allow SNS to invoke the Lambda function
resource "aws_lambda_permission" "allow_sns" {
  statement_id  = "AllowExecutionFromSNS"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.failover.function_name
  principal     = "sns.amazonaws.com"
  source_arn    = var.sns_topic_arn              
}

# Subscribe the Lambda function to the SNS topic
resource "aws_sns_topic_subscription" "lambda_sub" {
  topic_arn = var.sns_topic_arn
  protocol  = "lambda"
  endpoint  = aws_lambda_function.failover.arn    
}

resource "aws_iam_role_policy" "secretsmanager_access" {
  name = "lambda-secretsmanager-policy"
  role = aws_iam_role.lambda_exec.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "secretsmanager:CreateSecret",
          "secretsmanager:UpdateSecret",
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret",
          "secretsmanager:PutSecretValue",
          "secretsmanager:TagResource"
        ],
        Resource = "*"
      }
    ]
  })
}
