cat cisco-gsw03hk8 | awk '{print $1,$2,$4}' | grep '\.' | ./switchport-discovery.py cisco-gsw03hk8
more switches_json.txt
