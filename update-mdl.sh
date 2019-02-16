#!/bin/bash

LIST1="http://www.malwaredomainlist.com/hostslist/ip.txt"
LIST2="http://www.malwaredomainlist.com/mdlcsv.php"

main(){
	if [ -f ./mdl.list ]; then
		rm ./mdl.list
	fi

	wget -O ip.list1 $1
	wget -O ip.list2 $2

	sed -e "s/\r//g" ip.list1 >> mdl.list
	grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' ip.list2 >> mdl.list

	sort -n mdl.list | uniq -c | sort -n | awk '{ $1=$1; $2=$2; print $2, 1, $1 }' | awk '$3>127{$3=127}3' | sed -e "s/ /,/g" > tempfile.holder
	cat tempfile.holder > mdl.list
	sed -i '/127.0.0.1/d' mdl.list
}

cleanup(){
	rm ./ip.list1 ./ip.list2 ./tempfile.holder
}

main $LIST1 $LIST2
cleanup
