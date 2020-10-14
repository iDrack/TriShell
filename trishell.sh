#!/bin/bash
if [ "$1" = "-R" ]
then
    echo ".:"
fi
for i in *
    do
    echo -ne "$i\t"
done
echo ""
if [ "$1" = "-R" ]
then
    for i in *
    do
        if [ -d "$i" ]
        then
            cd $i
	    echo -e "\n./$i:"
            for i in *
            do
                echo -ne "$i\t"
            done
	    echo ""
            cd ..
        fi
    done
fi

