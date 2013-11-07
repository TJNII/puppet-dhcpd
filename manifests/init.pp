# Copyright 2013 Tom Noonan II (TJNII)
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# 
# dhcpd: Configure an ISC DHCPd server to serve a predefined range on all specified interfaces
class dhcpd (
  $dhcp_iface_list      = $interfaces_internal,
  $dynamic_range        = [ "0.0.0.100", "0.0.0.199" ],
  $router_offset        = "0.0.0.1",
  $default_lease_time   = 259200,
  $fallback_nameservers = undef,
  $fallback_ntpservers  = undef,
  $manage_firewall      = true,
  $host_declarations    = {},
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
#    subscribe => File['/etc/dhcp/dhcpd6.conf'],
  }

  if $manage_firewall == true {
    include firewall-config::base
    
    firewall { '101 allow dhcpd':
      dport => [ 67, 68 ],
      sport => [ 67, 68 ],
      proto => 'udp',
      action => accept,
    }
  }
}
