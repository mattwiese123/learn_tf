data "archive_file" "lambda-archive" {
    type = "zip"
    source_file = "lambda/src/main.py"
    output_path = "lambda/packages/lambda_function.zip"
}

resource "aws_lambda_function" "pipeline" {
    filename = "lambdapipeline.zip"
    function_name = "mzw_pipeline_test"
    role = "${aws_iam_role.iam_for_lambda.arn}$
    handler = "exports.handler"
    runtime = "python3.9"
    layers = ["arn:aws:lambda:us-east-2:336392948345:layer:AWSDataWrangler-Python39:6"]
    depends_on = ["${aws_iam_role_policy_attachment.lambda_basic_execution_policy_attachement}"]
    
}

# https://stackoverflow.com/questions/61927400/how-to-use-an-aws-provided-lambda-layer-in-terraform
# https://aws-data-wrangler.readthedocs.io/en/stable/layers.html