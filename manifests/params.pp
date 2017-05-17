class hadoop::params {
#installation related definitions
  $version               = '2.7.3'
  $install_dir           = '/opt/hadoop'
  $mirror_url            = 'http://apache.rediris.es/hadoop/common'
  $download_dir          = '/var/tmp/hadoop'
  $log_dir               = '/var/log/hadoop'
  $pid_dir               = '/var/run/hadoop'

  $package_name          = undef
  $package_ensure        = 'present'

  $install_dependencies  = true
  $packages_dependencies = [ 'openssh', 'rsync' ]

# system user and group definitions
  $hdfs_user    = 'hdfs'
  $hdfs_id      = undef
  $mapred_user  = 'mapred'
  $mapred_id    = undef
  $yarn_user    = 'yarn'
  $yanr_id      = undef
  $hadoop_group = 'hadoop'
  $hadoop_id    = undef

#configuration related definitions
  $cluster_name              = 'hadoop'
  $hdfs_dir                  = '/var/lib/hadoop-hdfs'
  $hdfs_namenode_dirs        = [ $hdfs_dir ]
  $hdfs_datanode_dirs        = [ $hdfs_dir ]
  $hdfs_journal_dirs         = [ $hdfs_dir ]
  $hdfs_namenode_suffix      = '/dfs/name'
  $hdfs_namesecondary_suffix = '/dfs/namesecondary'
  $hdfs_datanode_suffix      = '/dfs/data'
  $hdfs_journalnode_suffix   = '/dfs/journal'

# service definitions
  $service_install = true
  $service_ensure = 'running'
  $service_restart = true
  $service_namenode        = 'hadoop-hdfs-namenode'
  $service_datanode        = 'hadoop-hdfs-datanode'
  $service_resourcemanager = 'hadoop-yarn-resourcemanager'
  $service_nodemanager     = 'hadoop-yarn-nodemanager'
  $service_journalnode     = 'hadoop-hdfs-journalnode'
  $service_zkfc            = 'hadoop-hdfs-zkfc'
  $service_historyserver   = 'hadoop-mapreduce-historyserver'
  $service_timelineserver  = 'hadoop-yarn-timelineserver'
  $service_nfs             = 'hadoop-hdfs-nfs3'
  $service_httpfs          = 'haddop-httpfs'

}
