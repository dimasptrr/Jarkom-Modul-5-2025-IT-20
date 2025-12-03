#di ironhilis

# 1. Bersihkan Chain
iptables -F CEK_WAKTU

# 1. Buat Chain Baru (Wajib langkah pertama)
iptables -N CEK_WAKTU

# 2. Sambungkan Chain tersebut ke pintu masuk HTTP (Port 80)
iptables -A INPUT -p tcp --dport 80 -j CEK_WAKTU

# 3. Limit Koneksi (Sesuai soal no 7, taruh paling atas di chain ini)
iptables -A CEK_WAKTU -p tcp --syn -m connlimit --connlimit-above 3 -j REJECT

# 4. Blokir Hari Kerja (Senin - Jumat)
iptables -A CEK_WAKTU -m time --weekdays Mon,Tue,Wed,Thu,Fri -j DROP

# 5. Whitelist Faksi (Durin, Khamul, Elendil, Isildur)
# Izinkan mereka masuk (JIKA bukan hari Senin-Jumat)
iptables -A CEK_WAKTU -s 192.221.1.128/26 -j ACCEPT
iptables -A CEK_WAKTU -s 192.221.2.0/29 -j ACCEPT
iptables -A CEK_WAKTU -s 192.221.0.0/24 -j ACCEPT
iptables -A CEK_WAKTU -s 192.221.1.192/26 -j ACCEPT

# 6. Blokir Sisanya (Elf & Lainnya yang tidak terdaftar)
iptables -A CEK_WAKTU -j DROP

#di ironhilis
date -s "2025-11-26 10:00:00"

#di elendil
curl 192.221.2.18 #hasil: gagal (timeout)

#di ironhilis
date -s "2025-11-29 10:00:00"

#di elendil
curl 192.221.2.18 #hasil: berhasil (ada output HTML)

#di gilgalad
curl 192.221.2.18 #hasil: gagal (timeout)


#jika gagal
iptables -F CEK_WAKTU


# Blokir Hari Minggu (Sun)
iptables -A CEK_WAKTU -m time --weekdays Sun -j DROP

# Whitelist Faksi (Tetap pasang agar logika tidak putus)
iptables -A CEK_WAKTU -s 192.221.1.128/26 -j ACCEPT
iptables -A CEK_WAKTU -s 192.221.2.0/29 -j ACCEPT
iptables -A CEK_WAKTU -s 192.221.0.0/24 -j ACCEPT
iptables -A CEK_WAKTU -s 192.221.1.192/26 -j ACCEPT

# Blokir Sisanya
iptables -A CEK_WAKTU -j DROP


#lalu tes ulang di Elendil
curl 192.221.2.18 #hasil: gagal (timeout)

#Ini karena GNS3 membaca jam laptop asli (Minggu).