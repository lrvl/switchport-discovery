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
# Description   Retrieve live arp routing information from core switches
#

source "include.sh"

OUTPUT="$ROOT/var/"
LOG="$ROOT/log/"

exec 2>$LOG/error.log

/bin/rm $OUTPUT/arp-ip-*

#
# READ ARP TABLE WITH IPv4 INFORMATION FROM FORTIGATE
#
$ROOT/bin/expect-scripts/arp-fortigate.exp | grep ':.. ' | awk '{print $1" "$3}' > $OUTPUT/arp-ip-fortigate
#
# READ ARP TABLES FROM ARISTA ROUTING SWITCHES
#
for i in $(cat $ROOT/etc/switches/routers)
do
	$ROOT/bin/expect-scripts/arp-arista.exp $i | grep -i "vlan" | awk '{print $1" "$3}' > $OUTPUT/arp-ip-$i &
done
wait # expects are still running in the background

#
# MERGE ALL OUTPUT INTO ONE MAC-IP TABLE ( Will be used by Python )
# 

cat $OUTPUT/arp-ip-* | sort -u >> $OUTPUT/complete.arp-ip

