class hadoop::common::yarn::config {

  include ::hadoop::common::slaves

  file { "${hadoop::config_dir}/yarn-site.xml":
    ensure  => present,
    mode    => '0644',
    owner   => $hadoop::hdfs_user,
    group   => $hadoop::hadoop_group,
    content => template('hadoop/config/yarn-site.xml.erb'),
    require => File[ $hadoop::config_dir ],
  }

  if $::hadoop::install_tez {
    file { "${hadoop::config_dir}/tez-site.xml":
      ensure  => present,
      mode    => '0644',
      owner   => $hadoop::hdfs_user,
      group   => $hadoop::hadoop_group,
      content => template('hadoop/config/tez-site.xml.erb'),
      require => File[ $hadoop::config_dir ],
    }
  }
}