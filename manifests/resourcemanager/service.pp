class hadoop::resourcemanager::service {

  if $hadoop::service_install {

    if $::service_provider == 'systemd' {

      exec { "systemctl-daemon-reload-${hadoop::service_resourcemanager}":
        command     => 'systemctl daemon-reload',
        refreshonly => true,
        path        => '/usr/bin',
      }

      file { "${hadoop::service_resourcemanager}.service":
        ensure  => file,
        path    => "/etc/systemd/system/${hadoop::service_resourcemanager}.service",
        mode    => '0644',
        content => template('hadoop/service/unit-hadoop-resourcemanager.erb'),
      }

      file { "/etc/init.d/${hadoop::service_resourcemanager}":
        ensure => absent,
      }

      File["${hadoop::service_resourcemanager}.service"] ~>
      Exec["systemctl-daemon-reload-${hadoop::service_resourcemanager}"] ->
      Service[$hadoop::service_resourcemanager]

    } else {
      file { "${hadoop::service_resourcemanager}.service":
        ensure  => file,
        path    => "/etc/init.d/${hadoop::service_resourcemanager}",
        mode    => '0755',
        content => template('hadoop/init.erb'),
        before  => Service[$hadoop::service_resourcemanager],
      }
    }

    service { $hadoop::service_resourcemanager:
      ensure     => $hadoop::service_ensure,
      enable     => true,
      hasstatus  => true,
      hasrestart => true,
    }
  } else {
    debug('Skipping service install')
  }
}
