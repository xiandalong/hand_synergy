# example of reading data from matlab files 
library(R.matlab)
pathname <-"C:\\Users\\kelvi_000\\OneDrive\\Haptics research\\hand_synergy\\MyCode\\Square_error.mat"
data <- readMat(pathname)
print(data)


set.seed(42)
sync <- as.numeric(data[[1]])
async <- as.numeric(data[[2]])
p1 <- hist(sync,breaks=50,plot=FALSE)
p1$counts<-p1$counts/length(sync)
p2 <- hist(async,breaks=50,plot=FALSE)
p2$counts<-p2$counts/length(async)
plot(0,0,type="n",xlim=c(0,50000),ylim=c(0,0.3),xlab="SSE",ylab="Frequency (%)",main="SSE for each grasping-mimicking hand shape pair")
plot(p1,col="skyblue",add=TRUE,border=F)
plot(p2,col=scales::alpha('red',.5),add=TRUE,border=F)
legend(40000, 0.25, c("Synchronous", "Asynchronous"), lwd = 4,col=c("skyblue", scales::alpha('red',.5)))


set.seed(42)
hist(rnorm(500,4),xlim=c(0,10),col='skyblue',border=F)
hist(rnorm(500,6),add=T,col=scales::alpha('red',.5),border=F)

