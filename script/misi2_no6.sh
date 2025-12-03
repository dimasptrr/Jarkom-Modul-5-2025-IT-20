#di palantir
# 1. Cek: Jika hit > 4 dalam 60 detik, lempar ke PORT_SCAN
iptables -A INPUT -m recent --name attacker --update --seconds 60 --hitcount 4 -j PORT_SCAN

# 2. Tandai paket baru
iptables -A INPUT -m recent --name attacker --set

# 3. (PENTING) Izinkan trafik normal sisa (agar ping pertama kali bisa masuk sebelum kena limit)
iptables -A INPUT -j ACCEPT

#tes di elendil
#Elendil:
 nmap -p 1-100 192.221.2.10

#Tunggu sebentar, lalu coba 
ping 192.221.2.10.

#Harusnya Gagal/RTO (karena IP Elendil sudah di-ban sementara).

#cek Log di Palantir: 
dmesg | tail #-> Muncul tulisan "PORT_SCAN_DETECTED".


# Kembalikan ke Konfigurasi Soal (Untuk Laporan)
# 1. Reset
iptables -F INPUT

# 2. Aturan Asli Port Scan (Sesuai Soal)
iptables -A INPUT -m recent --name attacker --update --seconds 20 --hitcount 15 -j PORT_SCAN
iptables -A INPUT -m recent --name attacker --set

# 3. Gabung dengan Aturan Web Server (Misi 2 No 5)
iptables -A INPUT -p tcp --dport 80 -s 192.221.1.0/25 -m time --timestart 07:00 --timestop 15:00 -j ACCEPT
iptables -A INPUT -p tcp --dport 80 -s 192.221.0.0/24 -m time --timestart 17:00 --timestop 23:00 -j ACCEPT
iptables -A INPUT -p tcp --dport 80 -s 192.221.1.192/26 -m time --timestart 17:00 --timestop 23:00 -j ACCEPT

# 4. Blokir Sisa
iptables -A INPUT -p tcp --dport 80 -j DROP