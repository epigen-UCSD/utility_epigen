#!/bin/bash

# change the names
awk '{if (NR%2==0) print $2 ".fastq.gz" "\t" $1 "_R2.fastq.gz"; else print $2 ".fastq.gz" "\t" $1 "_R1.fastq.gz" }' IGM.txt > name_convert.txt

cd ../seqdata
eval `$(sed 's/^/mv /g' ../tmp/name_convert.txt )`

sed 's/^/mv /' ../tmp/name_convert.txt | bash


# directories
while read l ; do a=($l) ; find ~/data/outputs/ -type d -name ${a[0]}| xargs -n1 -I '{}' echo mv {} {} | sed "s/${a[0]}/${a[1]}/2"| bash ; done < ~/convert.txt 


# files
while read l ; do a=($l) ; find ~/data/outputs/ -type f -name ${a[0]}*| xargs -n1 -I '{}' echo mv {} {} | sed "s/${a[0]}/${a[1]}/2;s/_001//2" | bash ; done < ~/convert.txt

while read l ; do a=($l) ; find ~/data/seqdata// -type f -name ${a[0]}*| xargs -n1 -I '{}' echo mv {} {} | sed "s/${a[0]}/${a[1]}/2;s/_001//2" | bash ; done < ~/convert.txt 


# tracks
cd ~/data/outputs/signals/
while read l ; do a=($l) ; find . -name ${a[1]}_tracks.json | xargs -n1 -I '{}' sed -i "s/${a[0]}/${a[1]}/g;s/_001//g" {}  ; done < ~/convert.txt
