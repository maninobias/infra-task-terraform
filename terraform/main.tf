provider "aws" {
  region = var.region
}

module "lambda_api" {
  source               = "./modules/lambda-api"
  vpc_id               = var.vpc_id
  subnet_ids           = var.subnet_ids
  lambda_function_name = var.lambda_function_name
  lambda_handler       = var.lambda_handler
  lambda_runtime       = var.lambda_runtime
}

resource "aws_cloudwatch_event_rule" "schedule" {
  name                = "daily_scheduled_event"
  schedule_expression = var.cron_expression
}

resource "aws_lambda_function" "scheduled_lambda" {
  function_name = "scheduled_lambda"
  handler       = "scheduled_handler.handler"
  runtime       = "python3.10"
  role          = aws_iam_role.lambda_exec_role.arn
  filename      = data.archive_file.scheduled_lambda_package.output_path
  vpc_config {
    subnet_ids         = var.subnet_ids
    security_group_ids = [aws_security_group.lambda_sg.id]
  }
}

resource "aws_lambda_permission" "allow_cloudwatch" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.scheduled_lambda.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.schedule.arn
}

resource "aws_cloudwatch_event_target" "lambda_target" {
  rule = aws_cloudwatch_event_rule.schedule.name
  target_id = "lambda_target"
  arn = aws_lambda_function.scheduled_lambda.arn
}

data "archive_file" "scheduled_lambda_package" {
  type        = "zip"
  source_file = "${path.module}/lambda/scheduled_handler.py"
  output_path = "${path.module}/lambda/scheduled_handler.zip"
}

resource "aws_cloudwatch_log_group" "scheduled_lambda_log_group" {
  name              = "/aws/lambda/scheduled_lambda"
  retention_in_days = 14
}
