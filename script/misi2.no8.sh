#di osgiliath
# 1. Hapus rule lama jika ada (agar tidak double)
iptables -t nat -D PREROUTING -s 192.221.2.26 -d 192.221.2.0/29 -j DNAT --to-destination 192.221.2.18 2>/dev/null

# 2. Pasang Rule DNAT
# "Jika dari Vilya (2.26) mau ke Subnet Khamul (2.0/29), BELOKKAN ke IronHills (2.18)"
iptables -t nat -A PREROUTING -s 192.221.2.26 -d 192.221.2.0/29 -j DNAT --to-destination 192.221.2.18


#di ironhilis
# Masukkan Vilya (192.221.2.26) ke daftar yang boleh masuk (CEK_WAKTU)
# Kita pakai -I (Insert) agar ditaruh di atas sebelum rule DROP
iptables -I CEK_WAKTU 1 -s 192.221.2.26 -j ACCEPT

#di vilya
# 1. Cek Koneksi (Harus Succeeded/Open)
nc -zv 192.221.2.2 80

# 2. Cek Konten (Harus muncul Welcome to IronHills)
printf "GET / HTTP/1.0\r\n\r\n" | nc 192.221.2.2 80