class hadoop::timelineserver::service {

  if $hadoop::service_install {

    if $::service_provider == 'systemd' {

      exec { "systemctl-daemon-reload-${hadoop::service_timelineserver}":
        command     => 'systemctl daemon-reload',
        refreshonly => true,
        path        => '/usr/bin',
      }

      file { "${hadoop::service_timelineserver}.service":
        ensure  => file,
        path    => "/etc/systemd/system/${hadoop::service_timelineserver}.service",
        mode    => '0644',
        content => template('hadoop/service/unit-hadoop-timelineserver.erb'),
      }

      file { "/etc/init.d/${hadoop::service_timelineserver}":
        ensure => absent,
      }

      File["${hadoop::service_timelineserver}.service"] ~>
      Exec["systemctl-daemon-reload-${hadoop::service_timelineserver}"] ->
      Service[$hadoop::service_timelineserver]
    } else {
      file { "${hadoop::service_timelineserver}.service":
        ensure  => file,
        path    => "/etc/init.d/${hadoop::service_timelineserver}",
        mode    => '0755',
        content => template('hadoop/init.erb'),
        before  => Service[$hadoop::service_timelineserver],
      }
    }

    service { $hadoop::service_timelineserver:
      ensure     => $hadoop::service_ensure,
      enable     => true,
      hasstatus  => true,
      hasrestart => true,
    }
  } else {
    debug('Skipping service install')
  }
}
