args <- commandArgs(trailingOnly = TRUE)

require(data.table)

##fn <-"SRC_1625_cortex.RNase.trt.score.txt"
fn <- args[1]

scores <- fread(fn,col.names=c('Flag','Score'))
setDF(scores)

## count
require(limma)
a <- vennCounts(cbind(
    mpq.fail = (scores$Score <=30),
    F1804.fail = (bitwAnd(1804,scores$Flag)>0),
    Improper = !(bitwAnd(2,scores$Flag)>0)))

## plot
pdf(file=sub(".txt",".venn.pdf",fn))
vennDiagram(a,counts.col='red',cex=1,main=sub(".score.txt","",fn))
dev.off()
