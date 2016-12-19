class hadoop::namenode::service (
  $service_install   = $hadoop::service_install,
  $service_ensure    = $hadoop::service_ensure,
  $log4j_opts        = $hadoop::log4j_opts,
  $opts              = $hadoop::opts,
  $config_dir        = $hadoop::config_dir,
  $pid_location      = $hadoop::pid_location,
  $log_dir           = $hadoop::log_dir,
  $service_namenode  = $hadoop::params::service_namenode,
  $install_directory = $hadoop::install_directory,
)
{
  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  if $service_install {
    if $::service_provider == 'systemd' {
      include ::systemd
      file { "${$service_namenode}.service":
        ensure  => file,
        path    => "/etc/systemd/system/${$service_namenode}.service",
        mode    => '0644',
        content => template('hadoop/unit.erb'),
      }
      file { "/etc/init.d/${$service_namenode}":
        ensure => absent,
      }

      File["${$service_namenode}.service"] ~>
      Exec['systemctl-daemon-reload'] ->
      Service[$service_namenode]
    } else {
      file { "${$service_namenode}.service":
        ensure  => file,
        path    => "/etc/init.d/${$service_namenode}",
        mode    => '0755',
        content => template('hue/init.erb'),
        before  => Service[$service_name],
      }
    }

    service { $service_namenode:
      ensure     => $service_ensure,
      enable     => true,
      hasstatus  => true,
      hasrestart => true,
    }
  } else {
    debug('Skipping service install')
  }

}