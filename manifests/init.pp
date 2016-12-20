class hadoop (
  $version               = $hadoop::params::version,
  $install_dir           = $hadoop::params::install_dir,
  $mirror_url            = $hadoop::params::mirror_url,
  $install_java          = $hadoop::params::install_java,
  $java_home_dir         = '',
  $package_dir           = $hadoop::params::package_dir,
  $package_name          = $hadoop::params::package_name,
  $package_ensure        = $hadoop::params::package_ensure,
  $group_id              = $hadoop::params::group_id,
  $user_id               = $hadoop::params::user_id,
  $hadoop_etc_dir        = $hadoop::params::hadoop_etc_dir,
  $install_dependencies  = $hadoop::params::install_dependencies,
  $packages_dependencies = $hadoop::params::packages_dependencies,
  $service_name          = $hadoop::params::service_name,
  $config_dir            = $hadoop::params::config_dir,

  $hdfs_user    = $hadoop::params::hdfs_user,
  $hdfs_id      = $hadoop::params::hdfs_id,
  $mapred_user  = $hadoop::params::mapred_user,
  $mapred_id    = $hadoop::params::mapred_id,
  $yarn_user    = $hadoop::params::yarn_user,
  $yarn_id      = $hadoop::params::yarn_id,
  $hadoop_group = $hadoop::params::hadoop_group,
  $hadoop_id    = $hadoop::params::hadoop_id,

  $service_namenode = $hadoop::params::service_namenode,
  $service_datanode = $hadoop::params::service_datanode,
  $service_resourcemanager = $hadoop::params::service_resourcemanager,
  $service_nodemanager = $hadoop::params::service_nodemanager,
  $service_historyserver = $hadoop::params::service_historyserver,
  $service_journalnode = $hadoop::params::service_journalnode,
  $service_hdfs_zkfc = $hadoop::params::service_zkfc,

) inherits hadoop::params {

  validate_bool($install_java)
  validate_absolute_path($package_dir)

  $basefilename = "hadoop-${version}.tar.gz"
  $package_url = "${mirror_url}/hadoop-${version}/${basefilename}"

  $install_directory = $install_dir ? {
    $hadoop::params::install_dir => "/opt/hadoop-${version}",
    default                     => $install_dir,
  }

  if $install_java {
    java::oracle { 'jdk8':
      ensure  => 'present',
      version => '8',
      java_se => 'jdk',
      before  => Archive[ "${package_dir}/${basefilename}" ]
    }
  }

  if $install_dependencies {
    package { $packages_dependencies:
      ensure => present,
      before => Archive[ "${package_dir}/${basefilename}" ],
    }
  }

  group { $hadoop_group:
    ensure => present,
    gid    => $group_id,
  }

#  user { $hdfs_user:
#    ensure  => present,
#    home       => "/home/${hdfs_user}",
#    managehome => true,
#    shell   => '/bin/bash',
#    require => Group[ $hadoop_group],
#    uid     => $hdfs_id,
#  }

  user { $mapred_user:
    ensure  => present,
    home       => "/home/${mapred_user}",
    managehome => true,
    shell   => '/bin/bash',
    require => Group[ $hadoop_group],
    uid     => $hdfs_id,
  }

  user { $yarn_user:
    ensure  => present,
    home       => "/home/${yarn_user}",
    managehome => true,
    shell   => '/bin/bash',
    require => Group[ $hadoop_group ],
    uid     => $hdfs_id,
  }



  class { '::hadoop::namenode': }
  #class { 'hadoop::config': }
  #class { 'hadoop::service': }

}
