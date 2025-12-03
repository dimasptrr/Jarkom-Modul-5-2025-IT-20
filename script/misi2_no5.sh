#Skenario 1: Simulasi "Pagi Hari" (Jam 10.00)
#Target: Elf (Gilgalad) BISA, Manusia (Elendil) GAGAL.

#Karena kita tidak bisa ubah jam, kita ubah rule-nya seolah-olah Elf boleh akses "Kapan Saja" dan Manusia "Tidak Pernah".

#Reset Rule Palantir:

iptables -F
Pasang Rule Manipulasi (Khusus Screenshot):

# Elf: Buka Full 24 Jam (Agar tes BERHASIL)
iptables -A INPUT -p tcp --dport 80 -s 192.221.1.0/25 -m time --timestart 00:00 --timestop 23:59 -j ACCEPT

# Manusia: Kasih jam ngawur (04:00-04:01) (Agar tes GAGAL)
# Asumsi jam asli laptop Anda bukan jam 4 pagi
iptables -A INPUT -p tcp --dport 80 -s 192.221.0.0/24 -m time --timestart 04:00 --timestop 04:01 -j ACCEPT
iptables -A INPUT -p tcp --dport 80 -s 192.221.1.192/26 -m time --timestart 04:00 --timestop 04:01 -j ACCEPT

# Blokir Sisanya
iptables -A INPUT -p tcp --dport 80 -j DROP
Lakukan Tes:

Gilgalad: curl 192.221.2.10 -> Berhasil (Screenshot: "Akses Elf Pukul 10.00").

Elendil: curl 192.221.2.10 -> Gagal/Timeout (Screenshot: "Akses Manusia Pukul 10.00 Ditolak").




#Skenario 2: Simulasi "Malam Hari" (Jam 20.00)
#Target: Elf (Gilgalad) GAGAL, Manusia (Elendil) BISA.

#Reset Rule lagi:

iptables -F

#Pasang Rule Manipulasi:
# Elf: Kasih jam ngawur (Agar tes GAGAL)
iptables -A INPUT -p tcp --dport 80 -s 192.221.1.0/25 -m time --timestart 04:00 --timestop 04:01 -j ACCEPT

# Manusia: Buka Full 24 Jam (Agar tes BERHASIL)
iptables -A INPUT -p tcp --dport 80 -s 192.221.0.0/24 -m time --timestart 00:00 --timestop 23:59 -j ACCEPT
iptables -A INPUT -p tcp --dport 80 -s 192.221.1.192/26 -m time --timestart 00:00 --timestop 23:59 -j ACCEPT

# Blokir Sisanya
iptables -A INPUT -p tcp --dport 80 -j DROP

Lakukan Tes:

Gilgalad: curl 192.221.2.10 -> Gagal/Timeout (Screenshot: "Akses Elf Pukul 20.00 Ditolak").

Elendil: curl 192.221.2.10 -> Berhasil (Screenshot: "Akses Manusia Pukul 20.00").





# Kembalikan ke Konfigurasi Soal (Untuk Laporan)
# 1. Reset
iptables -F

# 2. Rule Asli Soal
# Elf (07-15)
iptables -A INPUT -p tcp --dport 80 -s 192.221.1.0/25 -m time --timestart 07:00 --timestop 15:00 -j ACCEPT

# Manusia (17-23)
iptables -A INPUT -p tcp --dport 80 -s 192.221.0.0/24 -m time --timestart 17:00 --timestop 23:00 -j ACCEPT
iptables -A INPUT -p tcp --dport 80 -s 192.221.1.192/26 -m time --timestart 17:00 --timestop 23:00 -j ACCEPT

# Blokir Sisa
iptables -A INPUT -p tcp --dport 80 -j DROP
# Penjelasan karena GNS3 membaca jam Hardware Host (Laptop) dan tidak bisa dimanipulasi dengan date -s untuk firewall, saya mensimulasikan kegagalan/keberhasilan dengan memodifikasi range waktu pada rule saat pengambilan screenshot."