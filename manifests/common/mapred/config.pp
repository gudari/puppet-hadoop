class hadoop::common::mapred::config {

  file { "${hadoop::config_dir}/mapred-site.xml":
    ensure  => present,
    mode    => '0644',
    owner   => $hadoop::hdfs_user,
    group   => $hadoop::hadoop_group,
    content => template('hadoop/config/mapred-site.xml.erb'),
    require => File[ $hadoop::config_dir ],
  }
}