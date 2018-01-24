# correct libQC txt given the

args <- commandArgs(trailingOnly = TRUE)
s <- args[1]


libQC_dir <- "/home/zhc268/data/outputs/libQCs"
l <- system(paste("find",libQC_dir, paste0("-name ", s,"*_qc.txt")),intern=T)



findBam <-  function(s){

    bams <- system(paste0("find /home/zhc268/data/outputs/bams/ -name \"",s,"[\\_|\\.][a-Z]*.bam\""),intern=T)

    idx  <- grep("nodup",bams)
    rawbam <-  bams[-idx]
    finalbam <- bams[idx]

    if(length(rawbam)>1) {
        cat(s,"\n")
        rawbam.idx <- grepl("trim",rawbam)
        cmd= paste0("rm ", rawbam[!rawbam.idx])
        print(cmd)
    }
    if(length(finalbam)>1) {
        cat(s,"\n")
        print(finalbam);
        finalbam.idx <- grepl("trim",finalbam)
        cmd=(paste0("rm ", finalbam[!finalbam.idx]))
        print(cmd)
 #       system(cmd)
    }
    return(data.frame(rawbam,finalbam,stringsAsFactors=F))
}

bams <- findBam(s)

qc <- read.table(l,sep = "\t",header = F,fill = T,col.names = paste0("v",seq(3)),
                 stringsAsFactors = F)


# 4. reads final
(nreads.final <- as.numeric(system(paste0("samtools idxstats ",bams$finalbam, " 2> /dev/null | awk '{sum+=$3+$4}END{print sum}'"),intern=T)))
print(qc[10,])
qc[10,2] <- as.character(nreads.final)


# 6.final reads
qc[15,]
qc[15,2] <- qc[10,2]
qc[15,3] <-  as.character(nreads.final/as.numeric(qc[6,2]))


# write the file
write.table(qc,file=l, quote=F, sep="\t",na="",row.names=F,col.names=F)




