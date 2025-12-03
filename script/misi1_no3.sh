#node osgiliath
auto lo
iface lo inet loopback

# --- INTERNET (ETH0) ---
# Gunakan DHCP agar otomatis dapat koneksi dari Cloud GNS3
auto eth0
iface eth0 inet dhcp

# (Bagian eth0 static yang lama SUDAH SAYA HAPUS agar tidak bentrok)

# --- JALUR DALAM (TIDAK ADA YANG DIUBAH) ---

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

# --- ROUTING STATIS (TIDAK ADA YANG DIUBAH) ---

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



#node rivendell
auto lo
iface lo inet loopback

# Ke Osgiliath
auto eth0
iface eth0 inet static
    address 192.221.2.38
    netmask 255.255.255.252
    gateway 192.221.2.37

# Ke Vilya & Narya
auto eth1
iface eth1 inet static
    address 192.221.2.25
    netmask 255.255.255.248

up echo 1 > /proc/sys/net/ipv4/ip_forward
up echo nameserver 8.8.8.8 > /etc/resolv.conf



#node moria
auto lo
iface lo inet loopback

# Ke Osgiliath
auto eth0
iface eth0 inet static
    address 192.221.2.34
    netmask 255.255.255.252
    gateway 192.221.2.33

# Ke IronHills (Web Server 1)
auto eth1
iface eth1 inet static
    address 192.221.2.17
    netmask 255.255.255.248

# Ke Wilderland
auto eth2
iface eth2 inet static
    address 192.221.2.49
    netmask 255.255.255.252

# Routing ke Bawah (Durin & Khamul)
up ip route add 192.221.1.128/26 via 192.221.2.50
up ip route add 192.221.2.0/29 via 192.221.2.50
up echo 1 > /proc/sys/net/ipv4/ip_forward
up echo nameserver 8.8.8.8 > /etc/resolv.conf


#node minastir
auto lo
iface lo inet loopback

# Ke Osgiliath
auto eth0
iface eth0 inet static
    address 192.221.2.42
    netmask 255.255.255.252
    gateway 192.221.2.41

# Ke Elendil (Switch4)
auto eth1
iface eth1 inet static
    address 192.221.0.1
    netmask 255.255.255.0

# Ke Pelargir
auto eth2
iface eth2 inet static
    address 192.221.2.45
    netmask 255.255.255.252

# Routing ke Bawah (Pelargir Area & Anduin)
up ip route add 192.221.2.52/30 via 192.221.2.46
up ip route add 192.221.2.8/29 via 192.221.2.46
up ip route add 192.221.1.192/26 via 192.221.2.46
up ip route add 192.221.1.0/25 via 192.221.2.46
up echo 1 > /proc/sys/net/ipv4/ip_forward
up echo nameserver 8.8.8.8 > /etc/resolv.conf



#node pelargir
auto lo
iface lo inet loopback

# Ke Minastir
auto eth0
iface eth0 inet static
    address 192.221.2.46
    netmask 255.255.255.252
    gateway 192.221.2.45

# Ke AnduinBanks
auto eth1
iface eth1 inet static
    address 192.221.2.53
    netmask 255.255.255.252

# Ke Palantir (Web Server 2)
auto eth2
iface eth2 inet static
    address 192.221.2.9
    netmask 255.255.255.248

# Ke Isildur (PENTING: Isildur ada di topologi, wajib dikonfig)
auto eth3
iface eth3 inet static
    address 192.221.1.193
    netmask 255.255.255.192

# Routing ke Anduin (Gilgalad)
up ip route add 192.221.1.0/25 via 192.221.2.54
up echo 1 > /proc/sys/net/ipv4/ip_forward
up echo nameserver 8.8.8.8 > /etc/resolv.conf



#node AnduinBanks
auto lo
iface lo inet loopback

# Ke Pelargir
auto eth0
iface eth0 inet static
    address 192.221.2.54
    netmask 255.255.255.252
    gateway 192.221.2.53

# Ke Gilgalad & Cirdan
auto eth1
iface eth1 inet static
    address 192.221.1.1
    netmask 255.255.255.128

up echo 1 > /proc/sys/net/ipv4/ip_forward
up echo nameserver 8.8.8.8 > /etc/resolv.conf



#node winderland
auto lo
iface lo inet loopback

# INTERFACE KE ATAS (Ke Moria) - Asumsi colokan eth0
auto eth0
iface eth0 inet static
    address 192.221.2.50
    netmask 255.255.255.252 
    gateway 192.221.2.49

# INTERFACE KE BAWAH (Ke Durin) - Ubah jadi eth1 (atau eth2 cek kabel di GNS3)
auto eth1
iface eth1 inet static
    address 192.221.1.129
    netmask 255.255.255.192

auto eth2
iface eth2 inet static
    address 192.221.2.2
    netmask 255.255.255.248

up echo nameserver 8.8.8.8 > /etc/resolv.conf



#node palantir
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 192.221.2.10
    netmask 255.255.255.248
    gateway 192.221.2.9
up echo nameserver 8.8.8.8 > /etc/resolv.conf




#node ironhilis
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 192.221.2.18
    netmask 255.255.255.248
    gateway 192.221.2.17

up echo nameserver 8.8.8.8 > /etc/resolv.conf


#node durin
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 192.221.1.130
    netmask 255.255.255.192
    gateway 192.221.1.129   

up echo nameserver 8.8.8.8 > /etc/resolv.conf  



#node khamul
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 192.221.2.3
    netmask 255.255.255.248
    gateway 192.221.2.2

up echo nameserver 8.8.8.8 > /etc/resolv.conf



#node vilya
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 192.221.2.26
    netmask 255.255.255.248
    gateway 192.221.2.25

up echo nameserver 8.8.8.8 > /etc/resolv.conf



#node narya
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 192.221.2.27
    netmask 255.255.255.248
    gateway 192.221.2.25

up echo nameserver 8.8.8.8 > /etc/resolv.conf



#node elendil
auto eth0
iface eth0 inet dhcp


#node isildur
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 192.221.0.3
    netmask 255.255.255.0
    gateway 192.221.0.1

up echo nameserver 8.8.8.8 > /etc/resolv.conf


#node gilgalad
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 192.221.1.2
    netmask 255.255.255.128
    gateway 192.221.1.1

up echo nameserver 8.8.8.8 > /etc/resolv.conf



#node cirdan
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 192.221.1.3
    netmask 255.255.255.128
    gateway 192.221.1.1

up echo nameserver 8.8.8.8 > /etc/resolv.conf







