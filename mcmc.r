library(plyr)
library(colorspace)
library(ggplot2)
library(missForest)
library(rstan)
library(Amelia)
library(VennDiagram)
library(sna)
setwd("C:/Users/Yu/Desktop/Atlantic Slave Trading/3.MCMC")

data=read.table("data_impute_region_1.txt",T)
summary(data)
data$route = factor(data$route)
levels(data$route) <-  c(levels(data$route), "95","97")
data[data$route == "52" & data$decade > 1840, "route"] = 95
data[data$route == "72" & data$decade > 1840, "route"] = 97
mc=data
mc$route = as.integer(mc$route)

gp1=mc[!is.na(mc$depnum)& !is.na(mc$arrnum),]
gp2=mc[!is.na(mc$depnum)& is.na(mc$arrnum),]
gp3=mc[is.na(mc$depnum)& !is.na(mc$arrnum),]
list=list(level=42,
          gp1=nrow(gp1),
          gp2=nrow(gp2),
          gp3=nrow(gp3),
          depnum1=as.integer(gp1$depnum),
          arrnum1=as.integer(gp1$arrnum),
          route1=(gp1$route),
          depnum2=as.integer(gp2$depnum),
          route2=(gp2$route),
          arrnum3=as.integer(gp3$arrnum),
          route3=(gp3$route))
stan_rdump(ls(list),"data.rdump",envir=list2env(list))
source("data.rdump")
fit=stan(file="mcmc.stan",iter=10000,chains=4)
get_posterior_mean(fit)
write.table(summary(fit)$summary,"mcmc.txt")


############################summarize the data#######################
result = read.table("mcmc.txt",T)
head(result)
