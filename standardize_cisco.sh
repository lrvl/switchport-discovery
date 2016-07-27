INPUTPATH="/root/network-discovery/var"

for i in $(ls $INPUTPATH/cisco-*) 
do
	echo $i;
	cat $i | ./switchport-discovery.py $i
done
#more switches_json.txt
