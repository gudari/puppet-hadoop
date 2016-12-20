class hadoop::datanode (
  $service_datanode = $hadoop::service_datanode,
  $hdfs_user        = $hadoop::hdfs_user,
  $hdfs_id          = $hadoop::hdfs_id,
  $hadoop_group     = $hadoop::hadoop_group,
)
{
  user { $hdfs_user:
    ensure     => present,
    shell      => '/bin/bash',
    home       => "/home/${hdfs_user}",
    managehome => true,
    require    => Group[ $hadoop_group ],
    uid        => $hdfs_id,
  }

  class { '::hadoop::namenode::config':
    service_user => $hdfs_user,
  } ->
  class { '::hadoop::namenode::format':
    service_user => $hdfs_user,
  } ->
  hadoop::service { $service_namenode:
    service_user  => $hdfs_user
    service_group => $hadoop_group
    require       => User[ $hdfs_user ]
  }

}
