class hadoop::install {

  file { $hadoop::download_dir:
    ensure  => directory,
    owner   => $hadoop::hdfs_user,
    group   => $hadoop::hadoop_group,
    require => [
      Group[$hadoop::hadoop_group],
      User[ $hadoop::hdfs_user ],
    ],
  }

  file { $hadoop::extract_dir:
    ensure  => directory,
    owner   => $hadoop::hdfs_user,
    group   => $hadoop::hadoop_group,
    require => [
      Group[$hadoop::hadoop_group],
      User[$hadoop::hdfs_user],
    ],
  }

  file { $hadoop::log_dir:
    ensure  => directory,
    owner   => $hadoop::hdfs_user,
    group   => $hadoop::hadoop_group,
    require => [
      Group[$hadoop::hadoop_group],
      User[$hadoop::hdfs_user],
    ],
  }

  file { $hadoop::pid_dir:
    ensure  => directory,
    owner   => $hadoop::hdfs_user,
    group   => $hadoop::hadoop_group,
    require => [
      Group[$hadoop::hadoop_group],
      User[$hadoop::hdfs_user],
    ],
  }

  if $hadoop::package_name == undef {
    include '::archive'

    archive { "${hadoop::download_dir}/${hadoop::basefilename}":
      ensure          => present,
      extract         => true,
      extract_command => 'tar xfz %s --strip-components=1',
      extract_path    => $hadoop::extract_dir,
      source          => $hadoop::package_url,
      creates         => "${hadoop::extract_dir}/sbin",
      cleanup         => true,
      user            => $hadoop::hdfs_user,
      group           => $hadoop::hadoop_group,
      require         => [
        File[$hadoop::download_dir],
        File[$hadoop::extract_dir],
        Group[$hadoop::hadoop_group],
        User[$hadoop::hdfs_user],
      ],
      before          => File[ $hadoop::install_dir ],
    }
  } else {
    package { $package_name:
      ensure => $package_ensure,
      before => File[ $hadoop::install_dir ],
    }
  }

  file { $hadoop::install_dir:
    ensure  => link,
    target  => $hadoop::extract_dir,
    require => File[ $hadoop::extract_dir ],
  }

  file { "${hadoop::config_dir}":
    ensure  => directory,
    owner   => $hadoop::hdfs_user,
    group   => $hadoop::hadoop_group,
    require => [
      Group[ $hadoop::hadoop_group ],
      User[ $hadoop::hdfs_user ],
      File[ $hadoop::install_dir ],
    ],
  }
}
