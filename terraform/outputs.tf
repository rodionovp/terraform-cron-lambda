output "js_cron_job" {
  value = "https://console.aws.amazon.com/lambda/home?region=us-east-1#/functions/${aws_lambda_function.js_cron.function_name}"
}

output "js_cron_job_logs" {
  value = "https://console.aws.amazon.com/cloudwatch/home?region=us-east-1#logStream:group=%252Faws%252Flambda%252F${aws_lambda_function.js_cron.function_name}"
}

