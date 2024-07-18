variable "region" {
  description = "The AWS region to deploy the resources"
  type        = string
  default     = "ap-south-1"
}

variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "subnet_ids" {
  description = "A list of subnet IDs associated with the VPC"
  type        = list(string)
}

variable "lambda_function_name" {
  description = "The name of the Lambda function"
  type        = string
}

variable "lambda_handler" {
  description = "The handler for the Lambda function"
  type        = string
}

variable "lambda_runtime" {
  description = "The runtime for the Lambda function"
  type        = string
}

variable "cron_expression" {
  description = "The cron expression for the scheduled Lambda function"
  type        = string
  default     = "cron(30 3 * * ? *)"  
}