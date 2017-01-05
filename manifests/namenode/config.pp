class hadoop::namenode::config {
  contain hadoop::common::config
  contain hadoop::common::hdfs::config

  ensure_resource('file', $hadoop::hdfs_namenode_dirs, {
    ensure => directory,
    owner  => $hadoop::hdfs_user,
    group  => $hadoop::hadoop_group,
    mode   => '1755',
  })
  if $hadoop::primary_namenode == $::fqdn {
    contain hadoop::namenode::format

   File[ $hadoop::hdfs_namenode_dirs ] -> Class[ 'hadoop::namenode::format' ]
    Class[ 'hadoop::common::config' ] -> Class[ 'hadoop::namenode::format' ]
    Class[ 'hadoop::common::hdfs::config' ] -> Class[ 'hadoop::namenode::format' ]
  }
  if $hadoop::secondary_namenode == $::fqdn {
    contain hadoop::namenode::bootstrap

    File[$hadoop::hdfs_namenode_dirs] -> Class['hadoop::namenode::bootstrap']
    Class['hadoop::common::config'] -> Class['hadoop::namenode::bootstrap']
    Class['hadoop::common::hdfs::config'] -> Class['hadoop::namenode::bootstrap']
  }
}