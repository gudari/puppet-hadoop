class hadoop::namenode::config (
  $install_directory = $hadoop::install_directory,
  $package_dir       = $hadoop::package_dir,
  $basefilename      = $hadoop::basefilename,
  $service_name      = $hadoop::service_name,
  $service_user      = $hadoop::service_user,
  $service_group     = $hadoop::service_group,
)
{

  file { "/home/${service_user}/.ssh":
    ensure => directory,
    owner  => $service_user,
    group  => $service_group,
    mode   => '0700',
    require => User[ $service_user ],
  }
  file { "/home/${service_user}/.ssh/id_dsa":
    ensure  => file,
    owner   => $service_user,
    group   => $service_group,
    mode    => '0400',
    source  => 'puppet:///modules/hadoop/sshkey/id_dsa',
    require => File[ "/home/${service_user}/.ssh" ],
    before  => Service[ $service_name ],
  }
  file { "/home/${service_user}/.ssh/authorized_keys":
    ensure => file,
    owner  => $service_user,
    group  => $service_group,
    mode   => '0600',
    source => 'puppet:///modules/hadoop/sshkey/authorized_keys',
    require => File[ "/home/${service_user}/.ssh" ],
    before  => Service[ $service_name ],
  }
  file { "/home/${service_user}/.ssh/known_hosts":
    ensure => file,
    owner  => $service_user,
    group  => $service_group,
    mode   => '0644',
    source => 'puppet:///modules/hadoop/sshkey/known_hosts',
    require => File[ "/home/${service_user}/.ssh" ],
    before  => Service[ $service_name ],
  }
    file { "${install_directory}/etc/hadoop/core-site.xml":
    ensure  => present,
    mode    => '0644',
    owner   => $service_user,
    group   => $service_group,
    content => template('hadoop/config/core-site.xml.erb'),
    require => Archive[ "${package_dir}/${basefilename}" ],
    before  => Service[ $service_name ],
  }
  file { "${install_directory}/etc/hadoop/hdfs-site.xml":
    ensure  => present,
    owner   => $service_user,
    group   => $service_group,
    content => template('hadoop/config/hdfs-site.xml.erb'),
    require => Archive[ "${package_dir}/${basefilename}" ],
    before  => Service[ $service_name ],
  }
  file { "${install_directory}/etc/hadoop/hadoop-env.sh":
    ensure  => present,
    owner   => $service_user,
    group   => $service_group,
    content => template('hadoop/config/hadoop-env.sh.erb'),
    require => Archive[ "${package_dir}/${basefilename}" ],
    before  => Service[ $service_name ],
  }
}