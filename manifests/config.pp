class hadoop::config (
  $install_directory = $hadoop::install_directory,
  $package_dir       = $hadoop::package_dir,
  $basefilename      = $hadoop::basefilename,
  $service_name      = $hadoop::$service_name,
)
{

  file { '/root/.ssh':
    ensure => directory,
    owner  => 'root',
    group  => 'root',
  }
  file { '/root/.ssh/id_dsa':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    source  => 'puppet:///modules/hadoop/sshkey/id_dsa',
    require => File [ '/root/.ssh' ],
  }
  file { '/root/.ssh/authorized_keys':
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0600',
    source => 'puppet:///modules/hadoop/sshkey/authorized_keys',
    require => File [ '/root/.ssh' ],
  }

  file { "${install_directory}/etc/hadoop/core-site.xml":
    ensure  => present,
    mode    => '0644',
    owner   => 'hadoop',
    group   => 'hadoop',
    content => template('hadoop/config/core-site.xml.erb'),
    require => Archive[ "${package_dir}/${basefilename}" ],
  }
  file { "${install_directory}/etc/hadoop/hdfs-site.xml":
    ensure  => present,
    owner   => 'hadoop',
    group   => 'hadoop',
    content => template('hadoop/config/hdfs-site.xml.erb'),
    require => Archive[ "${package_dir}/${basefilename}" ],
  }
  file { "${install_directory}/etc/hadoop/hadoop-env.sh":
    ensure  => present,
    owner   => 'hadoop',
    group   => 'hadoop',
    content => template('hadoop/config/hadoop-env.sh.erb'),
    require => Archive[ "${package_dir}/${basefilename}" ],
    before  => Service [ $service_name ],
  }

}