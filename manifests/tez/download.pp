class hadoop::tez::download {

  archive { '/opt/apache-tez-0.8.4-bin.tar.gz':
    ensure        => present,
    extract       => true,
    extract_path  => '/opt/tez-0.8.4',
    source        => 'http://apache.rediris.es/tez/0.8.4/apache-tez-0.8.4-bin.tar.gz',
    creates       => '/opt/tez-0.8.4/apache-tez-0.8.4-bin/conf',
    cleanup       => true,
    before        => File[ '/opt/tez' ],
    user          => $hadoop::hdfs_user,
    group         => $hadoop::hadoop_group,
    require       => [
      File['/opt/tez-0.8.4'],
      Group[$hadoop::hadoop_group],
      User[$hadoop::hdfs_user],
    ],
  }

  file { '/opt/tez':
    ensure  => link,
    target  => '/opt/tez-0.8.4',
    require => [
      File[ '/opt/tez-0.8.4' ],
      Group[$hadoop::hadoop_group],
      User[$hadoop::hdfs_user],
    ],
  }

  file { '/opt/tez-0.8.4':
    ensure  => directory,
    owner   => $hadoop::hdfs_user,
    group   => $hadoop::hadoop_group,
    require => [
      Group[$hadoop::hadoop_group],
      User[$hadoop::hdfs_user],
    ],
  }

}