resource "aws_efs_file_system" "nfs" {
  encrypted = "true"

  lifecycle {
    prevent_destroy = true
  }

  tags = {
    EnvName = "${var.name}"
    Purpose = "eks"
  }
}

resource "aws_route53_record" "nfs_txt" {
  zone_id = "${var.cld_internal_zone_id}"
  name    = "nfs.k8s.cld.internal."
  type    = "TXT"
  ttl     = 300

  records = [
    "dns-name=${aws_efs_file_system.nfs.dns_name}",
    "filesystem-id=${aws_efs_file_system.nfs.id}",
  ]
}
