output "catalog_etcd_operator_bucket_id" {
  value = "${aws_s3_bucket.catalog_etcd_operator.id}"
}

output "nfs_filesystem_id" {
  value = "${aws_efs_file_system.nfs.id}"
}
