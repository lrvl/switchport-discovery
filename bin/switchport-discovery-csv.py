#!/opt/python-2.7.12/bin/python2.7
#
# The naive approach to finding the physical location of servers on switches
# Rewrite of switchport-discovery.py started 28 july 2016
#
import time
import pprint
import sys
import re
import json
import socket
import os.path
from netaddr import *
from collections import defaultdict  # available in Python 2.5 and newer
import glob

def ip_to_hostname(ip):
	try:
		return socket.gethostbyaddr(ip)[0]
	except socket.herror:
		# All IPv4 without hostnames should be addressed by ICT Network
		raise ValueError('IPv4 without hostname - this is bad!')

#
# Lookup table so EUI mac conversion is only done once per unique mac
#
macrawlookup = {}

def normalize_mac(macraw):
	try:
		return macrawlookup[macraw]

	except:
		# normalize MAC address input to IEEE EUI (Extended Unique Identifier)
		macrawlookup[macraw] = str(EUI(str(macraw)))
		return macrawlookup[macraw]

def grep(string):
	path = '/root/network-discovery/var/switches/*'
	files = glob.glob(path)
	onswitch = []
	for name in files:
		if not os.path.isfile(name):
			continue
		with open(name,'r') as f:
			for line in f:
				line = line.strip()
				array = line.split(' ',-1)
				macraw = array[1]
				mac = normalize_mac(macraw).replace("-",':')
				if string == mac:
					onswitch.append(os.path.basename(name) + ";" + array[0] + ";" + array[2] + ";")
                                        #onswitch.append(os.path.basename(name) + ";VLAN(" + line.rstrip())

					#print onswitch
					#print "compare to string      = %s" % string
					#print "normal mac from macraw = %s" % mac
					#print "switch basename        = %s" % os.path.basename(name)
					#print "------------------------"
	if len(onswitch) < 1000:
		return ''.join(onswitch)
	else:
		raise ValueError('No single match but many - this is bad!')


input = sys.stdin
for line in input:
        line			= line.strip()
	swrawinput_array        = line.split(' ',-1)
	macraw			= swrawinput_array[1]
	mac			= str(EUI(str(macraw))).replace("-",':')
	if re.match("^00:50:56", mac):
		continue

	ip			= swrawinput_array[0]

	try:
		hostname	= ip_to_hostname(ip)
	except:
		print "No Reverse hostname found for %s" % ip
		continue

	try:
		print "%s;%s;%s;%s" % (hostname,ip,mac,grep(mac))
	except:
		continue


# Call from shell with:
# echo "DEVICE;IPv4;MAC;SWITCH" > try.csv ; sort -u ~/network-discovery/var/complete.arp-ip | ./try.py | grep -Ev "[dl][0-9]{5}\.directory.intra" | grep -Ev "[dl][0-9]{5}\.deltares.nl" | grep -v "^rtr_" | egrep -v "[a-z]{3}[0-9][a-z]{2}[0-9]+" | grep -v "xtr.deltares.nl" | grep -v "^wag" | grep -v "^[gp]sw" | grep -v "^vrrp" >> try.csv ; scp try.csv logch_l@h6:~/
# echo "DEVICE;IPv4;MAC;SWITCH;VLAN;PORT;SWITCH;VLAN;PORT;SWITCH;VLAN;PORT;SWITCH;VLAN;PORT" > try.csv ; sort -u ~/network-discovery/var/complete.arp-ip | ./try.py | grep -Ev "[dl][0-9]{5}\.directory.intra" | grep -Ev "[dl][0-9]{5}\.deltares.nl" | grep -v "^rtr_" | grep -v "xtr.deltares.nl" | grep -v "^wag" | grep -v "^[gp]sw" | grep -v "^vrrp" | grep -v "No Reverse" >> try.csv ; scp try.csv logch_l@h6:~/
