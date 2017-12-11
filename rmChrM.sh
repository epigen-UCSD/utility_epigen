#! /bin/bash 
# remove chrM from final bam


inputBam=$1


echo $inputBam

samtools view -h $inputBam | awk '($3 != "chrM")'| samtools view -Sb -@ 8 - > $inputBam.noChrM.bam
mv $inputBam.noChrM.bam $inputBam
samtools index -b $inputBam 

#samtools idxstats $bam2 |  cut -f 1 | grep -v chrM  | xargs echo samtools view -b $bam2



