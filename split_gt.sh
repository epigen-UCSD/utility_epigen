#for  l in  *CUT*final.bam; do echo $l; done

size=$1
for l in  *nsort.bam
do 
    echo $l
    #samtools sort -n $l -o $ll
    #samtools view -h $ll | awk '$9*$9 < 300*300 || $1 ~ /^@/' | samtools view -bS -  | bedtools bamtofastq -i - -fq ${l/.bam/_300_R1.fastq} -fq2 ${l/.bam/_300_R2.fastq} & sleep 1
    fn=${l/.nsort.bam/_gt_${size}.fastq}
    samtools view -h $l | awk -v s=$size '$9*$9 > s*s || $1 ~ /^@/' | samtools view -bS -  | samtools bam2fq - > $fn
    cat $fn | grep '^@.*/1$' -A 3 --no-group-separator |gzip > ${fn/.fastq/_R1.fastq.gz} & sleep 1
    cat $fn | grep '^@.*/2$' -A 3 --no-group-separator |gzip >  ${fn/.fastq/_R2.fastq.gz}  & sleep 1
    #rm $fn 
done
