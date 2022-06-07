resource "aws_s3_bucket" "source" {
    bucket = "mzw_pipeline_test_a_source_bucket"
    acl = "private"

}

resource "aws_s3_bucket" "target" {
    bucket = "mzw_pipeline_test_a_target_bucket"
    acl = "private"

}