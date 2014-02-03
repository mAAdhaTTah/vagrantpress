# Install PHP

class php5::install {

	package { [
	  'php5',
	  'php5-mysql',
	  'php5-curl',
	  'php5-gd',
	  'php5-fpm',
	  'libapache2-mod-php5',
	  'php5-dev',
	  'php5-xdebug',
	  'php-pear',
	  'php5-cli'
	]:
	ensure => installed,
	}
  
	# upgrade pear
	exec {"pear upgrade":
	  command => "/usr/bin/pear upgrade",
	  require => Package['php-pear'],
	}
	
	# set channels to auto discover
	exec { "pear auto_discover" :
		command => "/usr/bin/pear config-set auto_discover 1",
		require => [Package['php-pear']]
	}
	
	# update channels
	exec { "pear update-channels" :
		command => "/usr/bin/pear update-channels",
		require => [Package['php-pear']]
	}
	
  file { '/etc/php5/apache2/php.ini':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    source  => '/vagrant/files/etc/php5/php.ini',
    require => Package['php5'],
    notify  => Service['apache2'],
  }
}
