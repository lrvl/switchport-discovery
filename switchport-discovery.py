#!/opt/python-2.7.12/bin/python2.7
#
# The software known as Network Discovery is distributed under the following terms:
# Copyright 2016-2016 Leroy van Logchem.
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
#
#   Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
#   Redistributions in binary form must reproduce the above copyright notice,
#   this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
#
#   THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES,
#   INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
#   IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY,
#   OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA,
#   OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
#   OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
# Author        Leroy van Logchem ( lr.vanlogchem@gmail.com / leroy.vanlogchem@deltares.nl )
# Create date   Jul 2016
# Description   Parse switch mac tables in order to add IPv4 and hostnames
#               Compatible with Cisco, Arista and DLink
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

dict_switches   = {}
dict_mac2ip	= {}
DEBUG           = False
DEBUGDICT       = False
DEBUGNOHOST	= False
DEBUGSLOWDOWN	= False
DEBUGVMWARE	= False
DEBUGUPLINKS	= False
DEBUGNOTINARP	= False
vmware		= "00:50:56"	# We focus on Psyhical Addresses, filter VMware
vmware_counter  = 0		# Count the number of VMware addresses encountered 
#
# TO IMPROVE: Filter uplink ports ( static configured at the moment )
#
uplinks		= ['Po110','Po1', 'Gi1/0/48']
uplink_counter  = 0		# Count the number of MAC addresses related to uplinks
notinarp_count  = 0		# Count the number of MAC addresses without IPv4 in the routing tables

# Requires input from expect output which reads switch mac tables:
# cat arista-gsw10wgc | awk '{print $1,$2,$4}'

if os.path.isfile("switches_json.txt"):
	dict_switches.update(json.load(file('switches_json.txt','r')))

def get_arp_table():
	with open('complete.arp-ip') as arpt:
		for line in arpt:
			arpraw_array	= line.split()
			mac		= arpraw_array[1].upper()
			ipv4		= arpraw_array[0].upper()
			if '.' in mac:
				mac = mac.translate(None, '.')
				t = ':'.join(mac[i:i+2] for i in range(0,12,2))
				mac = t
			
                        # One MAC address can be used with multiple aliased interfaces,
                        # so multiple IPv4 addresses can be assigned on our table
			if mac in dict_mac2ip:
				dict_mac2ip[mac].append(ipv4)
			else:
			# At first we just add the IPv4 address as Array
				dict_mac2ip[mac] = [ipv4]

get_arp_table()

#pprint.pprint(dict_mac2ip)
#sys.exit()

def ip_to_hostname(ip):
	try:
		return socket.gethostbyaddr(ip)[0]
	except socket.herror:
# All IPv4 without hostnames should be addressed by ICT Network
		return None,None,None

if DEBUG:
	pprint.pprint(dict_mac2ip)
	print dict_mac2ip['00:1C:73:0F:78:A1']
	print dict_mac2ip['BC:F6:85:03:EA:5E']

if len(sys.argv) < 2:
	sys.exit('Usage: %s <switchvendor-switchname>' % sys.argv[0])

if len(sys.argv) > 1:
        switchname     = sys.argv[1]


input = sys.stdin
for line in input:
        line			= line.strip()
        swrawinput_array	= line.split(' ',-1)

	# normalize MAC address input to IEEE EUI (Extended Unique Identifier)
	mac			= str(EUI(str(swrawinput_array[1]))).replace("-",':')
	if vmware in mac:
		vmware_counter += 1
		continue

	port			= str(swrawinput_array[2])

	if [p for p in uplinks if port in p]:
		uplink_counter += 1
		continue	

	vlan			= str(swrawinput_array[0])

        if switchname not in dict_switches:
		dict_switches[switchname] = defaultdict()

        if port not in dict_switches[switchname]:
		#
		# Add the dictionary for this port
		#
		dict_switches[switchname][port]		= defaultdict()
		dict_switches[switchname][port]["mac"]	= [str(mac)]
		dict_switches[switchname][port]["vlan"] = [str(vlan)]
	else:
		#
		# In this case the port already has been defined
		#
		if vlan not in dict_switches[switchname][port]["vlan"]:
			dict_switches[switchname][port]["vlan"].append(str(vlan))
		if mac not in dict_switches[switchname][port]["mac"]:
			dict_switches[switchname][port]["mac"].append(str(mac))
		
	#
	# Assign ipv4 using the mac2ip dictionary
	#
	try:
		dict_switches[switchname][port]["ipv4"]		= dict_mac2ip[str(mac)]
		dict_switches[switchname][port]["hostname"]	= []
		for ip in dict_switches[switchname][port]["ipv4"]:
			if DEBUGSLOWDOWN:
				time.sleep(0.1)
			dict_switches[switchname][port]["hostname"].append(ip_to_hostname(ip))
			if DEBUGNOHOST:
				if dict_switches[switchname][port]["hostname"][0][0] is None:
					print("Switch=%s Port=%s Problem with IPv4=%s" % (switchname,port,ip))


	#
	# If the ipv4 address is not available in the mac2ip dict define as Unknown
	#
	except KeyError:
		dict_switches[switchname][port]["ipv4"]		= "Unknown in ARP table"
		dict_switches[switchname][port]["hostname"]	= "Unknown"
		notinarp_count += 1

	if DEBUGDICT:
		print '-' * 80
		print "Dictionary has been initialized"
		print '-' * 80
		pprint.pprint(dict_switches)
		print '-' * 80
		pprint.pprint(swrawinput_array[2])

if DEBUGVMWARE:
	print("DEBUG NUMBER OF VMWARE ADDRESSES=%i" % (vmware_counter))

if DEBUGUPLINKS:
	print("DEBUG NUMBER OF UPLINK MAC ADDRESSES=%i" % (uplink_counter))

if DEBUGNOTINARP:
	print("DEBUG NUMBER NOT IN ROUTING ARP TABLE=%i" % (notinarp_count))
	
json.dump(dict_switches, file('switches_json.txt','w'))
