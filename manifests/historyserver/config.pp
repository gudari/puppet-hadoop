class hadoop::historyserver::config {
  contain hadoop::common::config
  contain hadoop::common::hdfs::config
  contain hadoop::common::mapred::config
  contain hadoop::common::yarn::config
}