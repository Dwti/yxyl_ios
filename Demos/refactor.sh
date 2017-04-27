#!/bin/bash -x
curr_path=`cd $(dirname $0); pwd`
prj_path=$curr_path/YanXiuStudentApp

if ! [ -d "$prj_path" ]; then
	echo "can not find src path"
	exit 1
fi
tmp_path=$curr_path/tmp
if ! [ -d "$tmp_path" ]; then
	mkdir -p $tmp_path
fi
bak_path=$curr_path/bak
if ! [ -d "$bak_path" ]; then
	mkdir -p $bak_path
fi

cd $curr_path

ppid=$$

egrep -roEh 'imageNamed:@"(.*?)"'    ~/gitosc/EXueELian | \
	gsed -r 's/imageNamed:@"(.*)"/\1/g' | sort | uniq > $tmp_path/aa_$ppid

find . -type d -print0 | xargs -0 basename | grep .imageset | \
	sed 's/.imageset//g' | sort | uniq > $tmp_path/bb_$ppid

cat $tmp_path/aa_$ppid $tmp_path/bb_$ppid $tmp_path/bb_$ppid | \
	sort | uniq -c | sort | awk '{ if ($1 == 2) print $2 }' > $tmp_path/todelete_$ppid

gsed -i 's/$/.imageset/' $tmp_path/todelete_$ppid

while read file;
do
	if [ -d "$file" ]; then
		echo "mv $file $bak_path"
		mv $file $bak_path
	fi
done< <(cat $tmp_path/todelete_$ppid | while read line; do find $prj_path -name "$line"; done)
