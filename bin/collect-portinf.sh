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
# Description   Collect information from all switch ports
#               Compatible with Cisco, Arista and DLink
#


source "include.sh"

OUTPUT="$ROOT/var/portinfo"
LOG="$ROOT/log/"

exec 2>$LOG/error.log

/bin/rm $OUTPUT/empty/*
# use the switch-lists in: $ROOT/etc/switches/
# 3com  arista  cisco  dlink  dlink-1210  dlink-telnet  routers
# use the scripts in: $ROOT/bin/expect-scripts/
# collect-portinfo-arista.exp
# READ Version, LLDP info and Portstatus from arista switches 
#
/bin/rm $OUTPUT/info-arista-*
for i in $(cat $ROOT/etc/switches/arista)
do
	$ROOT/bin/expect-scripts/collect-portinfo-arista.exp $i > $OUTPUT/info-arista-$i /
done
wait # expects are still running in the background
#
# READ INFORMATION from cisco switches
#
/bin/rm $OUTPUT/info-cisco-*
for i in $(cat $ROOT/etc/switches/cisco)
do
        $ROOT/bin/expect-scripts/collect-portinfo-arista.exp $i > $OUTPUT/info-cisco-$i &
done
wait # expects are still running in the background
#
# READ INFORMATION from D-Link switches
#
/bin/rm $OUTPUT/info-dlink-*
for i in $(cat $ROOT/etc/switches/dlink-new)
do
        $ROOT/bin/expect-scripts/collect-portinfo-dlink.exp $i > $OUTPUT/info-dlink-$i &
done
wait # expects are still running in the background
#
# READ INFORMATION from D-Link-telnet switch
#
/bin/rm $OUTPUT/info-dlinkt-*
for i in $(cat $ROOT/etc/switches/dlink-telnet)
do
        $ROOT/bin/expect-scripts/collect-portinfo-Dlink-telnet.exp > $OUTPUT/info-dlinkt-$i &
done
wait # expects are still running in the background
#
# READ INFORMATION from D-Link-1210 switch
#
for i in $(cat $ROOT/etc/switches/dlink-1210)
do
        $ROOT/bin/expect-scripts/collect-portinfo-DGS1210.exp $i > $OUTPUT/info-dlink1-$i &
done
wait # expects are still running in the background
#
# READ INFORMATION from 3Com switch
#
/bin/rm $OUTPUT/info-3com-*
for i in $(cat $ROOT/etc/switches/3com)
do
        $ROOT/bin/expect-scripts/collect-portinfo-3com.exp $i > $OUTPUT/info-3com-$i &
done
wait # expects are still running in the background
#
