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

# 1. reads afer filtering
nreads.filted <-as.numeric( system(paste0("samtools view -c -F 1804 -f 2 -q 30 ",bams$rawbam),intern=T)) # l8
print(qc[8,])
cat( nreads.filted,"\n")
qc[8,2] <- as.character(nreads.filted)

# 2. dup reads
(nreads.dup <- as.numeric(qc[12,2])*2) #12
print(qc[12,])
cat(nreads.dup/as.numeric(nreads.filted), "\t", qc[12,3],"\n")
qc[12,2] <- as.character(nreads.dup)

# 3.reads dedup
(nreads.dedup <-nreads.filted - nreads.dup)
print(qc[9,])
qc[9,2] <- as.character(nreads.dedup)

# 4. reads final
(nreads.final <- as.numeric(system(paste0("samtools idxstats ",bams$finalbam, " 2> /dev/null | awk '{sum+=$3+$4}END{print sum}'"),intern=T)))
print(qc[10,])
qc[10,2] <- as.character(nreads.final)

# 5. Mapping q passed
print(qc[11,])
qc[11,1] <- "Mapping quality passed filters (out of total)"
qc[11,2] <-  qc[8,2]
qc[11,3] <- as.numeric(qc[8,2])/as.numeric(qc[6,2])

# 6.final reads
qc[15,]
qc[15,2] <- qc[10,2]
qc[15,3] <-  as.character(nreads.final/as.numeric(qc[6,2]))


# write the file
if((nreads.dup/as.numeric(nreads.filted)- as.numeric( qc[12,3]))<0.01){
    write.table(qc,file=l, quote=F, sep="\t",na="",row.names=F,col.names=F)
}else{
    write.table(qc,file=paste0(l,"_new"), quote=F, sep="\t",na="",row.names=F,col.names=F)
}



