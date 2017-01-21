class hadoop::historyserver::service {
  if $hadoop::service_install {
    if $::service_provider == 'systemd' {
      include ::systemd
      file { "${hadoop::service_historyserver}.service":
        ensure  => file,
        path    => "/etc/systemd/system/${hadoop::service_historyserver}.service",
        mode    => '0644',
        content => template('hadoop/service/unit-hadoop-historyserver.erb'),
      }
      file { "/etc/init.d/${hadoop::service_historyserver}":
        ensure => absent,
      }

      File["${hadoop::service_historyserver}.service"] ~>
      Exec['systemctl-daemon-reload'] ->
      Service[$hadoop::service_historyserver]
    } else {
      file { "${hadoop::service_historyserver}.service":
        ensure  => file,
        path    => "/etc/init.d/${hadoop::service_historyserver}",
        mode    => '0755',
        content => template('hadoop/init.erb'),
        before  => Service[$hadoop::service_historyserver],
      }
    }

    service { $hadoop::service_historyserver:
      ensure     => $hadoop::service_ensure,
      enable     => true,
      hasstatus  => true,
      hasrestart => true,
    }
  } else {
    debug('Skipping service install')
  }
}