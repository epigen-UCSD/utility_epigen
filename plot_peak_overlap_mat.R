# plot 
require(ggplot2)
require(tidyverse)
require(pheatmap)
require(RColorBrewer)

peak.overlap.mat<- read.table("./data/peak_q3.overlap.mat.tsv",col.names = peak.numbers$sample,
                              row.names = peak.numbers$sample)

h <- pheatmap(peak.overlap.mat,scale = "none")
pheatmap(peak.overlap.mat[rev(1:18),],scale = "none",cluster_rows = F,cluster_cols = F,
         breaks = c(0,0.5,.7,.8,.9,1.01),
         color =  colorRampPalette(rev(brewer.pal(n = 5, name =
                                                    "RdYlBu")))(5))
peak.overlap.long <- peak.overlap.mat %>% mutate(row=peak.numbers$sample) %>%
  gather(key="col",value="frac",1:nrow(peak.overlap.mat))
peak.overlap.long$frac <- cut(peak.overlap.long$frac,breaks = c(0,0.5,.7,.8,.9,1.01))

ggplot(peak.overlap.long,aes(x=col,y=row)) + geom_point(aes(size=as.numeric(frac)*4,colour=frac)) + scale_colour_manual(values=rev(brewer.pal(5,"RdYlBu")))+
  theme_bw()

peak.overlap.long$row <- factor(peak.overlap.long$row,rev(h$tree_row$labels[h$tree_row$order]))
peak.overlap.long$col <- factor(peak.overlap.long$col,(h$tree_col$labels[h$tree_col$order]))

ggplot(peak.overlap.long,aes(x=col,y=row)) + geom_point(aes(size=frac,colour=frac)) + scale_colour_manual(values=rev(brewer.pal(5,"RdYlBu")))+
  theme_bw()


pd.pca <- prcomp(t(peak.overlap.mat),center =T,scale. = F )
perct <- as.numeric(round(summary(pd.pca)$importance[2,1:2]*100))

require(scatterD3)
scatterD3(pd.pca$x[,1],pd.pca$x[,2],lab = peak.numbers$sample,point_size = 100,
          xlab = paste0("PC1: ",perct[1],"%"),
          ylab = paste0("PC2: ",perct[2],"%"),
          point_opacity = 0.5,hover_size = 4, hover_opacity = 1,lasso = T
          )

# display numbers
require(gridExtra)
require(grid)
require(xtable)
require(DT)
peak.number.file <- "./data/peak_number.tsv"
peak.numbers <-  read.table(peak.number.file,col.names=c("sample","peak.num","peak.region.num","peak.fc3.num","peak.fc3.region.num"),
                            stringsAsFactors=F)
datatable(peak.numbers)%>%
  formatCurrency(2:ncol(peak.numbers),currency="",digits=0)


