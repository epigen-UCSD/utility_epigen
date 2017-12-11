#!/bin/bash
#use deeptools to generate coverage heatmap
#input: 1-bed files for peak location 2-regions around TSS 3-bigwigfiles
#output:heatmap
#following:http://deeptools.readthedocs.io/en/latest/content/example_gallery.html#normalized-chip-seq-signals-and-peak-regions



#interpret input
#http://stackoverflow.com/questions/192249/how-do-i-parse-command-line-arguments-in-bash
#-start
echo $#
while [[ $# -gt 1 ]]
do
key="$1"

case $key in
    -b|--before)
    BEFORE="$2"
    shift # past argument
    ;;
    -a|--after)
    AFTER="$2"
    shift # past argument
    ;;
    -R|--regionFileName)
	REGIONFILE="$2"
    shift # past argument
    ;;
    -S|--sourceFileName)
	SOURCEFILE="$2 $3 $4 $5 $6 $7"
	shift # past argument
    ;;
    --default)
    DEFAULT=YES
    ;;
    *)
            # unknown option
    ;;
esac
shift # past argument or value
done

echo $SOURCEFILE

#step1 computeMatrix
computeMatrix scale-regions -b $BEFORE -a $AFTER -R $REGIONFILE -S $SOURCEFILE --skipZeros -o matrix.gz --outFileNameMatrix matrix.tab --outFileSortedRegions regions_multiple_genes.bed


#step2 plot heatmap 
plotHeatmap  -m matrix.gz -out hm.png --heatmapHeight 15

# find  /mnt/biggie/backed_up/roberto/analyses/Kim/p65_ChIP/batch2/07_tracks -name '[0-9]*.bw' -exec bash plotCoverage.sh -b 500 -a 500 -R ./roberto-20150625-all_peaks.bed -S {} + 

