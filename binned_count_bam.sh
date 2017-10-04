libno=$1

bined_genome="/home/zhc268/data/GENOME/hg38/hg38.100kb.windows.bed"
input_bam="/home/zhc268/scratch/outputs/JYH_${libno}/align/rep1/JYH_${libno}_R1.fastq.bz2.PE2SE.nodup.bam"
output_dir="/home/zhc268/scratch/outputs/JYH_${libno}/qc/rep1/"

output_file=$output_dir"/JYH_${libno}_R1.fastq.bz2.PE2SE_100kb_binned_counts.bedg"


# got the counts vector

if [ ! -f $output_file ]; then 
    echo "running lib: JYH_${libno}"
    bedtools intersect -a $bined_genome \
                   -b $input_bam \
                   -c -sorted  >  $output_file;
fi



    












