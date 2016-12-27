class hadoop::common::slaves {
  file { "${hadoop::config_dir}/slaves":
    owner   => $hadoop::hdfs_user,
    group   => $hadoop::hadoop_group,
    mode    => '0644',
    content => template('hadoop/config/slaves.erb'),
  }

  file { "${hadoop::config_dir}/exclude":
    owner   => $hadoop::hdfs_user,
    group   => $hadoop::hadoop_group,
    mode    => '0644',
    content => template('hadoop/config/exclude.erb'),
  }
}