library(plyr)
library(colorspace)
library(ggplot2)
library(missForest)
library(rstan)
library(Amelia)
library(VennDiagram)

setwd("C:/Users/Yu/Desktop/Atlantic Slave Trading/2.Analysis")
###################################################clean data ########################################
data=read.table("needed data_8.txt",T)
summary(data)

###########################################set factors################################################
data$arrreg=as.factor(data$arrreg)
data$depreg=as.factor(data$depreg)
data$decade=as.factor(data$decade)
data$route=as.factor(data$route)
summary(data)

################################delete the voyage length#################################
data=data[,-5]
summary(data)
#########################finally, we got the data we need##############################



################check the assumption of the constant average################################
cmp=data[complete.cases(data),]
cmp$count=1
cmp_d=ddply(cmp,~decade,summarise,sumvoy=sum(count),sumarr=sum(arrnum),sumdep=sum(depnum),avearr=mean(na.omit(arrnum)),avedep=mean(na.omit(depnum)))
cmp_d$decade=as.integer(as.character(cmp_d$decade))
cmp_d$lossrate=1-cmp_d$sumarr/cmp_d$sumdep
cmp_d=cmp_d[,c(1,2,5,6,7)]

##################generate fig.7#############################
jpeg("fig_7.jpg", w = 500, h = 250)
par(mfrow=c(3,1), mar=c(2,3.5,2,2)) 
plot(cmp_d$decade, cmp_d$avedep, pch = 1, main="average embarkation population by decade", xlab ="", ylab="")
mtext(side=2, text="population",line=2.2, cex=0.8, font=1)
mtext(side=1, text="decade",adj=1, line=0.1, cex=0.8, font=1)
plot(cmp_d$decade, cmp_d$avearr, pch = 1, main="average arrival population by decade", xlab ="", ylab="")
mtext(side=2, text="population",line=2.2, cex=0.8, font=1)
mtext(side=1, text="decade",adj=1, line=0.1, cex=0.8, font=1)
plot(cmp_d$decade, cmp_d$lossrate, pch = 1, main="average loss rate by decade", xlab ="decade", ylab="")
mtext(side=2, text="loss rate",line=2.2, cex=0.8, font=1)
mtext(side=1, text="decade",adj=1, line=0.1, cex=0.8, font=1)
dev.off()

##################calculation the simulation under the assumption of constant rate###########
cmp_d_r=ddply(cmp,c("decade","route"),summarise,sumvoy=sum(count),sumarr=sum(arrnum),sumdep=sum(depnum))
cmp_r=ddply(cmp,c("route"),summarise,avearr=mean(na.omit(arrnum)),avedep=mean(na.omit(depnum)))
cmp_route_prop=table(cmp$route,cmp$decade)
cmp_d_sim=cmp_d
cmp_d_sim[3:4] = t(as.matrix.data.frame(cmp_route_prop))[,-14] %*% as.matrix.data.frame(cmp_r[,-1])
cmp_d_sim[5] = 1 - cmp_d_sim[3] / cmp_d_sim[4]
cmp_d_sim[3:4] = cmp_d_sim[,3:4] / cmp_d_sim[,2]

##################generate fig.8#############################
jpeg("fig_8.jpg", w = 500, h = 250)
par(mfrow=c(3,1), mar=c(2,3.5,2,2)) 
plot(cmp_d$decade, cmp_d$avedep, pch = 1, main="average embarkation population by decade", xlab ="", ylab="")
lines(cmp_d_sim$decade,cmp_d_sim$avedep,col="red")
points(cmp_d_sim$decade,cmp_d_sim$avedep,col="red", pch=3)
mtext(side=2, text="population",line=2.2, cex=0.8, font=1)
mtext(side=1, text="decade",adj=1, line=0.1, cex=0.8, font=1)
plot(cmp_d$decade, cmp_d$avearr, pch = 1, main="average arrival population by decade", xlab ="", ylab="")
lines(cmp_d_sim$decade,cmp_d_sim$avearr,col="red")
points(cmp_d_sim$decade,cmp_d_sim$avearr,col="red", pch=3)
mtext(side=2, text="population",line=2.2, cex=0.8, font=1)
mtext(side=1, text="decade",adj=1, line=0.1, cex=0.8, font=1)
plot(cmp_d$decade, cmp_d$lossrate, pch = 1, main="average loss rate by decade", xlab ="decade", ylab="")
lines(cmp_d_sim$decade,cmp_d_sim$lossrate,col="red")
points(cmp_d_sim$decade,cmp_d_sim$lossrate,col="red", pch =3)
mtext(side=2, text="loss rate",line=2.2, cex=0.8, font=1)
mtext(side=1, text="decade",adj=1, line=0.1, cex=0.8, font=1)
dev.off()




  