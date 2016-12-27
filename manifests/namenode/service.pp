class hadoop::namenode::service {
  if $hadoop::service_install {
    if $::service_provider == 'systemd' {
      include ::systemd
      file { "${hadoop::service_namenode}.service":
        ensure  => file,
        path    => "/etc/systemd/system/${hadoop::service_namenode}.service",
        mode    => '0644',
        content => template('hadoop/service/unit-hadoop-namenode.erb'),
      }
      file { "/etc/init.d/${hadoop::service_namenode}":
        ensure => absent,
      }

      File["${hadoop::service_namenode}.service"] ~>
      Exec['systemctl-daemon-reload'] ->
      Service[$hadoop::service_namenode]
    } else {
      file { "${hadoop::service_namenode}.service":
        ensure  => file,
        path    => "/etc/init.d/${hadoop::service_namenode}",
        mode    => '0755',
        content => template('hue/init.erb'),
        before  => Service[$hadoop::service_namenode],
      }
    }

    service { $hadoop::service_namenode:
      ensure     => $hadoop::service_ensure,
      enable     => true,
      hasstatus  => true,
      hasrestart => true,
    }
  } else {
    debug('Skipping service install')
  }
}