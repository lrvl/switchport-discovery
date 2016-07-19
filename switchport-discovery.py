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
import pprint
import sys
import re
import json
import socket
import os.path
from netaddr import *
from collections import defaultdict  # available in Python 2.5 and newer

dict_switches   = defaultdict(lambda: defaultdict(str))
dict_mac2ip	= {}
DEBUG           = False
DEBUGDICT       = False

# Requires input from expect output which reads switch mac tables:
# cat arista-gsw10wgc | awk '{print $1,$2,$4}'

if os.path.isfile("switches_json.txt"):
	dict_switches.update(json.load(file('switches_json.txt','r')))

pprint.pprint(dict_switches)
#sys.exit()

def get_arp_table():
    with open('/proc/net/arp') as arpt:
	for line in arpt:
		arpraw_array	= line.split()
		mac		= arpraw_array[3].upper()
		ipv4		= arpraw_array[0].upper()
		dict_mac2ip[mac]= ipv4

get_arp_table()

if DEBUG:
	pprint.pprint(dict_mac2ip)
	print dict_mac2ip['00:1C:73:0F:78:A1']
	print dict_mac2ip['BC:F6:85:03:EA:5E']

if len(sys.argv) > 1:
        switchname     = sys.argv[1]

input = sys.stdin
for line in input:
        line			= line.strip()
        swrawinput_array	= line.split(' ',-1)

	# normalize MAC address input to IEEE EUI (Extended Unique Identifier)
	mac			= str(EUI(str(swrawinput_array[1]))).replace("-",':')
#        print mac

	port			= str(swrawinput_array[2])
	vlan			= str(swrawinput_array[0])
	# Has the dictionary key been initialized before?
        if port not in dict_switches:
                dict_switches[switchname][port]		= defaultdict()
                dict_switches[switchname][port]["mac"]	= str(mac)
                dict_switches[switchname][port]["vlan"]	= str(vlan)
		try:
			dict_switches[switchname][port]["ipv4"]		= dict_mac2ip[str(mac)]
			dict_switches[switchname][port]["hostname"]	= socket.gethostbyaddr(dict_switches[switchname][port]["ipv4"])[0]
		except KeyError:
			dict_switches[switchname][port]["ipv4"]		= "Unknown in ARP table"
                	dict_switches[switchname][port]["hostname"]	= "Unknown"
                if DEBUGDICT:
                        print '-' * 80
                        print "Dictionary has been initialized"
                        print '-' * 80
                        pprint.pprint(dict_switches)
                        print '-' * 80
			pprint.pprint(swrawinput_array[2])

	
# Sort the key on numerical values if possible
def get_key(key):
        try:
                return int(key)
        except ValueError:
                return key


for key,value in dict_switches.items():
        sys.stdout.write(key)
        for k2,v2 in sorted(value.items(), key=lambda t: get_key(t[0])):
                sys.stdout.write(',')
                # The output is using GB
                sys.stdout.write(str(v2))
        sys.stdout.write("\n")

print " "
json.dump(dict_switches, file('switches_json.txt','w'))
