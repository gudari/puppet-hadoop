class hadoop::install (
  $package_name = $hadoop::package_name,
  $basefilename = $hadoop::basefilename,
  $package_url  = $hadoop::package_url,
  $package_dir  = $hadoop::package_dir,
  $install_directory = $hadoop::install_directory,
)
{
  if $package_name == undef {
    include '::archive'

    archive { "${package_dir}/${basefilename}":
      ensure          => present,
      extract         => true,
      extract_command => 'tar xfz %s --strip-components=1',
      extract_path    => $install_directory,
      source          => $package_url,
      creates         => "${install_directory}/config",
      cleanup         => true,
      user            => $hadoop::hdfs_user,
      group           => $hadoop::hadoop_group,
      require         => [
        File[$package_dir],
        File[$install_directory],
        Group[$hadoop::hadoop_group],
        User[$hadoop::hdfs_user],
      ],
      before          => File['/opt/hadoop/config'],
    }
  } else {
    package { $package_name:
      ensure => $package_ensure,
      before => File['/opt/hadoop/config'],
    }
  }
  class { 'hadoop::format': }
}
