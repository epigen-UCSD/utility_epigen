#!/bin/bash

# Code to simplify the name by removing _R1.fastq.bz2 and etc. 

sample="JYH_$1"

#find . -name "$sample*" -type f | head -n 1 | sed -E "p;s/_R1.fastq.bz2//g" | xargs -n 2 mv 
find . -name "$sample*" -type f | sed -E "p;s/_R1.fastq.bz2//g" | xargs -n 2 mv 


