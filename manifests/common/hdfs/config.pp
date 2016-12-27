class hadoop::common::hdfs::config {

  include ::hadoop::common::slaves

  file { "${hadoop::config_dir}/hdfs-site.xml":
    ensure  => present,
    mode    => '0644',
    owner   => $hadoop::hdfs_user,
    group   => $hadoop::hadoop_group,
    content => template('hadoop/config/hdfs-site.xml.erb'),
    require => File[ $hadoop::config_dir, "${hadoop::config_dir}/slaves", "${hadoop::config_dir}/exclude" ]
  }
}