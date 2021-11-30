# import scapy.all as scapy 
from scapy.all import *

ip = IP(dst = "www.google.com")/TCP(dport=53, flags='S')

print(list(ip))
print([p for p in ip])

# send(IP(dst='192.168.1.2')/TCP(dport=53, flags='S'), loop = 1)

print(raw(IP()))
# print(IP(_))

p = sr1(IP(dst="www.google.com")/TCP()/"Hello World")
print(list(p))
print(p.show())