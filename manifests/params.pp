class hadoop::params {
#installation related definitions
  $version        = '2.7.3'
  $install_dir    = "/opt/hadoop-${version}"
  $mirror_url     = 'http://apache.rediris.es/hadoop/common'
  $package_name   = undef
  $package_ensure = 'present'
  $install_dependencies  = true
  $packages_dependencies = [ 'openssh', 'rsync' ]

# system user and group definitions
  $group_id     = undef
  $user_id      = undef
  $hdfs_user    = 'hdfs'
  $hdfs_id      = undef
  $mapred_user  = 'mapred'
  $mapred_id    = undef
  $yarn_user    = 'yarn'
  $yanr_id      = undef
  $hadoop_group = 'hadoop'
  $hadoop_id    = undef

  $install_java   = true
#configuration related definitions
  $package_dir    = '/var/tmp/hadoop'
  $hadoop_etc_dir = 'etc/hadoop'

# systemd service definitions
  $service_install = true
  $service_ensure = 'running'
  $service_name    = 'hadoop'
  $service_restart = true
  $service_namenode = 'hadoop-namenode'
  $service_datanode = 'hadoop-datanode'
  $service_resourcemanager = 'hadoop-resourcemanager'
  $service_nodemanager = 'hadoop-nodemanager'
  $service_historyserver = 'hadoop-historyserver'
  $service_journalnode = 'hadoop-journalnode'
  $service_hdfs_zkfc = 'hadoop-zkfc'

  $config_defaults = {}
  $jmx_opts = ''
  $heap_opts = '-Xmx1G -Xms1G'
  $log4j_opts = ''
  $opts = ''

}
