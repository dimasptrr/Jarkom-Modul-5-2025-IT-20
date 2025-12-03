# 1. Izinkan trafik balasan (agar Vilya bisa ping keluar dan menerima reply)
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

# 2. Blokir semua Ping (ICMP Echo Request) yang masuk
iptables -A INPUT -p icmp --icmp-type echo-request -j DROP

dari elendil
ping 192.221.2.26

dari vilya ke 
