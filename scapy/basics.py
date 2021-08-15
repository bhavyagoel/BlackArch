import scapy.all as scapy
from scapy import * 

alpha = scapy.IP(dst = "www.google.com", id = 0x42)
alpha.ttl = 12
beta = scapy.TCP(dport=[22, 23, 25, 80, 443])

gamma = alpha/ beta
print([gamma])

# I want a broadcast MAC address, and IP payload to ketchup.com
# and to mayo.com, TTL value from 1 to 9, and an UDP payload.
# ff:ff:ff:ff:ff:ff is a special reserved mac for broadcast

alpha = scapy.Ether(dst="ff:ff:ff:ff:ff:ff")/scapy.IP(dst=["ketchup.com", "mayo.com"], ttl=(1,9))/scapy.UDP()
print([alpha])


alpha = scapy.IP(dst="192.168.1", ttl=12)/scapy.UDP(dport=123)
print([alpha])
print(alpha.sprintf("The source is %IP.src%"))
f = lambda x: x.sprintf("dst=%IP.dst% proto=%IP.proto% dport=%UDP.dport%")
print([f(alpha)])

beta = scapy.IP(dst="192.168.1")/scapy.ICMP()
print([f(beta)])


f = lambda x: x.sprintf("dst=%IP.dst% proto=%IP.proto%{UDP: dport=%UDP.dport%}")
print(f(alpha))
print(f(beta))