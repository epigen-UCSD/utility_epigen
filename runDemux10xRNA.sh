#!/bin/bash
#PBS -q condo
#PBS -N django_10xDemuxRNA
#PBS -l nodes=1:ppn=16
#PBS -l walltime=8:00:00
#PBS -o /home/zhc268/logs/runDemux10xRNA.out
#PBS -e /home/zhc268/logs/runDemux10xRNA.err
#PBS -V
#PBS -m abe
#PBS -A epigen-group

# -v pass parameters: flowcell_id, run_dir
############################################################
## update status to job submitted @VM
############################################################

flowcell_id=$1
run_dir=$2

cmd="source activate django;python \$(which updateRunStatus.py) -s '1' -f $flowcell_id"

ssh zhc268@epigenomics.sdsc.edu $cmd



############################################################
## run bcl2fastq @TSCC
############################################################
## delete last demux info 
[[ -d ${run_dir}/${flowcell_id} ]] && rm -r ${run_dir}/${flowcell_id}  # delete existing folder
[[ -f ${run_dir}/__${flowcell_id}.mro ]] && rm ${run_dir}/__${flowcell_id}.mro  # delete existing folder

## prepare variables & directories
out_dir_sys=${run_dir}/${flowcell_id}/outs/fastq_path/
out_dir=${run_dir}/Data/Fastqs/
mkdir -p ${out_dir}

## prepair reads_cnt_file
reads_cnt_file="${out_dir}/reads_cnt.tsv"
>$reads_cnt_file

## samplesheet
samplesheet="${out_dir}/SampleSheet_I1.csv"
libs=$(awk -v FS=',' '(NR>1){print $2}' $samplesheet)


############################################################
## run mkfastq
############################################################
cd $run_dir

## 1. for single indexes
if [[ $(grep SI-GA $samplesheet) && '1' = '2' ]]
then
    echo "Running single index" 
    export PATH=/projects/ps-epigen/software/cellranger-3.0.2/:$PATH
    ga="${out_dir}/SampleSheet_GA.csv"
    grep -v SI-TT $samplesheet > $ga
    
    [[ $(grep SI-TT $samplesheet) ]] && extraParsVal2="--ignore-dual-index"
    [[ -f ${out_dir}/extraPars.txt ]] && extraParsVal=$(cat ${out_dir}/extraPars.txt)
    echo -e    " cellranger mkfastq --run=$run_dir  --localcores=16 --csv $ga --qc --id single  $extraParsVal $extraParsVal2"
    cellranger mkfastq --run=$run_dir  --localcores=16 --csv $ga --qc --id single  $extraParsVal $extraParsVal2
    ## output fastq folder assigned by --id 
    out_dir_sys=${run_dir}/single/outs/fastq_path/$flowcell_id
    ln -sf ${out_dir_sys}/Stats $out_dir
    
    libs=$(awk -v FS=',' '(NR>1){print $2}' $ga)
    for i in $libs
    do
        echo $i
        ln -sf ${out_dir_sys}/${i} ~/data/seqdata/
        # for counting reads 
        tempI1=$(mktemp)   
        cat ~/data/seqdata/${i}/${i}*I1*fastq.gz > $tempI1 
        nreads=$(zcat $tempI1 | wc -l ) && echo -e "$i\t$[nreads/4]" >> $reads_cnt_file & sleep 1
    done 
fi


## 2. for dual index 
if grep SI-TT $samplesheet
then
    echo "Running dual indexes" 
    export PATH=/projects/ps-epigen/software/cellranger-4.0.0/:$PATH

    ## only consider extraPars for pure dual index runs
    [[ $(grep SI-GA $samplesheet) ]] && extraParsVal2="--filter-dual-index"
    [[ -f ${out_dir}/extraPars.txt ]] && [[ ! $(grep SI-GA $samplesheet) ]] && extraParsVal=$(cat ${out_dir}/extraPars.txt)
    echo -e " cellranger mkfastq --run=$run_dir  --localcores=16 --csv $samplesheet --qc $extraParsVal $extraParsVal2"
    cellranger mkfastq --run=$run_dir  --localcores=16 --csv $samplesheet --qc $extraParsVal $extraParsVal2

    ## transfer/link data
    out_dir_sys=${run_dir}/${flowcell_id}/outs/fastq_path/$flowcell_id    
    ln -sf ${out_dir_sys}/Stats $out_dir

    tt="${out_dir}/SampleSheet_TT.csv"
    grep -v SI-GA $samplesheet > $tt
    libs=$(awk -v FS=',' '(NR>1){print $2}' $tt)
    
    for i in $libs
    do
        #cp -r ${out_dir_sys}/$flowcell_id/${i} ~/data/seqdata/
        echo $i 
        mkdir -p ${out_dir_sys}/${i}
        ln -sf ${out_dir_sys}/${i}_S*fastq.gz ${out_dir_sys}/${i}/
        ln -sf ${out_dir_sys}/${i} ~/data/seqdata/

        # for counting reads 
        tempI1=$(mktemp)   
        cat ~/data/seqdata/${i}/${i}*I1*fastq.gz > $tempI1 
        nreads=$(zcat $tempI1 | wc -l ) && echo -e "$i\t$[nreads/4]" >> $reads_cnt_file & sleep 1
    done 

fi

wait 
############################################################
# update status to finish or warning @ VM
############################################################
cmd="source activate django; python \$(which updateReadsNumberPerRun.py) -f $flowcell_id -i $reads_cnt_file; python \$(which updateRunReads.py) -f $flowcell_id"
job1=$(ssh zhc268@epigenomics.sdsc.edu $cmd)

############################################################
# run 10x pipeline
############################################################

#qsub -t 0-1 -v samples=${HOME}/runlogs/run_2019-01-22_10xatac_modifiedPeakPar.txt $(which run10xPipeline.pbs)
