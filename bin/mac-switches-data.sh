#!/bin/bash
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
# Authors       Leroy van Logchem ( lr.vanlogchem@gmail.com / leroy.vanlogchem@deltares.nl )
#               Paul Vlenterie    ( paul.vlenterie@deltares.nl                             )
# Create date   Aug 2016
# Description   Retrieve all mac information from switch ports
#               Compatible with Cisco, Arista and DLink
#


source "include.sh"

OUTPUT="$ROOT/var/switches/"
LOG="$ROOT/log/"

exec 2>$LOG/error.log

/bin/rm $OUTPUT/empty/*
# use the switch-lists in: $ROOT/etc/switches/
# 3com  arista  cisco  dlink  dlink-1210  dlink-telnet  routers
# use the scripts in: $ROOT/bin/expect-scripts/
# arp-arista.exp  arp-fortigate.exp  mac-3com.exp  mac-arista.exp  mac-DGS1210.exp  mac-dlink.exp  mac-Dlink-telnet.exp  vlan-arista.exp
# output format for mac-table: vlan, mac, port
# READ MAC TABLE from arista switches 
#
/bin/rm $OUTPUT/arista-*
for i in $(cat $ROOT/etc/switches/arista)
do
	$ROOT/bin/expect-scripts/mac-arista.exp $i | grep -i "DYNAMIC" | awk '{print $1" "$2" "$4}' > $OUTPUT/arista-$i &
done
wait # expects are still running in the background
#
# READ MAC TABLE from cisco switches
#
/bin/rm $OUTPUT/cisco-*
for i in $(cat $ROOT/etc/switches/cisco)
do
        $ROOT/bin/expect-scripts/mac-arista.exp $i | grep -i "DYNAMIC" | awk '{print $1" "$2" "$4}' > $OUTPUT/cisco-$i &
done
wait # expects are still running in the background
#
# READ MAC TABLE from D-Link switches
#
/bin/rm $OUTPUT/dlink-*
for i in $(cat $ROOT/etc/switches/dlink)
do
        $ROOT/bin/expect-scripts/mac-dlink.exp $i | grep -i "DYNAMIC" | awk '{print $2" "$4" "$5}' > $OUTPUT/dlink-$i &
done
wait # expects are still running in the background
#
# READ MAC TABLE from D-Link POE switches
#
/bin/rm $OUTPUT/dlinkp-*
for i in $(cat $ROOT/etc/switches/dlink-poe)
do
        $ROOT/bin/expect-scripts/mac-dlink.exp $i | grep -i "DYNAMIC" | awk '{print $1" "$3" "$4}' > $OUTPUT/dlink-$i &
done
wait # expects are still running in the background
#
# READ MAC TABLE from D-Link-telnet switch
#
/bin/rm $OUTPUT/dlinkt-*
for i in $(cat $ROOT/etc/switches/dlink-telnet)
do
        $ROOT/bin/expect-scripts/mac-Dlink-telnet.exp $i | grep -i "DYNAMIC" |sed -e 's/^[^M \t]*//' |awk '{print $1" "$2" "$3}' > $OUTPUT/dlinkt-$i &
done
wait # expects are still running in the background
#
# READ MAC TABLE from D-Link-1210 switch
#
for i in $(cat $ROOT/etc/switches/dlink-1210)
do
        $ROOT/bin/expect-scripts/mac-DGS1210.exp $i | grep -i "Learn" | awk '{print $1" "$2" "$4}' > $OUTPUT/dlink1-$i &
done
wait # expects are still running in the background
#
# READ MAC TABLE from 3Com switch
#
/bin/rm $OUTPUT/3com-*
for i in $(cat $ROOT/etc/switches/3com)
do
        $ROOT/bin/expect-scripts/mac-3com.exp $i | grep -i "Learn" | awk '{print $2" "$1" "$4}' > $OUTPUT/3com-$i &
done
wait # expects are still running in the background

#
# Remove switch output not containing any information
#
/bin/find $OUTPUT -size 0 -exec /bin/mv -t $OUTPUT/empty/ {} \+
