class hadoop::resourcemanager::config {
  contain hadoop::common::config
  contain hadoop::common::hdfs::config
  contain hadoop::common::yarn::config
}