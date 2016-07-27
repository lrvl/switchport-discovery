# switchport-discovery
Switch port Discovery : Complement port information with IP,VLAN and HOSTNAME information

## Input Requirements 

* The output of the switch port information
  * Command for Arista : sh mac address-table
  * Command for Cisco  : sh fdb
  * Command for D-Link : sh fdb
  * Command for 3Com   : disp mac-address
  
## Output

* The output is JSON (JavaScript Object Notation), the lightweight data-interchange format

## Development status

- [X] Handles switch brands Arista, Cisco, D-Link and 3Com
- [X] Match   IPv4 to MAC address
- [X] Resolve IPv4 to Hostname
- [X] Include VLAN information
- [X] Output to JSON format
- [ ] Output to CSV  format ( for Excel reports in SharePoint )

