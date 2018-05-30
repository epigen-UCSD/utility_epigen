#!/bin/bash

db=${HOME}//data/MOTIF/motif_databases_12_17_MEME/JASPAR/JASPAR2018_CORE_vertebrates_non-redundant.meme
in=$1 # ./clust_1.fa
bg=${in}.shuffled.fa
alph=${in}.alphabet.txt

meme2alph $db $alph
fasta-shuffle-letters -alph $alph -kmer 2 -tag -dinuc -seed 1 $in $bg
ame --verbose 1 -oc ${in/.fa/} --control $bg --bgformat 1  --scoring avg --method ranksum  $in $db
rm $alph 
