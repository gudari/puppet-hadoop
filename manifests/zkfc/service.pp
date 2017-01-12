class hadoop::zkfc::service {
  if $hadoop::service_install {
    if $::service_provider == 'systemd' {
      include ::systemd
      file { "${hadoop::service_zkfc}.service":
        ensure  => file,
        path    => "/etc/systemd/system/${hadoop::service_zkfc}.service",
        mode    => '0644',
        content => template('hadoop/service/unit-hadoop-zkfc.erb'),
      }
      file { "/etc/init.d/${hadoop::service_zkfc}":
        ensure => absent,
      }

      File["${hadoop::service_zkfc}.service"] ~>
      Exec['systemctl-daemon-reload'] ->
      Service[$hadoop::service_zkfc]
    } else {
      file { "${hadoop::service_zkfc}.service":
        ensure  => file,
        path    => "/etc/init.d/${hadoop::service_zkfc}",
        mode    => '0755',
        content => template('hue/init.erb'),
        before  => Service[$hadoop::service_zkfc],
      }
    }

    service { $hadoop::service_zkfc:
      ensure     => $hadoop::service_ensure,
      enable     => true,
      hasstatus  => true,
      hasrestart => true,
    }
  } else {
    debug('Skipping service install')
  }
}