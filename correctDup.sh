#!/bin/bash

l=$1
s=${l/_R1*/}
qc=$(ls ${s}_R1*dup.qc)
vals=($(python ./correctDup.py --dup_file $qc))
ll="/home/zhc268/scratch/outputs/$s/qc/rep1/$l"

grep -i dup $ll

# line 1
old=$(grep dup $ll |head -n1 |awk -F'\t' '{print $2}')
new=$[old-${vals[0]}]
perl -pe "s/reads\t$old/reads\t$new/g" $ll |grep dup |grep reads
perl -i -pe "s/reads\t$old/reads\t$new/g" $ll |grep dup

# line 2
perl -pe "s/0\t0\.0$/${vals[0]}\t${vals[1]}/g" $ll  | grep Dup|head -n1 
perl -i -pe "s/0\t0\.0$/${vals[0]}\t${vals[1]}/g" $ll  | grep Dup
