import scapy.all as scapy 

scapy.send(scapy.IP(dst="192.168.1.1",options="\x02\x27"+"X"*38)/scapy.TCP())

scapy.sr1(scapy.IP(dst="192.168.1.1")/scapy.TCP())


scapy.sr1(scapy.IP(dst="192.168.8.1")/scapy.ICMP())


scapy.sr( scapy.IP(dst="192.168.1.2", ttl=(10,20))/scapy.TCP(sport=scapy.RandShort()) )