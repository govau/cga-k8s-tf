# S3 bucket used by the service catalog's etcd-operator 
# for backups

resource "aws_s3_bucket" "catalog_etcd_operator" {
  bucket_prefix = "${var.name}cld-catalog-etcd-operator-backups"
  acl           = "private"
  region        = "ap-southeast-2"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = {
    k8s-namespace = "catalog"
    owner         = "etcd-operator"
  }
}

resource "aws_route53_record" "catalog_txt" {
  zone_id = "${var.cld_internal_zone_id}"
  name    = "catalog.k8s.cld.internal."
  type    = "TXT"
  ttl     = 300

  records = [
    "etcd-backup-bucket=${aws_s3_bucket.catalog_etcd_operator.id}",
  ]
}

resource "aws_iam_user" "catalog_etcd_operator" {
  name          = "catalog-etcd-operator"
  force_destroy = true
}

data "aws_iam_policy_document" "catalog_etcd_operator" {
  statement {
    actions   = ["s3:ListBucket"]
    effect    = "Allow"
    resources = ["${aws_s3_bucket.catalog_etcd_operator.arn}"]
  }

  statement {
    actions   = ["s3:*"]
    effect    = "Allow"
    resources = ["${aws_s3_bucket.catalog_etcd_operator.arn}/*"]
  }
}

resource "aws_iam_user_policy" "catalog_etcd_operator_access_bucket" {
  name   = "catalog_etcd_operator_s3_access"
  user   = "${aws_iam_user.catalog_etcd_operator.name}"
  policy = "${data.aws_iam_policy_document.catalog_etcd_operator.json}"
}
