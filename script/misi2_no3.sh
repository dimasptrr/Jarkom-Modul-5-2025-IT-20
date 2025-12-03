
#2. Pasang Rule di NARYA (Server Target)
#Masuk ke console Narya, lalu ketik perintah ini:

# 1. Izinkan Vilya (IP 192.221.2.26) masuk ke port 53
iptables -A INPUT -p udp --dport 53 -s 192.221.2.26 -j ACCEPT
iptables -A INPUT -p tcp --dport 53 -s 192.221.2.26 -j ACCEPT

# 2. Blokir akses port 53 dari IP lain (selain Vilya)
iptables -A INPUT -p udp --dport 53 -j DROP
iptables -A INPUT -p tcp --dport 53 -j DROP

#Tes Ulang (Pembuktian)
#Setelah rule terpasang di Narya, lakukan tes lagi:

apt-get update
apt-get install netcat-openbsd -y

Dari Vilya: 
nc -zv 192.221.2.27 53 #Hasil: Harus Succeeded! (Karena IP Vilya di-whitelist).

Dari Elendil:
nc -zv 192.221.2.27 53 #Hasil: Harus Connection Timed Out (Gagal/Hanging), karena paketnya di-DROP oleh Narya.

#setelah itu restart firewall di Narya
iptables -F