class hadoop::namenode::bootstrap {
  exec { 'hdfs-bootstrap':
    command   => "${hadoop::install_dir}/bin/hdfs namenode -bootstrapStandby -nonInteractive && touch ${hadoop::install_dir}/.puppet-hdfs-bootstrapped",
    creates   => "${hadoop::install_dir}/.puppet-hdfs-bootstrapped",
    path      => '/bin:/usr/bin',
    user      => $hadoop::hdfs_user,
  }
}