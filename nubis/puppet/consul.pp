# Enable consul-template, base doesn't enable it yet
class { 'consul_template':
	service_enable => true,
	service_ensure => 'stopped',
	version        => '0.16.0',
	user           => 'root',
	group          => 'root',
}

file { "${consul_template::config_dir}/executive-dashboard.conf.ctmpl":
  ensure  => file,
  owner   => root,
  group   => root,
  mode    => '0644',
  source  => 'puppet:///nubis/files/executive-dashboard.conf.ctmpl',
  require => [
    Class['consul_template'],
  ],
}

# Configure Apache Proxy
consul_template::watch { 'executive-dashboard.confi':
	source      => "${consul_template::config_dir}/executive-dashboard.conf.ctmpl",
	destination => '/etc/apache2/conf.d/admin.conf',
	command     => '/etc/init.d/apache2 reload || /etc/init.d/apache2 restart',
}
