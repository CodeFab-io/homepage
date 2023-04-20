# S3 bucket for website.
resource "aws_s3_bucket" "www_bucket" {
  bucket = "${var.git_repository}-${var.domain_name}"
  tags   = var.common_tags
}

resource "aws_s3_bucket_website_configuration" "www_bucket" {
  bucket = aws_s3_bucket.www_bucket.bucket

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "index.html"
  }
}

resource "aws_s3_bucket_cors_configuration" "www_bucket" {
  bucket = aws_s3_bucket.www_bucket.id

  cors_rule {
    allowed_headers = ["Authorization", "Content-Length"]
    allowed_methods = ["GET", "HEAD"]
    allowed_origins = ["*"]
  }
}

resource "aws_s3_bucket_acl" "www_bucket" {
  bucket = aws_s3_bucket.www_bucket.id
  acl    = "private"
}

# Upload the dist folder into the S3 bucket for website.
module "template_files" {
  source = "hashicorp/dir/template"
  base_dir = "../dist"
}

resource "aws_s3_object" "static_files" {
  for_each = module.template_files.files

  bucket       = aws_s3_bucket.www_bucket.bucket
  acl          = "public-read"
  key          = each.key
  content_type = each.value.content_type

  source = each.value.source_path
  etag   = each.value.digests.md5
}
