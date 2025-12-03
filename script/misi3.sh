# 1. Blokir trafik yang BERASAL DARI Khamul (Source)
# Kita pakai -I FORWARD 1 agar ditaruh paling atas (Prioritas Utama)
iptables -I FORWARD 1 -s 192.221.2.0/29 -j DROP

# 2. Blokir trafik yang MENUJU KE Khamul (Destination)
iptables -I FORWARD 1 -d 192.221.2.0/29 -j DROP

#jika khamul ingin download nc terlebih dahulu hapus rule di atas dengan perintah:
# Hapus aturan blokir Source
iptables -D FORWARD -s 192.221.2.0/29 -j DROP

# Hapus aturan blokir Destination
iptables -D FORWARD -d 192.221.2.0/29 -j DROP

apt-get update
apt-get install netcat-openbsd -y

#di khamul
# 1. Tes Ping (Harus Request Timed Out)
ping 8.8.8.8

# 2. Tes Netcat ke Web Server (Harus Timed Out / Gagal)
nc -zv 192.221.2.18 80

#di durin
ping 8.8.8.8 #berhasil
nc -zv 192.221.2.18 80 #harus succeeded