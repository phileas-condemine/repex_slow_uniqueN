library(data.table)
library(ggplot2)

grid=expand.grid(n=c(1E+6,1E+7,1E+8,3E+8),ncores=c(1,2,4,8,16))
# I want to add a var indicating the diversity of A amongst group B for each observation
set_uniqueN_by_par_ncores=function(args=c(n=1E+7,ncores=1)){
  n=args[1]
  ncores=args[2]
  card=3000
  chars=openssl::sha2(as.character(1:card))
  chars=substr(chars,1,5)
  uniqueN(chars)
  dist=runif(1:card)
  setDTthreads(ncores)
  DT <- data.table(A=sample(chars,n,T,dist),
                   B=sample(chars,n,T,dist))
  time=Sys.time()
  DT[,"div_A_in_B":=uniqueN(A),by=B]
  diff_time=Sys.time()-time
  rm(DT)
  gc()
  data.table(nb_rows=n,nb_cores=ncores,time=diff_time)
}

perf=pbapply::pbapply(grid,1,set_uniqueN_by_par_ncores)


perf_dt=rbindlist(perf)
gc()
g <- ggplot(perf_dt)+
  geom_line(aes(x=nb_cores,y=as.numeric(time),color=factor(nb_rows)))+
  ggtitle("Using setDTthreads for ':= uniqueN, by' operation")+
  ylab("Elapsed time (log2)")+xlab("Number of cores")+scale_y_continuous(trans="log2")
g
ggsave(plot = g,filename = "perf_DT_parallelized.png",width = 12,height = 8)
  