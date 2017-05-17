class hadoop::common::yarn::config {

  include ::hadoop::common::slaves

  file { "${hadoop::config_dir}/yarn-site.xml":
    ensure  => file,
    mode    => '0644',
    owner   => $hadoop::hdfs_user,
    group   => $hadoop::hadoop_group,
    content => template('hadoop/config/yarn-site.xml.erb'),
    require => File[ $hadoop::config_dir ],
  }

  file { "${hadoop::config_dir}/capacity-scheduler.xml":
    ensure  => file,
    mode    => '0644',
    owner   => $hadoop::hdfs_user,
    group   => $hadoop::hadoop_group,
    content => template('hadoop/config/capacity-scheduler.xml.erb'),
    require => File[ $hadoop::config_dir ],
  }

}
