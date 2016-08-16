INPUTPATH="/root/network-discovery/var/switches/"

for i in $(ls $INPUTPATH/arista-*) 
do
	echo ${i##*/}
	cat $i | ./switchport-discovery.py ${i##*/}
	echo
done

for i in $(ls $INPUTPATH/cisco-*) 
do
	echo ${i##*/}
	cat $i | ./switchport-discovery.py ${i##*/}
	echo
done

for i in $(ls $INPUTPATH/dlink-*) 
do
	echo ${i##*/}
	cat $i | ./switchport-discovery.py ${i##*/}
	echo
done

for i in $(ls $INPUTPATH/3com-*) 
do
	echo ${i##*/}
	cat $i | ./switchport-discovery.py ${i##*/}
	echo
done
