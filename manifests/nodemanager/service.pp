class hadoop::nodemanager::service {
  if $hadoop::service_install {
    if $::service_provider == 'systemd' {
      include ::systemd
      file { "${hadoop::service_nodemanager}.service":
        ensure  => file,
        path    => "/etc/systemd/system/${hadoop::service_nodemanager}.service",
        mode    => '0644',
        content => template('hadoop/service/unit-hadoop-nodemanager.erb'),
      }
      file { "/etc/init.d/${hadoop::service_nodemanager}":
        ensure => absent,
      }

      File["${hadoop::service_nodemanager}.service"] ~>
      Exec['systemctl-daemon-reload'] ->
      Service[$hadoop::service_nodemanager]
    } else {
      file { "${hadoop::service_nodemanager}.service":
        ensure  => file,
        path    => "/etc/init.d/${hadoop::service_nodemanager}",
        mode    => '0755',
        content => template('hadoop/init.erb'),
        before  => Service[$hadoop::service_nodemanager],
      }
    }

    service { $hadoop::service_nodemanager:
      ensure     => $hadoop::service_ensure,
      enable     => true,
      hasstatus  => true,
      hasrestart => true,
    }
  } else {
    debug('Skipping service install')
  }
}