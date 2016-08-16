cat dlink-xsw03wgn | grep vlan | awk '{print $1,$3,$4}' | ./switchport-discovery.py dlink-xsw03wgn
more switches_json.txt
