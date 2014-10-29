
class common {
  include ruby

  cron { "ntpdate_set":
    command => "/usr/sbin/ntpdate ntp.ubuntu.com",
    hour => [10], #times are UTC!
    minute => fqdn_rand(59)
  }

  file {'/etc/sudoers':
    ensure => 'present',
    owner => "root",
    group => "root",
    mode => 440,
    source  => "puppet:///modules/common/sudoers"
  }

  file { "/etc/profile.d/set_env_vars.sh":
    ensure => present,
    mode   => 777,
    content  => template("common/set_env_vars.sh.erb"),
  }

  file {["/data", "/mnt/config"]:
    ensure => "directory",
    owner => "spree",
    group => "www-data",
    mode => 660
  }

  file {"/etc/init/bluepill.conf":
    content => template("common/bluepill_upstart.erb"),
    mode => 600
  }

  service { "bluepill":
    provider => 'upstart',
    ensure => 'running',
    require => [ File['/etc/init/bluepill.conf'], Package['bluepill'] ]
    #require => [ Spree::App[$app_name], File['/etc/init/bluepill.conf'], Package['bluepill'] ]
  }
}
