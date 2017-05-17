class hadoop::datanode::service {

  if $hadoop::service_install {

    if $::service_provider == 'systemd' {

      exec { "systemctl-daemon-reload-${hadoop::service_datanode}":
        command     => 'systemctl daemon-reload',
        refreshonly => true,
        path        => '/usr/bin',
      }

      file { "${hadoop::service_datanode}.service":
        ensure  => file,
        path    => "/etc/systemd/system/${hadoop::service_datanode}.service",
        mode    => '0644',
        content => template('hadoop/service/unit-hadoop-datanode.erb'),
      }

      file { "/etc/init.d/${hadoop::service_datanode}":
        ensure => absent,
      }

      File["${hadoop::service_datanode}.service"] ~>
      Exec["systemctl-daemon-reload-${hadoop::service_datanode}"] ->
      Service[$hadoop::service_datanode]

    } else {

      file { "${hadoop::service_datanode}.service":
        ensure  => file,
        path    => "/etc/init.d/${hadoop::service_datanode}",
        mode    => '0755',
        content => template('hue/init.erb'),
        before  => Service[$hadoop::service_datanode],
      }
    }

    service { $hadoop::service_datanode:
      ensure     => $hadoop::service_ensure,
      enable     => true,
      hasstatus  => true,
      hasrestart => true,
    }

  } else {

    debug('Skipping service install')

  }
}
