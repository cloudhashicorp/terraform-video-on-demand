resource "aws_s3_bucket" "vods3" {

  bucket = var.bucket_name
  acl    = var.acl

  versioning {
    enabled = var.version_enabled
  }

  lifecycle_rule {

    id      = var.id
    prefix  = var.prefix
    enabled = var.lifecyclerule

    noncurrent_version_transition {
      days          = var.siadays
      storage_class = var.sia
    }

    noncurrent_version_transition {
      days          = var.gladays
      storage_class = var.gla
    }

    noncurrent_version_expiration {
      days = var.noncurrentdays
    }




  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.vodkmskey.arn
        sse_algorithm     = "aws:kms"

      }
    }
  }

}

#KMS Key Default SSE
resource "aws_kms_key" "vodkmskey" {

  description             = "KMS Key for encrypting buckets"
  deletion_window_in_days = var.days
}