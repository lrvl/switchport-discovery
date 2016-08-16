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
# Description	Detect and remove uplink port information from MAC tables
#               Compatible with Cisco, Arista and DLink
#

source "include.sh"

OUTPUT="$ROOT/var/switches"
#LOG="$ROOT/log/"
#exec 2>$LOG/error.log

MACTOTAL=0

for SWITCH in $OUTPUT/$2*
do
	[[ -e "$SWITCH" ]] || break # if no input files are available
	re='^[0-9]+$'
	# Determine the port with the most macs (Only returns one port!)
	for y in $( (awk '{print $3}' | sort | uniq -c | sort -n -k 1 -r | head -1) < "$SWITCH")
	do
		if [ -z "$MACS" ] ; then
			MACS=$y
			continue
		fi
		
		if [ -z "$PORT" ] ; then
			PORT=$y
		fi
	done
	if (( MACS > $1 )) ; then
		PORTSEDFORMAT=$(echo "$PORT" | sed 's#:#\\:#g' | sed 's#/#\\/#g')
		#echo "SWITCH=$SWITCH UPLINKPORT=$PORTSEDFORMAT MACS=$MACS"
		# Actual removal of lines related to the port with many MACs
		sed -r -i "/\s$PORTSEDFORMAT$/d" "$SWITCH"
		MACTOTAL=$(( $MACTOTAL + $MACS ))
	fi
	# Reset
	MACS=
	PORT=
done

echo "MACTOTAL=$MACTOTAL"
