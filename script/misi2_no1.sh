# Cek dulu IP eth0 dapat berapa
ip a show eth0

# Pasang SNAT (Ganti IP_ETH0 di bawah dgn IP aslinya!)
# Contoh: iptables -t nat -A POSTROUTING -o eth0 -j SNAT --to-source 192.168.122.50
iptables -t nat -A POSTROUTING -o eth0 -j SNAT --to-source [MASUKKAN_IP_ETH0_DISINI]