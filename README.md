# Jarkom-Modul-5-2025-IT-20
**Laporan Resmi Praktikum Modul 5 — Komunikasi Data & Jaringan Komputer 2025**

## Daftar Anggota

| Nama                  | NRP        |
|-----------------------|------------|
| Zahra Khaalishah      | 5027241070 |
| Dimas Muhammad Putra  | 5027241076 |

---

## Misi 1: Memetakan Medan Perang (Infrastruktur)

- Soal No 1: Identifikasi Perangkat & Jumlah Host
[cite_start]Berdasarkan topologi dan kebutuhan soal, berikut adalah identifikasi perangkat yang digunakan [cite: 86-93]:

* **Server:**
    * **Narya:** DNS Server
    * **Vilya:** DHCP Server
    * **Palantir & IronHills:** Web Server
* **Client (Host):**
    * **Elendil:** 200 Host
    * **Gilgalad:** 100 Host
    * **Durin:** 50 Host
    * **Isildur:** 30 Host
    * **Cirdan:** 20 Host
    * **Khamul:** 5 Host

- Soal No 2: Subnetting (VLSM) & Pohon Subnet
Berikut adalah hasil perhitungan subnetting menggunakan metode VLSM dan visualisasi pohon subnet (Subnet Tree).

**Tabel VLSM:**
<img src="https://github.com/user-attachments/assets/3d097d5f-0e1f-4013-a3c1-3a8a000d8f60" alt="Tabel VLSM" width="100%">

**Pohon Subnet (Subnet Tree):**
<img src="https://github.com/user-attachments/assets/8e7c8639-b265-4a07-b304-4ff5b1bcfb73" alt="Subnet Tree" width="100%">

- Soal No 3: Konfigurasi Routing
Melakukan konfigurasi IP address pada setiap interface dan routing statis agar semua node dapat saling terhubung.

```
#node osgiliath
auto lo
iface lo inet loopback

# --- INTERNET (ETH0) ---
# Gunakan DHCP agar otomatis dapat koneksi dari Cloud GNS3
auto eth0
iface eth0 inet dhcp

# --- JALUR DALAM ---
# Ke Rivendell (Tengah)
auto eth1
iface eth1 inet static
    address 192.221.2.37
    netmask 255.255.255.252

# Ke Moria (Kiri)
auto eth2
iface eth2 inet static
    address 192.221.2.33
    netmask 255.255.255.252

# Ke Minastir (Kanan)
auto eth3
iface eth3 inet static
    address 192.221.2.41
    netmask 255.255.255.252

# --- ROUTING STATIS ---
# Ke Kiri (Area Moria: IronHills, Durin, Khamul)
up ip route add 192.221.2.16/29 via 192.221.2.34
up ip route add 192.221.2.48/30 via 192.221.2.34
up ip route add 192.221.1.128/26 via 192.221.2.34
up ip route add 192.221.2.0/29 via 192.221.2.34

# Ke Tengah (Area Rivendell: Vilya, Narya)
up ip route add 192.221.2.24/29 via 192.221.2.38

# Ke Kanan (Area Minastir: Elendil, Pelargir, Palantir, Isildur, Anduin, Gilgalad)
up ip route add 192.221.0.0/24 via 192.221.2.42
up ip route add 192.221.2.44/30 via 192.221.2.42
up ip route add 192.221.2.8/29 via 192.221.2.42
up ip route add 192.221.1.192/26 via 192.221.2.42
up ip route add 192.221.2.52/30 via 192.221.2.42
up ip route add 192.221.1.0/25 via 192.221.2.42

# Forwarding Wajib
up echo 1 > /proc/sys/net/ipv4/ip_forward
up iptables -t nat -A POSTROUTING -o eth0 -j SNAT --to-source 192.168.122.22

# (Konfigurasi node lainnya: Rivendell, Moria, Minastir, dll. sesuai file script asli)
# ... [Isi file script/misi1_no3.sh lengkap disini] ...
```
- Soal No 4: Konfigurasi Service (DHCP, DNS, Web, Relay)
Instalasi layanan DHCP Server (Vilya), DNS Server (Narya), Web Server (Palantir & IronHills), serta DHCP Relay pada router distribusi.

```

#di node Palantir, IronHills, Narya, Vilya, dan Router Relay
apt-get update

# --- WEB SERVER (Palantir & IronHills) ---
# 1. Install Apache
apt-get install apache2 -y
# 2. Buat file index.html
echo "Welcome to Palantir" > /var/www/html/index.html
# 3. Restart Service
service apache2 restart

# --- DNS SERVER (Narya) ---
apt-get update
apt-get install bind9 -y

# Konfigurasi named.conf.local & db.aliansi (sesuai script)
# ...

service bind9 restart

# --- DHCP SERVER (Vilya) ---
apt-get update
apt-get install isc-dhcp-server -y
# Konfigurasi dhcpd.conf dengan subnet-subnet (sesuai script)
# ...

service isc-dhcp-server restart

# --- DHCP RELAY (Minastir, AnduinBanks, Rivendell, Wilderland) ---
apt-get update
apt-get install isc-dhcp-relay -y
# SERVERS="192.221.2.26"
service isc-dhcp-relay restart
```
## Misi 2: Menemukan Jejak Kegelapan (Security Rules)

- Soal No 1: Akses Internet (NAT)
Agar jaringan Aliansi bisa terhubung ke luar (Internet), konfigurasi routing menggunakan iptables dengan metode SNAT (tanpa MASQUERADE).

```
# Cek dulu IP eth0 dapat berapa
ip a show eth0

# Pasang SNAT (Ganti IP_ETH0 di bawah dgn IP aslinya!)
# Contoh: iptables -t nat -A POSTROUTING -o eth0 -j SNAT --to-source 192.168.122.50
iptables -t nat -A POSTROUTING -o eth0 -j SNAT --to-source [MASUKKAN_IP_ETH0_DISINI]
```
- Soal No 2: Keamanan Vilya (Ping Drop)
Vilya menyimpan data vital, sehingga tidak boleh di-PING oleh perangkat lain, namun Vilya tetap bisa melakukan PING ke luar.
```
# 1. Izinkan trafik balasan (agar Vilya bisa ping keluar dan menerima reply)
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

# 2. Blokir semua Ping (ICMP Echo Request) yang masuk
iptables -A INPUT -p icmp --icmp-type echo-request -j DROP
```
- Soal No 3: Keamanan DNS Narya
Hanya Vilya yang diizinkan mengakses port DNS (53) di Narya. Akses dari IP lain harus diblokir.

```
#2. Pasang Rule di NARYA (Server Target)

# 1. Izinkan Vilya (IP 192.221.2.26) masuk ke port 53
iptables -A INPUT -p udp --dport 53 -s 192.221.2.26 -j ACCEPT
iptables -A INPUT -p tcp --dport 53 -s 192.221.2.26 -j ACCEPT

# 2. Blokir akses port 53 dari IP lain (selain Vilya)
iptables -A INPUT -p udp --dport 53 -j DROP
iptables -A INPUT -p tcp --dport 53 -j DROP
```
- Soal No 4: Pembatasan Waktu IronHills
Akses ke IronHills dibatasi hanya pada Akhir Pekan (Sabtu & Minggu) dan hanya untuk Faksi Kurcaci & Manusia (Durin, Khamul, Elendil, Isildur).


```
#di ironhilis

# 1. Bersihkan Chain & Buat Chain Baru
iptables -F CEK_WAKTU
iptables -N CEK_WAKTU

# 2. Sambungkan Chain tersebut ke pintu masuk HTTP (Port 80)
iptables -A INPUT -p tcp --dport 80 -j CEK_WAKTU

# 3. Limit Koneksi (Untuk soal no 7, taruh paling atas)
iptables -A CEK_WAKTU -p tcp --syn -m connlimit --connlimit-above 3 -j REJECT

# 4. Blokir Hari Kerja (Senin - Jumat)
iptables -A CEK_WAKTU -m time --weekdays Mon,Tue,Wed,Thu,Fri -j DROP

# 5. Whitelist Faksi (Durin, Khamul, Elendil, Isildur)
iptables -A CEK_WAKTU -s 192.221.1.128/26 -j ACCEPT
iptables -A CEK_WAKTU -s 192.221.2.0/29 -j ACCEPT
iptables -A CEK_WAKTU -s 192.221.0.0/24 -j ACCEPT
iptables -A CEK_WAKTU -s 192.221.1.192/26 -j ACCEPT

# 6. Blokir Sisanya
iptables -A CEK_WAKTU -j DROP
```
Soal No 5: Akses Bertingkat Palantir
Mengatur jam akses yang berbeda untuk Faksi Elf (07.00-15.00) dan Faksi Manusia (17.00-23.00) ke server Palantir.

```
# Rule Asli Soal (Konfigurasi Laporan)

# Elf (07-15)
iptables -A INPUT -p tcp --dport 80 -s 192.221.1.0/25 -m time --timestart 07:00 --timestop 15:00 -j ACCEPT

# Manusia (17-23)
iptables -A INPUT -p tcp --dport 80 -s 192.221.0.0/24 -m time --timestart 17:00 --timestop 23:00 -j ACCEPT
iptables -A INPUT -p tcp --dport 80 -s 192.221.1.192/26 -m time --timestart 17:00 --timestop 23:00 -j ACCEPT

# Blokir Sisa
iptables -A INPUT -p tcp --dport 80 -j DROP
```
- Soal No 6: Proteksi Port Scan
Mendeteksi dan memblokir upaya port scanning (scan > 15 port dalam 20 detik) serta mencatatnya dalam log sistem.

```
#di palantir
# 1. Cek: Jika hit > 4 dalam 60 detik (parameter disesuaikan saat tes), lempar ke PORT_SCAN
iptables -A INPUT -m recent --name attacker --update --seconds 60 --hitcount 4 -j PORT_SCAN

# 2. Tandai paket baru
iptables -A INPUT -m recent --name attacker --set

# 3. Izinkan trafik normal sisa
iptables -A INPUT -j ACCEPT
```
- Soal No 7: Limitasi Koneksi (Stress Test)
Mencegah overload pada IronHills dengan membatasi maksimal 3 koneksi aktif secara bersamaan dari satu IP.
```
( ironhilis )
#Pastikan jam server sesuai (weekend) agar tes berhasil 
date -s "2025-11-29 10:00:00"

#Taruh rule ini di baris pertama (-I INPUT 1)
iptables -I INPUT 1 -p tcp --syn --dport 80 -m connlimit --connlimit-above 3 -j REJECT
```

- Soal No 8: Anomali Trafik (DNAT)
Setiap paket yang dikirim Vilya menuju subnet Khamul akan dibelokkan (Redirect) menuju server IronHills menggunakan DNAT.

```
# osgiliath (Router)
# Jika dari Vilya (2.26) mau ke Subnet Khamul (2.0/29), BELOKKAN ke IronHills (2.18)
iptables -t nat -A PREROUTING -s 192.221.2.26 -d 192.221.2.0/29 -j DNAT --to-destination 192.221.2.18

# ironhilis (Web Server)
# Izinkan Vilya masuk (whitelist di firewall)
iptables -I CEK_WAKTU 1 -s 192.221.2.26 -j ACCEPT
```

## Misi 3: Isolasi Sang Nazgûl

- Soal No 1: Isolasi Khamul
Diketahui bahwa Khamul telah berkhianat. Oleh karena itu, langkah keamanan terakhir adalah memblokir seluruh lalu lintas (trafik) baik yang **masuk** maupun yang **keluar** dari subnet Khamul. Namun, subnet Durin (yang berada di satu jalur routing) harus tetap bisa mengakses jaringan dengan normal.
```
# 1. Blokir trafik yang BERASAL DARI Khamul (Source)
# Menggunakan chain FORWARD karena router hanya meneruskan paket
# -I FORWARD 1: Insert rule di urutan pertama (Top Priority)
iptables -I FORWARD 1 -s 192.221.2.0/29 -j DROP

# 2. Blokir trafik yang MENUJU KE Khamul (Destination)
iptables -I FORWARD 1 -d 192.221.2.0/29 -j DROP

# --- OPSI (Jika ingin melakukan tes/download package) ---
# Hapus rule blokir sementara:
# iptables -D FORWARD -s 192.221.2.0/29 -j DROP
# iptables -D FORWARD -d 192.221.2.0/29 -j DROP

# --- PENGUJIAN ---
# Di Node Khamul:
# ping 8.8.8.8 -> Harus Request Timed Out (RTO) / Destination Host Unreachable
# nc -zv 192.221.2.18 80 -> Harus Timed Out

# Di Node Durin (Tetangga Khamul):
# ping 8.8.8.8 -> Harus Reply (Berhasil)
