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
# Create date   Jul 2016
# Description   Parse switch mac tables in order to add IPv4 and hostnames
#               Compatible with Cisco, Arista and DLink
#

source "include.sh"

OUTPUT="$ROOT/var/"
LOG="$ROOT/log/"

exec 2>$LOG/error.log

# use the range-lists in: $ROOT/etc/
#
for i in $(grep -v "^#" $ROOT/etc/arp-network-ranges)
do
	ZMAPLOG=$(echo "zmap-$i" | tr '.' '-' | tr '/' '_')
	echo "Starting ZMAP scan for network $i - Output to $OUTPUT$ZMAPLOG.txt"
	zmap --probe-module=icmp_echoscan  $i -G 00:1c:73:00:ca:fe -B 10M -o "$OUTPUT$ZMAPLOG.txt"
	./arp-routing-data.sh
done
