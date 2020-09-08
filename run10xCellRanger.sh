#!/bin/bash
#PBS -q home-epigen
#PBS -N django_10xPipeline_CellRanger
#PBS -l nodes=1:ppn=16
#PBS -l walltime=24:00:00
#PBS -l mem=96gb
#PBS -o /home/zhc268/logs/run_10xRNA.out
#PBS -e /home/zhc268/logs/run_10xRNA.err
#PBS -V
#PBS -m abe
#PBS -A epigen-group

# -v pass parameters: samples
samples=$1
PBS_ARRAYID=0
genome_path=$2


export PATH=/projects/ps-epigen/software/cellranger-4.0.0/:$PATH
WORKDIR="/oasis/tscc/scratch/$(whoami)/outputs_TA/"
FASTQDIR="/projects/ps-epigen/seqdata/"


# select libs 
samplenames=(`cat $samples`)
INPREFIX=${samplenames[${PBS_ARRAYID}*3]} #index start from 0
SAMPLE=${samplenames[${PBS_ARRAYID}*3+1]}
GENOME=${samplenames[${PBS_ARRAYID}*3+2]}
cd $WORKDIR

# remove existed data
[[ -f $WORKDIR$INPREFIX"/"$INPREFIX".mri.tgz" ]]  && rm -rf $WORKDIR$INPREFIX

# prepare fastqs, comma seperated values
fastqs=$(echo $SAMPLE| awk -v FS=',' -v d="${FASTQDIR}" '{ for(i=1;i<=NF-1;i++) {printf "%s,", d$i};print d$NF;}')

#fastqs="${FASTQDIR}/${INPREFIX}"
#echo $fastqs
# [[ ! -d $fastqs ]] && { echo "$fastqs not found"; exit 0; }


# run pipeline

# update status from InQueue to InProcess
cmd="source activate django; python \$(which updateSingleCellStatus.py) -seqid $INPREFIX -status InProcess;"
job1=$(ssh zhc268@epigenomics.sdsc.edu $cmd)


mkdir -p ~/data/outputs/scRNA/$INPREFIX
[[ -f ~/data/outputs/scRNA/${INPREFIX}/.inqueue ]] && rm  ~/data/outputs/scRNA/${INPREFIX}/.inqueue 
[[ -f ~/data/outputs/scRNA/${INPREFIX}/.inprocess ]] && rm  ~/data/outputs/scRNA/${INPREFIX}/.inprocess

## handle mixing RNA-ATAC outputs
sample_args=${SAMPLE}
[[ $(ls -1 ${fastqs}/${SAMPLE}_[1-4]_S*_R1_*fastq.gz|wc -l) -eq 4 ]] && sample_args="${SAMPLE}_1,${SAMPLE}_2,${SAMPLE}_3,${SAMPLE}_4"
cmd="cellranger count --id=$INPREFIX --fastqs=${fastqs} --sample $sample_args --transcriptome=${genome_path} --localcores=16  --mempercore=5"
echo $cmd
echo $cmd |bash 
wait

# transfer results
rsync -azr ${WORKDIR}${INPREFIX} ~/data/outputs/scRNA/

wait


#!!!!! TODO add a check to see if error file present if so then pass Error! to status
## addtional check
#[[ -z $(find ${OUTDIR}/qc/rep1 -name "*_qc.txt") ]]  && { echo  "pipeline interrupted"; exit 0; }



############################################################
# update status to finish or warning @ VM
############################################################
cmd="source activate django; python \$(which updateSingleCellStatus.py) -seqid $INPREFIX -status Yes;"
job1=$(ssh zhc268@epigenomics.sdsc.edu $cmd)
#update status in 

