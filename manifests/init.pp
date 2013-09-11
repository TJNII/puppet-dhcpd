# dhcpd: Configure an ISC DHCPd server to serve a predefined range on all specified interfaces
class dhcpd (
  $dhcp_iface_list      = $interfaces_internal,
  $dynamic_range        = [ "0.0.0.100", "0.0.0.199" ],
  $router_offset        = "0.0.0.1",
  $default_lease_time   = 259200,
  $fallback_nameservers = undef,
  $fallback_ntpservers  = undef,
) {
  package { 'dhcp':
    ensure => installed,
  }
  
  file { '/etc/dhcp/dhcpd.conf':
    ensure  => file,
    content => template("dhcpd/dhcpd.conf.erb"),
    require => Package['dhcp'],
  }

  service { 'dhcpd':
    ensure    => running,
    enable    => true,
    subscribe => File['/etc/dhcp/dhcpd.conf'],
  }

  service { 'dhcpd6':
    ensure    => stopped,
    enable    => false,
    subscribe => File['/etc/dhcp/dhcpd6.conf'],
  }
}
