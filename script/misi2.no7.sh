#di ironhilis
date -s "2025-11-29 10:00:00"

# Taruh rule ini di baris pertama (-I INPUT 1)
# Artinya: Jika protokol TCP port 80, dan koneksi dari IP yang sama > 3, maka TOLAK (REJECT).
iptables -I INPUT 1 -p tcp --syn --dport 80 -m connlimit --connlimit-above 3 -j REJECT

# Tes dari Elendil:
for i in {1..10}; do curl -I 192.221.2.18 & done

#harusnya hasilnya: html
