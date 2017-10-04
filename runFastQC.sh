#!/bin/bash 
# run fastq QC for _2 libs/seq runs 

usage() { echo "Usage: $0 [-trim <Y|N(default)>] [-type <gz(default)|bz2|fastq>]" 1>&2; exit 1; }

while getopts "t:s:" o; do
    case $o in
        trim) trim="${OPTARG}"
              ((trim ))
              ;;
        s) s="${OPTARG}";;
        *) usage;;
    esac
done

shift $((OPTIND-1))

echo "input lib number: ${l[@]}"
echo "output set number = ${s}"


module load fastqc

FASTQ_DIR="/projects/ps-epigen/seqdata/"
sample_prefix="JYH_"$1"_2"

OUTPUT_DIR="/projects/ps-epigen/outputs/libQCs/"${sample_prefix}
mkdir -p $OUTPUT_DIR

fastq1=${FASTQ_DIR}${sample_prefix}"_R1.fastq.gz"
fastq2=${FASTQ_DIR}${sample_prefix}"_R2.fastq.gz"

fastqc  -outdir $OUTPUT_DIR  $fastq1
fastqc  -outdir $OUTPUT_DIR  $fastq2


# eg:

#for l in `seq 48 57`;do echo $l; runFastQC_2trim.sh $l ; done  
