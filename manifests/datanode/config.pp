class hadoop::datanode::config {
  contain hadoop::common::config
  contain hadoop::common::hdfs::config

  ensure_resource('file', $hadoop::hdfs_datanode_dirs, {
    ensure => directory,
    owner  => $hadoop::hdfs_user,
    group  => $hadoop::hadoop_group,
    mode   => '1755',
  })
}