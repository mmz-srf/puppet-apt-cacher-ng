class apt-cacher-ng(
  $version = 'installed',
  $bind_address = false,   # BindAddress
  $dont_cache   = false,   # DontCache
) {
  package { 'apt-cacher-ng':
    ensure => $version,
  }

  service { 'apt-cacher-ng':
    ensure  => running,
    require => Package['apt-cacher-ng'],
  }

  file { '/var/cache/apt-cacher-ng':
    ensure  => directory,
    owner   => 'apt-cacher-ng',
    require => Package['apt-cacher-ng'],
  }

  file { '/etc/apt-cacher-ng/bind_address.conf':
    ensure  => $bind_address ? { false => absent, default => present },
    owner   => root,
    group   => root,
    mode    => '0644',
    content => inline_template("BindAddress: <%= @bind_address %>"),
  }

  file { '/etc/apt-cacher-ng/dont_cache.conf':
    ensure  => $dont_cache ? { false => absent, default => present },
    owner   => root,
    group   => root,
    mode    => '0644',
    content => inline_template("DontCache: <%= if (@dont_cache) then @dont_cache.join(' ') end %>"),
  }

}
