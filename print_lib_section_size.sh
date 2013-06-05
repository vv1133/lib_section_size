#!/bin/sh

if [ $# != 1 ]; then
  echo "parameter error $#" >&2
	exit 1
fi

nm -S --size-sort --radix=d $1 | sort -k2 > tmp.$$$$

if [ $? != 0 ]; then
	echo "nm error" >&2
	exit 1
fi

awk '{print $3 " " $2}' tmp.$$$$ | sed '/^ *$/d'> tmp1.$$$$

awk '
BEGIN {
	bss=0 
	text=0 
	data=0
	other=0
}
{
	if ($1 == "C" || $1 == "B" || $1 == "b")
	{
		bss += $2;
	}
	else if ($1 == "R" || $1 == "d" || $1 == "D")
	{
		data += $2;
	}
	else if ($1 == "t" || $1 == "T")
	{
		text += $2;
	}
	else
	{
		other += $2;
#		print "other:" $0
	}
} 
END{
	print "bss_size =", bss
	print "text_size =", text
	print "data_size =", data
	print "other_size =", other
}' tmp1.$$$$


rm tmp.$$$$
rm tmp1.$$$$
