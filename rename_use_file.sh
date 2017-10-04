#!/bin/bash

# change the names
awk '{if (NR%2==0) print $2 ".fastq.gz" "\t" $1 "_R2.fastq.gz"; else print $2 ".fastq.gz" "\t" $1 "_R1.fastq.gz" }' IGM.txt > name_convert.txt

cd ../seqdata
eval `$(sed 's/^/mv /g' ../tmp/name_convert.txt )`

sed 's/^/mv /' ../tmp/name_convert.txt | bash

