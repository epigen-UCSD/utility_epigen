args <- commandArgs(trailingOnly = TRUE)      
port_ <- args[1] 
set <- args[2]#4_1
libs <- args[3:length(args)]
port_
set
libs
#port_ <- 8083
#libs <- seq(48,57)
#set <- "4_1"


setQC_dir <- paste0("/projects/ps-epigen/outputs/setQCs/Set_",set)

rmarkdown::render("/projects/ps-epigen/software/bin/setQC_report.R", 
                  params = list(
                    port = port_,
                    libs_no = libs,
                    set_no = set
                  ),
                  output_dir=setQC_dir)
#libs_no = libs),output_dir=paste0("~/mnt/tscc_home/data/outputs/setQCs/Set_",set))
#rmarkdown::render("setQC_report.R", 
#                  params = "ask",
#                  output_dir=paste0("/Users/frank/Dropbox/Projects/UCSD_2017/04_Set",set))
