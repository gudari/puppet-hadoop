class hadoop::nodemanager::config {
  contain hadoop::common::config
  contain hadoop::common::hdfs::config
  contain hadoop::common::yarn::config
}
