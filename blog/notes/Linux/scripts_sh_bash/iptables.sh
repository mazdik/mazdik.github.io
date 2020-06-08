#!/bin/bash
# очищаем правила
/sbin/iptables -F
/sbin/iptables -t nat -F
/sbin/iptables -t mangle -F

# other network protection
echo 1 > /proc/sys/net/ipv4/tcp_syncookies                              # enable syn cookies (prevent against the common 'syn flood attack')
echo 0 > /proc/sys/net/ipv4/ip_forward                                  # disable Packet forwarning between interfaces
echo 1 > /proc/sys/net/ipv4/icmp_echo_ignore_broadcasts                 # ignore all ICMP ECHO and TIMESTAMP requests sent to it via broadcast/multicast
echo 1 > /proc/sys/net/ipv4/conf/all/log_martians                       # log packets with impossible addresses to kernel log
echo 1 > /proc/sys/net/ipv4/icmp_ignore_bogus_error_responses           # disable logging of bogus responses to broadcast frames
echo 1 > /proc/sys/net/ipv4/conf/all/rp_filter                          # do source validation by reversed path (Recommended option for single homed hosts)
echo 0 > /proc/sys/net/ipv4/conf/all/send_redirects                     # don't send redirects
echo 0 > /proc/sys/net/ipv4/conf/all/accept_source_route                # don't accept packets with SRR option

# запрещаем все (очень опасно)
/sbin/iptables -P INPUT   DROP
/sbin/iptables -P FORWARD DROP
/sbin/iptables -P OUTPUT  DROP

# drop Bad Guys
/sbin/iptables -A INPUT -m recent --rcheck --seconds 60 -m limit --limit 10/second -j DROP

# drop unwanted services
/sbin/iptables -A INPUT -m multiport -p tcp --dports 25,110,111,119,143,465,563,587,993,995 -j DROP
/sbin/iptables -A INPUT -m multiport -p tcp --dports 25,110,111,119,143,465,563,587,993,995 -j DROP

# accept everything from loopback
/sbin/iptables -A INPUT  -i lo -j ACCEPT
/sbin/iptables -A OUTPUT -o lo -j ACCEPT

# открываем порты
/sbin/iptables -A INPUT -p tcp --dport 22 -j ACCEPT
/sbin/iptables -A INPUT -p tcp --dport 80 -j ACCEPT
/sbin/iptables -A INPUT -p tcp --dport 2106 -j ACCEPT
/sbin/iptables -A INPUT -p tcp --dport 7777 -j ACCEPT

# connlimit
/sbin/iptables -A INPUT -p tcp --syn --dport 2106 -m connlimit --connlimit-above 5 -j REJECT
/sbin/iptables -A INPUT -p tcp --syn --dport 7777 -m connlimit --connlimit-above 7 -j REJECT
/sbin/iptables -A INPUT -p tcp --syn --dport 80 -m connlimit --connlimit-above 20 -j REJECT
/sbin/iptables -A INPUT -p tcp --syn --dport 22 -m connlimit --connlimit-above 3 -j REJECT
