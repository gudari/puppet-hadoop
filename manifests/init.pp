class hadoop (
  $version                 = $hadoop::params::version,
  $install_dir             = $hadoop::params::install_dir,
  $config_dir              = "${install_dir}/etc/hadoop",
  $mirror_url              = $hadoop::params::mirror_url,
  $download_dir            = $hadoop::params::download_dir,
  $log_dir                 = $hadoop::params::log_dir,
  $pid_dir                 = $hadoop::params::pid_dir,

  $package_name            = $hadoop::params::package_name,
  $package_ensure          = $hadoop::params::package_ensure,

  $install_java            = $hadoop::params::install_java,
  $java_version            = $hadoop::params::java_version,
  $install_dependencies    = $hadoop::params::install_dependencies,
  $packages_dependencies   = $hadoop::params::packages_dependencies,

  $package_dir             = $hadoop::params::package_dir,
  $group_id                = $hadoop::params::group_id,
  $user_id                 = $hadoop::params::user_id,
  $hadoop_etc_dir          = $hadoop::params::hadoop_etc_dir,

  $service_name            = $hadoop::params::service_name,

  $hdfs_user               = $hadoop::params::hdfs_user,
  $hdfs_id                 = $hadoop::params::hdfs_id,
  $hadoop_group            = $hadoop::params::hadoop_group,
  $hadoop_id               = $hadoop::params::hadoop_id,

  $service_namenode        = $hadoop::params::service_namenode,
  $service_datanode        = $hadoop::params::service_datanode,
  $service_resourcemanager = $hadoop::params::service_resourcemanager,
  $service_nodemanager     = $hadoop::params::service_nodemanager,
  $service_historyserver   = $hadoop::params::service_historyserver,
  $service_journalnode     = $hadoop::params::service_journalnode,
  $service_zkfc            = $hadoop::params::service_zkfc,

  $primary_namenode = $::fqdn,
  $secondary_namenode = undef,
  $slaves = [ $::fqdn ],

  $datanodes = [ $::fqdn ],
  $journalnode_hostnames = undef,

  $cluster_name = $::hadoop::params::cluster_name,

  $overwrite_core_site_conf = {},
  $hdfs_namenode_dirs = $::hadoop::params::hdfs_namenode_dirs,
  $hdfs_datanode_dirs = $::hadoop::params::hdfs_datanode_dirs,

) inherits hadoop::params {

  validate_bool($install_java)
  validate_bool($install_dependencies)

  $basefilename = "hadoop-${version}.tar.gz"
  $package_url  = "${mirror_url}/hadoop-${version}/${basefilename}"
  $extract_dir  = "/opt/hadoop-${version}"

  if $install_java {
    java::oracle { 'jdk8':
      ensure  => 'present',
      version => $java_version,
      java_se => 'jdk',
      before  => Archive[ "${download_dir}/${basefilename}" ]
    }
  }

  if $install_dependencies {
    package { $packages_dependencies:
      ensure => present,
      before => Archive[ "${download_dir}/${basefilename}" ],
    }
  }

  group { $hadoop_group:
    ensure => present,
    gid    => $group_id,
  }

  user { $hdfs_user:
    ensure     => present,
    shell      => '/bin/bash',
    home       => "/home/${hdfs_user}",
    managehome => true,
    require    => Group[ $hadoop_group ],
    uid        => $hdfs_id,
  }

  file { "/home/${hdfs_user}/.ssh":
    ensure => directory,
    owner  => $hdfs_user,
    group  => $hadoop_group,
    mode   => '0700',
    require => User[ $hdfs_user ],
  }
  file { "/home/${hdfs_user}/.ssh/id_dsa":
    ensure  => file,
    owner   => $hdfs_user,
    group   => $hadoop_group,
    mode    => '0400',
    source  => 'puppet:///modules/hadoop/sshkey/id_dsa',
    require => File[ "/home/${hdfs_user}/.ssh" ],
#    before  => Service[ $hdfs_user ],
  }
  file { "/home/${hdfs_user}/.ssh/authorized_keys":
    ensure => file,
    owner  => $hdfs_user,
    group  => $hadoop_group,
    mode   => '0600',
    source => 'puppet:///modules/hadoop/sshkey/authorized_keys',
    require => File[ "/home/${hdfs_user}/.ssh" ],
#    before  => Service[ $hdfs_user ],
  }
  file { "/home/${hdfs_user}/.ssh/known_hosts":
    ensure => file,
    owner  => $hdfs_user,
    group  => $hadoop_group,
    mode   => '0644',
    source => 'puppet:///modules/hadoop/sshkey/known_hosts',
    require => File[ "/home/${hdfs_user}/.ssh" ],
  }

  if $::fqdn == $primary_namenode or $::fqdn == $secondary_namenode {
    $daemon_namenode = true
    $mapred_user = true
  } else {
    $daemon_namenode = false
    $mapred_user = false
  }
  if member($datanodes, $::fqdn) {
    $daemon_datanode = true
  } else {
    $daemon_datanode = false
  }

  $default_core_site_conf = {
    'fs.defaultFS'        => "hdfs://${primary_namenode}:8020",
    'io.file.buffer.size' => '131072',
  }

  $core_site_conf = merge( $default_core_site_conf, $overwrite_core_site_conf)


  anchor{ '::hadoop::start': } ->
  class { '::hadoop::install': } ->
  class { '::hadoop::config': } ~>
  class { '::hadoop::service': } ->
  anchor{ '::hadoop::end': }

}
