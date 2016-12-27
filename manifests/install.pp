class hadoop::install (
  $package_name      = $hadoop::package_name,
  $basefilename      = $hadoop::basefilename,
  $package_url       = $hadoop::package_url,
  $package_dir       = $hadoop::package_dir,
  $user_id           = $hadoop::user_id,
  $hadoop_etc_dir    = $hadoop::hadoop_etc_dir,

  $mapred_user       = $hadoop::mapred_user,
  $mapred_id         = $hadoop::mapred_id,
  $yarn_user         = $hadoop::yarn_user,
  $yarn_id           = $hadoop::yarn_id,
  $hadoop_group      = $hadoop::hadoop_group,
  $hadoop_id         = $hadoop::hadoop_id,
)
{

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
    require => File[ $hadoop::extract_directory ],
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
