class hadoop::journalnode::service {

  if $hadoop::service_install {

    if $::service_provider == 'systemd' {

      exec { "systemctl-daemon-reload-${hadoop::service_journalnode}":
        command     => 'systemctl daemon-reload',
        refreshonly => true,
        path        => '/usr/bin',
      }

      file { "${hadoop::service_journalnode}.service":
        ensure  => file,
        path    => "/etc/systemd/system/${hadoop::service_journalnode}.service",
        mode    => '0644',
        content => template('hadoop/service/unit-hadoop-journalnode.erb'),
      }

      file { "/etc/init.d/${hadoop::service_journalnode}":
        ensure => absent,
      }

      File["${hadoop::service_journalnode}.service"] ~>
      Exec["systemctl-daemon-reload-${hadoop::service_journalnode}"] ->
      Service[$hadoop::service_journalnode]

    } else {

      file { "${hadoop::service_journalnode}.service":
        ensure  => file,
        path    => "/etc/init.d/${hadoop::service_journalnode}",
        mode    => '0755',
        content => template('hue/init.erb'),
        before  => Service[$hadoop::service_journalnode],
      }
    }

    service { $hadoop::service_journalnode:
      ensure     => $hadoop::service_ensure,
      enable     => true,
      hasstatus  => true,
      hasrestart => true,
    }
  } else {
    debug('Skipping service install')
  }
}
