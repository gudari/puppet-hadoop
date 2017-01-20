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

  $primary_namenode   = $::fqdn,
  $secondary_namenode = undef,
  $datanodes          = [ $::fqdn ],
  $excluded_datanodes = [],
  $journal_nodes      = undef,
  $zookeeper_nodes    = undef,
  $primary_resourcemanager = $::fqdn,
  $secondary_resourcemanager = undef,
  $nodemanager_nodes = [],
  $excluded_nodemanagers = [],

  $cluster_name = $::hadoop::params::cluster_name,

  $overwrite_core_site_conf = {},
  $overwrite_hdfs_site_conf = {},
  $overwrite_yarn_site_conf = {},
  $hdfs_namenode_dirs = $::hadoop::params::hdfs_namenode_dirs,
  $hdfs_datanode_dirs = $::hadoop::params::hdfs_datanode_dirs,
  $hdfs_journal_dirs  = $::hadoop::params::hdfs_journal_dirs,

) inherits hadoop::params {

  validate_legacy(Boolean, 'validate_bool', $install_java)
  validate_legacy(Boolean, 'validate_bool', $install_dependencies)

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
    gid    => $hadoop_id,
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
  }
  file { "/home/${hdfs_user}/.ssh/authorized_keys":
    ensure => file,
    owner  => $hdfs_user,
    group  => $hadoop_group,
    mode   => '0600',
    source => 'puppet:///modules/hadoop/sshkey/authorized_keys',
    require => File[ "/home/${hdfs_user}/.ssh" ],
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
  if $journal_nodes and member($journal_nodes, $::fqdn) {
    $daemon_journal = true
  } else {
    $daemon_journal = false
  }
  if $::fqdn == $primary_resourcemanager or $::fqdn == $secondary_resourcemanager {
    $daemon_resourcemanager = true
    $framework = 'yarn'
  } else {
    $daemon_resourcemanager = false
    $framework = undef
  }

  if $zookeeper_nodes {
    $zk = join([ join($zookeeper_nodes, ':2181,'), ':2181' ], '')
  }
  if $zookeeper_nodes and $secondary_namenode {
    $zoo_hdfs_site_conf = {
      'dfs.ha.automatic-failover.enabled' => true,
    }
    $zoo_core_site_conf = {
      'ha.zookeeper.quorum' => $zk,
    }
  } else {
    $zoo_hdfs_site_conf = undef
    $zoo_core_site_conf = undef
  }
  if $zookeeper_nodes and $secondary_resourcemanager {
    $zoo_yarn_site_conf = {
      'yarn.resourcemanager.ha.automatic-failover.enabled' => true,
      'yarn.resourcemanager.zk-address' => $zk,
    }
  } else {
    $zoo_yarn_site_conf = undef
  }
  if member($datanodes, $::fqdn) or member($excluded_datanodes, $::fqdn) {
    $daemon_datanode = true
  } else {
    $daemon_datanode = false
  }
  if member($nodemanager_nodes, $::fqdn) or member($excluded_nodemanagers, $::fqdn) {
    $daemon_nodemanager = true
  } else {
    $daemon_nodemanager = false
  }
  if $secondary_namenode {
    if $daemon_namenode and $zookeeper_nodes {
      $daemon_zkfc = true
    } else {
      $daemon_zkfc = false
    }
  } else {
    $daemon_zkfc = false
  }

  $default_core_site_conf = {
    'fs.defaultFS'                              => "hdfs://${primary_namenode}:8020",
    'io.file.buffer.size'                       => '131072',
  }
  $default_hdfs_site_conf = {
    'dfs.datanode.hdfs-blocks-metadata.enabled' => true,
    'dfs.hosts'                                 => "${hadoop::config_dir}/slaves",
    'dfs.hosts.exclude'                         => "${hadoop::config_dir}/exclude",
    'dfs.blocksize'                             => '268435456',
    'dfs.namenode.handler.count'                => '100',
  }
  if $journal_nodes {
    $jn = join([ join($journal_nodes, ':8485;'), ':8485' ], '')
    $default_ha_core_site_conf = {
      'fs.defaultFS' => "hdfs://${cluster_name}",
    }
    $default_ha_hdfs_site_conf = {
      'dfs.nameservices' => $hadoop::cluster_name,
      "dfs.ha.namenodes.${cluster_name}"                   => 'nn1,nn2',
      "dfs.namenode.rpc-address.${cluster_name}.nn1"       => "${primary_namenode}:8020",
      "dfs.namenode.rpc-address.${cluster_name}.nn2"       => "${secondary_namenode}:8020",
      "dfs.namenode.http-address.${cluster_name}.nn1"      => "${primary_namenode}:50070",
      "dfs.namenode.http-address.${cluster_name}.nn2"      => "${secondary_namenode}:50070",
      'dfs.namenode.shared.edits.dir'                      => "qjournal://${jn}/${cluster_name}",
      "dfs.client.failover.proxy.provider.${cluster_name}" => 'org.apache.hadoop.hdfs.server.namenode.ha.ConfiguredFailoverProxyProvider',
      'dfs.ha.fencing.methods'                             => 'shell(/bin/true)',
    }
  } else {
      $default_ha_core_site_conf = {}
      $default_ha_hdfs_site_conf = {}
  }
  if $primary_resourcemanager {
    $default_yarn_site_conf = {
      'yarn.resourcemanager.hostname' => $primary_resourcemanager,
      'yarn.resourcemanager.nodes.include-path' => "${hadoop::config_dir}/slaves-yarn",
      'yarn.resourcemanager.nodes.exclude-path' => "${hadoop::config_dir}/exclude-yarn",
      'yarn.nodemanager.aux-services' => 'mapreduce_shuffle',
      'yarn.nodemanager.log-dirs' => '/var/log/hadoop',
    }
  } else {
    $default_yarn_site_conf = {}
  }
  if $secondary_resourcemanager {
    $default_ha_yarn_site_conf = {
      'yarn.resourcemanager.cluster-id'   => $hadoop::cluster_name,
      'yarn.resourcemanager.ha.enabled'   => true,
      'yarn.resourcemanager.ha.rm-ids'    => 'rm1,rm2',
      'yarn.resourcemanager.hostname.rm1' => $primary_resourcemanager,
      'yarn.resourcemanager.hostname.rm2' => $secondary_resourcemanager,
    }
    if $zookeeper_nodes {
      $default_ha_yarn_site_conf
    }
  } else {
      $default_ha_yarn_site_conf = {}
  }

  $core_site_conf = merge( $default_core_site_conf, $default_ha_core_site_conf, $zoo_core_site_conf, $overwrite_core_site_conf)
  $hdfs_site_conf = merge( $default_hdfs_site_conf, $default_ha_hdfs_site_conf, $zoo_hdfs_site_conf, $overwrite_hdfs_site_conf)
  $yarn_site_conf = merge( $default_yarn_site_conf, $default_ha_yarn_site_conf, $zoo_yarn_site_conf, $overwrite_yarn_site_conf)


  anchor{ '::hadoop::start': } ->
  class { '::hadoop::install': } ->
  class { '::hadoop::config': } ~>
  class { '::hadoop::service': } ->
  anchor{ '::hadoop::end': }

}
