class skydns (
 $addr          = '0.0.0.0:53',
 $ca_cert       = undef,
 $discover      = 'false',
 $dnssec        = undef,
 $domain        = 'skydns.local.',
 $hostmaster    = undef,
 $local         = undef,
 $nameservers   = undef,
 $machines      = undef,
 $no_rec        = 'false',
 $rcache        = '0',
 $rcache_ttl    = '60',
 $round_robin   = 'true',
 $rtimeout      = '2s',
 $scache        = '10000',
 $stubzones     = 'false',
 $systemd       = 'false',
 $tls_key       = undef,
 $tls_pem       = undef,
 $verbose       = 'false',
 $runargs       = undef,
 $containername = 'puppet__skydns',
 $reponame      = 'skynetservices/skydns',
) {
  $hostmaster_real = pick($hostmaster, 'hostmaster@${::skydns::domain}')
  service { 'skydns':
      ensure     => running,
      enable     => true,
      subscribe  => File['/etc/systemd/system/skydns.service'],
      require    => File['/etc/systemd/system/skydns.service'],
  }
  file { '/etc/systemd/system/skydns.service':
    ensure   => present,
    mode     => '0444', 
    owner    => root,
    content  => template('skydns/skydns.service.erb'),
  } 
  exec { 'skydns-refresh-config':
    command      => '/usr/bin/systemctl daemon-reload',
    subscribe    => File['/etc/systemd/system/skydns.service'],
    refreshonly  => true,
    before       => Service['skydns'],
  }
}
