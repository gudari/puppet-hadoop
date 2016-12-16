class hadoop::params {
  $version        = '2.7.3'
  $install_dir    = "/opt/hadoop-${version}"
  $mirror_url     = 'http://apache.rediris.es/hadoop/common'
  $install_java   = true
  $package_dir    = '/var/tmp/hadoop'
  $package_name   = undef
  $package_ensure = 'present'
  $group_id       = undef
  $user_id        = undef
  $install_dependencies  = true
  $packages_dependencies = [ 'openssh', 'rsync' ]

  $service_install = true
  $service_ensure = 'running'

  $config_defaults = {}
  $jmx_opts = ''
  $heap_opts = '-Xmx1G -Xms1G'
  $log4j_opts = ''
  $opts = ''

  $service_restart = true
  $service_name    = 'hadoop'
}
