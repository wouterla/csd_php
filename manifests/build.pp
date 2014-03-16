notify { 'Hello from BUILD!': }

# Execute apt-get update
exec { "apt-get update":
    command => "/usr/bin/apt-get update",
    before => [ Class["jenkins"], Class[php] ]
}


include jenkins
include php

package { 
  'subversion':
	ensure => "installed";
  'git':
	ensure => "installed";
  'maven':
	ensure => "installed";
  'php5-xdebug':
    ensure => "installed";
}

jenkins::plugin {
  "promoted-builds" : ;
  "credentials" : ;
  "parameterized-trigger" : ;
  "ssh-credentials" : ;
  "git-client" : ;
  "scm-api" : ;
  "token-macro" : ;
  "multiple-scms" : ;
  "git" : ;
  "maven-plugin" : ;
  "subversion" : ;
  "php" : ;
  "cloverphp" : ;
  "fitnesse" : ;
}

php::pear::module { 'PHPUnit': 
  use_package => 'no',
}

php::pear::module { 'phing': 
  repository  => 'pear.phing.info',
  use_package => 'no',
}


class fitnesse {
  
  group { 'fitnesse':
	ensure => present,
  }

  user { 'fitnesse':
	gid => 'fitnesse',
	ensure => present,
	require => Group['fitnesse'],
  }

  file {'/usr/share/fitnesse':
	ensure => directory,
	mode   => 0644,
	owner => 'fitnesse',
	group => 'fitnesse',
	require => User['fitnesse'],
  }

  file {'/var/lib/fitnesse':
	ensure => directory,
	mode   => 0644,
	owner => 'fitnesse',
	group => 'fitnesse',
	require => User['fitnesse'],
  }

  file {'/var/log/fitnesse':
	ensure => directory,
	mode   => 0644,
	owner => 'fitnesse',
	group => 'fitnesse',
	require => User['fitnesse'],
  }

  file { '/usr/share/fitnesse/fitnesse.jar':
	ensure => file,
    mode => 0644,
	owner => 'fitnesse',
	group => 'fitnesse',
	source => 'file:///vagrant/fitnesse/fitnesse-standalone.jar',
	require => File['/usr/share/fitnesse'],
  }

  file { '/etc/init/fitnesse.conf':
	ensure => file,
	mode => 0644,
	owner => 'root',
	group => 'root',
	source => 'file:///vagrant/fitnesse/fitnesse.conf',
    require => File['/usr/share/fitnesse/fitnesse.jar'],
  }

  file { '/etc/init.d/fitnesse':
    ensure => link,
    mode => 0644,
    owner => 'root',
    group => 'root',
    target => '/lib/init/upstart-job',
    require => File['/etc/init/fitnesse.conf'],
  }

  service { 'fitnesse':
    ensure => running,
    hasstatus => false,
    require => [ File['/etc/init.d/fitnesse'], File['/var/log/fitnesse'] ],
  }

#   # Install PHP Slim support
#   file { '/var/lib/fitnesse/FitNesseRoot':
#     ensure => directory,
#     mode => 0644,
#     owner => 'fitnesse',
#     group => 'fitnesse',
#     require => File['/var/lib/fitnesse'],
#   }

  file { '/var/lib/fitnesse/FitNesseRoot/phpslim.phar':
    ensure => file,
    mode => 0755,
    owner => 'fitnesse',
    group => 'fitnesse',
    source => 'file:///vagrant/fitnesse/phpslim.phar',
  }

#   file { '/var/lib/fitnesse/FitNesseRoot/content.txt':
#     ensure => file,
#     mode => 0644,
#     owner => 'fitnesse',
#     group => 'fitnesse',
#     source => 'file:///vagrant/fitnesse/root_content.txt',
#     require => File['/var/lib/fitnesse/FitNesseRoot'],
#   }

}

class{ 'fitnesse': ; }