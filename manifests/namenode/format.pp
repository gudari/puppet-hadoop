class hadoop::namenode::format {

  if $hadoop::cluster_name and $hadoop::cluster_name != '' {
    $format_args = "-clusterid ${hadoop::cluster_name}"
  } else {
    $format_args = ''
  }

  exec { 'hdfs-format-cleanup':
    command => "rm -f ${hadoop::install_dir}/.puppet-hdfs-root-created",
    creates => "${hadoop::install_dir}/.puppet-hdfs-formatted",
    path    => '/bin:/usr/bin',
    user    => $hadoop::hdfs_user,
  } ->
  exec { 'hdfs-format':
    command => "${hadoop::install_dir}/bin/hdfs namenode -format -nonInteractive ${format_args} && touch ${hadoop::install_dir}/.puppet-hdfs-formatted",
    creates => "${hadoop::install_dir}/.puppet-hdfs-formatted",
    path    => '/bin:/usr/bin',
    user    => $hadoop::hdfs_user,
  }
}