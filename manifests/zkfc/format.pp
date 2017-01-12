class hadoop::zkfc::format {

  if $hadoop::primary_namenode == $::fqdn {
    exec { 'zkfc-format':
      command => "${hadoop::install_dir}/bin/hdfs zkfc -formatZK && touch ${hadoop::install_dir}/.puppet-zk-formatted",
      creates => "${hadoop::install_dir}/.puppet-zk-formatted",
      path    => '/bin:/usr/bin',
      user    => $hadoop::hdfs_user,
    }
  }

}