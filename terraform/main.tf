provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}


resource "aws_iam_policy_attachment" "test-attach" {
  name = "test-attachment"
  roles = ["${aws_iam_role.iam_for_lambda.name}"]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}


resource "aws_lambda_function" "js_cron" {
  filename = "../js/build/aws-lambda.zip"
  function_name = "js_cron"
  role = "${aws_iam_role.iam_for_lambda.arn}"
  handler = "index.handler"
  source_code_hash = "${base64sha256(file("../js/build/aws-lambda.zip"))}"
}

resource "aws_cloudwatch_event_rule" "every_minute" {
  name = "every-minute"
  description = "Fires every minute"
  schedule_expression = "rate(1 minute)"
}

resource "aws_cloudwatch_event_target" "js_cron_every_five_minutes" {
  rule = "${aws_cloudwatch_event_rule.every_minute.name}"
  target_id = "js_cron"
  arn = "${aws_lambda_function.js_cron.arn}"
}

resource "aws_lambda_permission" "allow_cloudwatch_to_call_js_cron" {
  statement_id = "AllowExecutionFromCloudWatch"
  action = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.js_cron.function_name}"
  principal = "events.amazonaws.com"
  source_arn = "${aws_cloudwatch_event_rule.every_minute.arn}"
}
