define hadoop::service (
  $service_name      = $title,
  $service_install   = $hadoop::service_install,
  $service_ensure    = $hadoop::service_ensure,
  $service_user      = 'root',
  $service_group     = 'root',
  $log4j_opts        = $hadoop::log4j_opts,
  $opts              = $hadoop::opts,
  $config_dir        = $hadoop::config_dir,
  $pid_location      = $hadoop::pid_location,
  $log_dir           = $hadoop::log_dir,
  $install_directory = $hadoop::install_directory,
  $hadoop_etc_dir    = $hadoop::hadoop_etc_dir,
  $java_home_dir     = '/usr',
)
{
  if $service_install {
    if $::service_provider == 'systemd' {
      include ::systemd
      file { "${service_name}.service":
        ensure  => file,
        path    => "/etc/systemd/system/${service_name}.service",
        mode    => '0644',
        content => template('hadoop/unit.erb'),
      }
      file { "/etc/init.d/${service_name}":
        ensure => absent,
      }

      File["${service_name}.service"] ~>
      Exec['systemctl-daemon-reload'] ->
      Service[$service_name]
    } else {
      file { "${service_name}.service":
        ensure  => file,
        path    => "/etc/init.d/${service_name}",
        mode    => '0755',
        content => template('hue/init.erb'),
        before  => Service[$service_name],
      }
    }

    service { $service_name:
      ensure     => $service_ensure,
      enable     => true,
      hasstatus  => true,
      hasrestart => true,
    }
  } else {
    debug('Skipping service install')
  }

}