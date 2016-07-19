# switchport-discovery
Switch port Discovery : Complement port information with IP,VLAN and HOSTNAME information

## Input Requirements 

* The output of the switch port information
  * Command for Arista : sh mac address-table
  * Command for Cisco  : sh fdb
  
## Output

* The output is JSON (JavaScript Object Notation), the lightweight data-interchange format

## Development status

- [X] Handles switch brands Arista, Cisco, DLink and 3com
- [X] Match   IPv4 to MAC address
- [X] Resolve IPv4 to Hostname
- [X] Include VLAN information
- [ ] Output to JSON format
- [ ] Output to CSV  format ( for Excel reports in SharePoint )

