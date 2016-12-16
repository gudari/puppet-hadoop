class hadoop (
  $version               = $hadoop::params::version,
  $install_dir           = $hadoop::params::install_dir,
  $mirror_url            = $hadoop::params::mirror_url,
  $install_java          = $hadoop::params::install_java,
  $package_dir           = $hadoop::params::package_dir,
  $package_name          = $hadoop::params::package_name,
  $package_ensure        = $hadoop::params::package_ensure,
  $group_id              = $hadoop::params::group_id,
  $user_id               = $hadoop::params::user_id,
  $etc_dir               = 'etc/hadoop',
  $install_dependencies  = $hadoop::params::install_dependencies,
  $packages_dependencies = $hadoop::params::packages_dependencies,
  $service_name          = $hadoop::params::service_name,
) inherits hadoop::params {

  validate_bool($install_java)
  validate_absolute_path($package_dir)

  $basefilename = "hadoop-${version}.tar.gz"
  $package_url = "${mirror_url}/hadoop-${version}/${basefilename}"

  $install_directory = $install_dir ? {
    $hadoop::params::install_dir => "/opt/hadoop-${version}",
    default                     => $install_dir,
  }

  if $install_java {
    java::oracle { 'jdk8':
      ensure  => 'present',
      version => '8',
      java_se => 'jdk',
      before  => Archive[ "${package_dir}/${basefilename}" ]
    }
  }

  if $install_dependencies {
    package { $packages_dependencies:
      ensure => present,
      before => Exec[ 'install hue' ],
    }
  }

  group { 'hadoop':
    ensure => present,
    gid    => $group_id,
  }

  user { 'hadoop':
    ensure  => present,
    shell   => '/bin/bash',
    require => Group['hadoop'],
    uid     => $user_id,
  }

  file { $package_dir:
    ensure  => directory,
    owner   => 'hadoop',
    group   => 'hadoop',
    require => [
      Group['hadoop'],
      User['hadoop'],
    ],
  }

  file { $install_directory:
    ensure  => directory,
    owner   => 'hadoop',
    group   => 'hadoop',
    require => [
      Group['hadoop'],
      User['hadoop'],
    ],
  }
  file { '/opt/hadoop':
    ensure  => link,
    target  => $install_directory,
    require => File[$install_directory],
  }

  file { '/opt/hadoop/config':
    ensure => directory,
    owner  => 'hadoop',
    group  => 'hadoop',
  }

  file { '/var/log/hadoop':
    ensure  => directory,
    owner   => 'hadoop',
    group   => 'hadoop',
    require => [
      Group['hadoop'],
      User['hadoop'],
    ],
  }

  class { 'hadoop::install': }
  class { 'hadoop::config': }
  class { 'hadoop::service': }

}
