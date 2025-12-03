#di node Palantir, IronHills, Narya, Vilya, dan Router Relay (Minastir, AnduinBanks, Rivendell, Wilderland)
apt-get update

# di node Palantir & IronHills

# 1. Install Apache
apt-get install apache2 -y

# 2. Buat file index.html (Halaman Web)
echo "Welcome to Palantir" > /var/www/html/index.html

# 3. Restart Service
service apache2 restart

#di node Narya
apt-get update
apt-get install bind9 -y

nano /etc/bind/named.conf.options

allow-query { any; };

nano /etc/bind/named.conf.local

zone "aliansi.com" {
    type master;
    file "/etc/bind/db.aliansi";
};

nano /etc/bind/db.aliansi

;
; BIND data file for aliansi.com
;
$TTL    604800
@       IN      SOA     aliansi.com. root.aliansi.com. (
                              2         ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
@       IN      NS      aliansi.com.
@       IN      A       192.221.2.27   ; IP Narya
palantir  IN    A       192.221.2.10
ironhills IN    A       192.221.2.18

ln -s /etc/init.d/named /etc/init.d/bind9
service bind9 restart

# di Node VILYA:

apt-get update
apt-get install isc-dhcp-server -y

nano /etc/default/isc-dhcp-server
INTERFACESv4="eth0"

nano /etc/dhcp/dhcpd.conf

# --- GLOBAL SETTINGS ---
default-lease-time 600;
max-lease-time 7200;
option domain-name-servers 192.221.2.27, 8.8.8.8; # DNS Narya & Google
authoritative;

# Subnet Vilya Sendiri (Wajib ada)
subnet 192.221.2.24 netmask 255.255.255.248 {
}

# 1. ELENDIL (Switch 4 - Minastir)
subnet 192.221.0.0 netmask 255.255.255.0 {
    range 192.221.0.10 192.221.0.200;
    option routers 192.221.0.1;
}

# 2. GILGALAD + CIRDAN (Switch 5 - AnduinBanks)
subnet 192.221.1.0 netmask 255.255.255.128 {
    range 192.221.1.10 192.221.1.100;
    option routers 192.221.1.1;
}

# 3. DURIN (Wilderland eth1)
subnet 192.221.1.128 netmask 255.255.255.192 {
    range 192.221.1.135 192.221.1.180;
    option routers 192.221.1.129;
}

# 4. ISILDUR (Pelargir eth3)
subnet 192.221.1.192 netmask 255.255.255.192 {
    range 192.221.1.200 192.221.1.250;
    option routers 192.221.1.193;
}

# 5. KHAMUL (Wilderland eth2)
subnet 192.221.2.0 netmask 255.255.255.248 {
    range 192.221.2.4 192.221.2.6;
    option routers 192.221.2.1;
}

service isc-dhcp-server restart
service isc-dhcp-server status  # Pastikan active (running)


# di node Minastir, AnduinBanks, Rivendell, dan Wilderland (Wajib di Wilderland agar Durin/Khamul dapat IP).
apt-get update
apt-get install isc-dhcp-relay -y

nano /etc/default/isc-dhcp-relay

SERVERS="192.221.2.26"
INTERFACES="eth0 eth1 eth2" # Sesuaikan dengan interface router

service isc-dhcp-relay restart


#cek misal elendil

nano /etc/network/interfaces

auto eth0
iface eth0 inet dhcp