# Hello everyone 
# I will be demonstrating some of the basics command of scapy, along with packets sending and receiving using the same
# I will be using scapy library and wireshark tool for this demonstration

# You can install scapy using - sudo pacman -S python-scapy 
# You can install wireshark using blackarch keyring - sudo pacman -S wireshark-qt


# Importing the required libraries 
import scapy.all as scapy 

# Now I will load the virtual environment for the demonstration purpose

# Creating a basic IP using Scapy having destination at google and id as 0x42, which is hex for 66

alpha = scapy.IP(dst="www.google.com", id=0x42)
# configuring talk to time as 12
alpha.ttl = 12

# Crating a TCP layer with destination ports as [22, 33, 25, 80, 443]

beta = scapy.TCP(dport=[22, 23, 25, 80, 443])

# Stacking the IP layer and the TCP layer
gamma = alpha/beta

print([gamma])

# [<IP  id=66 frag=0 ttl=12 proto=tcp dst=Net("www.google.com/32") |<TCP  dport=['ssh', 'telnet', 'smtp', 'www_http', 'https'] |>>]

# Now I want to broadcast MAC address, and IP payload to ketchup.com and to mayo.com, TTL value range from 1 to 9
# and an UDP payload

# I will use ff:ff:ff:ff:ff as the MAC, as it is a speacial mac address reserved for broadcast purpose

alpha = scapy.Ether(dst="ff:ff:ff:ff:ff")/scapy.IP(dst=["ketchup.com", "mayo.com"], ttl=(1,9))/scapy.UDP()

print([alpha])

# [<Ether  dst=ff:ff:ff:ff:ff type=IPv4 |<IP  frag=0 ttl=(1, 9) proto=udp dst=[Net("ketchup.com/32"), Net("mayo.com/32")] |<UDP  |>>>]

# Now I will demonstrate sending packets, which can be verified using wireshark 



scapy.sr1(scapy.IP(dst="192.168.1.1")/scapy.TCP())


scapy.sr(scapy.IP(dst="192.168.8.1", ttl=(10,20))/scapy.TCP(sport=scapy.RandShort()))