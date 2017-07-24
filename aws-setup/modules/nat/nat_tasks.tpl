- name: NAT iptables rule for ${network_addr}
  iptables:
    table: nat
    chain: POSTROUTING
    out_interface: eth0
    source: ${network_addr}
    jump: MASQUERADE
