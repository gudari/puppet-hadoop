class hadoop::config (
  $install_directory = $hadoop::install_directory,
  $package_dir       = $hadoop::package_dir,
  $basefilename      = $hadoop::basefilename,
  $service_name      = $hadoop::service_name,
  $hadoop_etc_dir    = $hadoop::hadoop_etc_dir,
)
{

  file { '/root/.ssh':
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0700',
  }
  file { '/root/.ssh/id_dsa':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0400',
    source  => 'puppet:///modules/hadoop/sshkey/id_dsa',
    require => File[ '/root/.ssh' ],
  }
  file { '/root/.ssh/authorized_keys':
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0600',
    source => 'puppet:///modules/hadoop/sshkey/authorized_keys',
    require => File[ '/root/.ssh' ],
  }
  file { '/root/.ssh/known_hosts':
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    source => 'puppet:///modules/hadoop/sshkey/known_hosts',
    require => File[ '/root/.ssh' ],
  }

  file { "${install_directory}/etc/hadoop/core-site.xml":
    ensure  => present,
    mode    => '0644',
    owner   => 'hdfs',
    group   => 'hadoop',
    content => template('hadoop/config/core-site.xml.erb'),
    require => Archive[ "${package_dir}/${basefilename}" ],
    before  => Service[ $service_name ],
  }
  file { "${install_directory}/etc/hadoop/hdfs-site.xml":
    ensure  => present,
    owner   => 'hdfs',
    group   => 'hadoop',
    content => template('hadoop/config/hdfs-site.xml.erb'),
    require => Archive[ "${package_dir}/${basefilename}" ],
    before  => Service[ $service_name ],
  }
  file { "${install_directory}/etc/hadoop/hadoop-env.sh":
    ensure  => present,
    owner   => 'hdfs',
    group   => 'hadoop',
    content => template('hadoop/config/hadoop-env.sh.erb'),
    require => Archive[ "${package_dir}/${basefilename}" ],
    before  => Service[ $service_name ],
  }
  file { "${install_directory}/etc/hadoop/mapred-site.xml":
    ensure  => present,
    mode    => '0644',
    owner   => 'mapred',
    group   => 'hadoop',
    content => template('hadoop/config/mapred-site.xml.erb'),
    require => Archive[ "${package_dir}/${basefilename}" ],
    before  => Service[ $service_name ],
  }
  file { "${install_directory}/etc/hadoop/yarn-site.xml":
    ensure  => present,
    owner   => 'yarn',
    group   => 'hadoop',
    content => template('hadoop/config/yarn-site.xml.erb'),
    require => Archive[ "${package_dir}/${basefilename}" ],
    before  => Service[ $service_name ],
  }

}