class hadoop::format (
  $install_directory = $hadoop::install_directory,
  $package_dir       = $hadoop::package_dir,
  $basefilename      = $hadoop::basefilename,
){

  exec { 'hdfs-format-cleanup':
    command => 'rm -f /opt/hadoop/.puppet-hdfs-root-created',
    creates => "/opt/hadoop/.puppet-hdfs-formatted",
    path    => '/bin:/usr/bin',
    user    => 'root',
    require => Archive[ "${package_dir}/${basefilename}" ],
  }
  ->
  exec { 'hdfs-format':
    command => "/opt/hadoop/bin/hdfs namenode -format && touch ${install_directory}/.puppet-hdfs-formatted",
    creates => "/opt/hadoop/.puppet-hdfs-formatted",
    path    => '/bin:/usr/bin',
    user    => 'root',
    require => Archive[ "${package_dir}/${basefilename}" ],
  }
}