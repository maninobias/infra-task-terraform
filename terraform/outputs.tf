output "api_gateway_url" {
  value = module.lambda_api.api_gateway_url
}

output "lambda_arn" {
  value = module.lambda_api.lambda_arn
}