# import scapy.all as scapy 
from scapy.all import *

# ip = IP(dst = "www.google.com")

# print(list(ip))
# print([p for p in ip])

sr(IP(dst="192.168.8.1")/TCP(dport=[21,22,23]))

ans.summary()
