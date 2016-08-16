# Sequence of operation

All manual step descripted here are executed at once using the RUNALL.sh script

## 1. Cleanup output of previous run

* SCRIPT: "cleanup-var.sh"
* INPUT : NONE
* OUTPUT: NONE

## 2. Activate network connected devices

* SCRIPT: "arp-activate.sh"
* INPUT : "etc/arp-network-ranges"
* USES  : https://zmap.io/
        ZMap is an open-source network scanner that enables researchers to easily perform Internet-wide network studies
* OUTPUT: "var/zmap-<for all networks>"

## 3. Retreive ARP information from routing core

This step is time sensitive. Routing information can expire and has to obtained quickly after scanning the network.

* SCRIPT: "arp-routing-data.sh"
* USES  : fortigate and arista expect scripts
* OUTPUT: "var/complete.arp-ip"

## 4. Retreive MAC information from all datacenter switches

* SCRIPT: "mac-switches-data.sh"
* USES  : expect scripts
* OUTPUT: "/var/switches/<brand><name>

## 5. Remove uplink ports from MAC information

* SCRIPT: "mac-switches-data-stripuplinks.sh"
* OUTPUT: Removes information from "/var/switches/<brand><name>" files

## 6. Create CSV output and add hostnames from DNS

* SCRIPT: "switchport-discovery-csv.py"
* CALL  : 

```bash
echo "DEVICE;IPv4;MAC;SWITCH;VLAN;PORT;SWITCH;VLAN;PORT;SWITCH;VLAN;PORT;SWITCH;VLAN;PORT" > ~/switchport-discovery/var/switchport-discovery.csv ; sort -u ~/switchport-discovery/var/complete.arp-ip | ./try.py | grep -Ev "[dl][0-9]{5}\.directory.intra" | grep -Ev "[dl][0-9]{5}\.deltares.nl" | grep -v "^rtr_" | grep -v "xtr.deltares.nl" | grep -v "^wag" | grep -v "^[gp]sw" | grep -v "^vrrp" | grep -v "No Reverse" >> ~/switchport-discovery/var/switchport-discovery.csv ; scp ~/switchport-discovery/var/switchport-discovery.csv logch_l@h6:~/
```

* OUTPUT: "var/switchport-discovery.csv"
