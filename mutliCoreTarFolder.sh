#!/bin/bash


# tFolder -through -v

tar cf - $tFolder | pigz > archive.tar.gz


# qsub -v tFolder=$(pwd) -q condo -l nodes=1:ppn=8  mutliCoreTarFolder.sh  -o ~/logs/multiTag.o -e ~/logs/multiTag.e -l walltime=08:00:00
