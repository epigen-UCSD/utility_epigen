### input: peak_number_tscv
### output: peak_ovelap_frac_mat


args <- commandArgs(trailingOnly = TRUE)
(peak.bed.files <-  args[-1])
(outfile <- args[1])

nsample <-  length(peak.bed.files)
peak.overlap.mat <-  matrix(nsample,nsample,data=1)

(peak.region.num <- sapply(peak.bed.files,function(x)
    as.numeric(system(paste("wc -l",x,"| cut -d' ' -f1"),intern=T))))

#iters <-  combn(nsample,2)

### function
countOverlap<- function(pfile1= peak.bed.files[1],
                        pfile2= peak.bed.files[2]){
    # use samtools :http://bedtools.readthedocs.io/en/latest/content/tools/intersect.html
    # bedtools intersect -a A.bed -b B.bed -wa (only A), order does matter
    as.numeric(system(paste("bedtools intersect -a",pfile1,"-b",pfile2,"-wa | wc -l"),intern=T))
}


### iter through
for(row in 1:nsample){
    for (col in 1:nsample){
        cat(row,",",col,"\n")
        if (row!=col){
            (peak.overlap.mat[row,col] <- signif(countOverlap(pfile1= peak.bed.files[row],
                                                      pfile2= peak.bed.files[col])/peak.region.num[row],2))
        }

    }
}

#write.table(peak.overlap.mat,"./data/peak.overlap.mat.tsv",row.names=F,col.names=F,sep="\t")
write.table(peak.overlap.mat,outfile,row.names=F,col.names=F,sep="\t")



