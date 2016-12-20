class hadoop::common::install (
  $package_name = $hadoop::package_name,
  $basefilename = $hadoop::basefilename,
  $package_url  = $hadoop::package_url,
  $package_dir  = $hadoop::package_dir,
  $install_directory = $hadoop::install_directory,
  $user_id               = $hadoop::user_id,
  $hadoop_etc_dir        = $hadoop::hadoop_etc_dir,

  $hdfs_user    = $hadoop::hdfs_user,
  $hdfs_id      = $hadoop::hdfs_id,
  $mapred_user  = $hadoop::pmapred_user,
  $mapred_id    = $hadoop::mapred_id,
  $yarn_user    = $hadoop::yarn_user,
  $yarn_id      = $hadoop::yarn_id,
  $hadoop_group = $hadoop::hadoop_group,
  $hadoop_id    = $hadoop::hadoop_id,
)
{

  file { $package_dir:
    ensure  => directory,
    owner   => $hdfs_user,
    group   => $hadoop_group,
    require => [
      Group[$hadoop_group],
      User[$hdfs_user],
      User[$mapred_user],
      User[$yarn_user],
    ],
  }

  file { $install_directory:
    ensure  => directory,
    owner   => $hdfs_user,
    group   => $hadoop_group,
    require => [
      Group[$hadoop_group],
      User[$hdfs_user],
      User[$mapred_user],
      User[$yarn_user],
    ],
  }
  file { '/opt/hadoop':
    ensure  => link,
    target  => $install_directory,
    require => File[ $install_directory ],
  }

  file { "/opt/hadoop/${hadoop_etc_dir}":
    ensure  => directory,
    owner   => $hdfs_user,
    group   => $hadoop_group,
    require => [
      Group[$hadoop_group],
      User[$hdfs_user],
      User[$mapred_user],
      User[$yarn_user],
    ],
  }

  file { '/var/log/hadoop':
    ensure  => directory,
    owner   => $hdfs_user,
    group   => $hadoop_group,
    require => [
      Group[$hadoop_group],
      User[$hdfs_user],
      User[$mapred_user],
      User[$yarn_user],
    ],
  }

  if $package_name == undef {
    include '::archive'

    archive { "${package_dir}/${basefilename}":
      ensure          => present,
      extract         => true,
      extract_command => 'tar xfz %s --strip-components=1',
      extract_path    => $install_directory,
      source          => $package_url,
      creates         => "${install_directory}/${hadoop_etc_dir}",
      cleanup         => true,
      user            => $hadoop::hdfs_user,
      group           => $hadoop::hadoop_group,
      require         => [
        File[$package_dir],
        File[$install_directory],
        Group[$hadoop::hadoop_group],
        User[$hadoop::hdfs_user],
      ],
      before          => File['/opt/hadoop'],
    }
  } else {
    package { $package_name:
      ensure => $package_ensure,
      before => File['/opt/hadoop'],
    }
  }
}
