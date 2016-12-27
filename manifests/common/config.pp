class hadoop::common::config {

  file { "${hadoop::config_dir}/core-site.xml":
    ensure  => present,
    mode    => '0644',
    owner   => $hadoop::hdfs_user,
    group   => $hadoop::hadoop_group,
    content => template('hadoop/config/core-site.xml.erb'),
    require => File[ $hadoop::config_dir ],
  }

  file { "${hadoop::config_dir}/hadoop-env.sh":
    ensure  => present,
    owner   => $hadoop::hdfs_user,
    group   => $hadoop::hadoop_group,
    content => template('hadoop/config/hadoop-env.sh.erb'),
    require => File[ $hadoop::config_dir ],
  }

}