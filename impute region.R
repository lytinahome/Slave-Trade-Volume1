library(plyr)
library(colorspace)
library(ggplot2)
library(missForest)
library(rstan)
library(Amelia)
library(VennDiagram)
library(reshape2)

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


############################# function we need ##########################################
######################### impute region function ####################################
assign_region <- function(data){
  both <- data[complete.cases(data[,5:6]),]
  dep <- data[complete.cases(data[,5]) & !complete.cases(data[,5:6]),]
  arr <- data[complete.cases(data[,6]) & !complete.cases(data[,5:6]),]
  none <- data[!complete.cases(data[,5]) & !complete.cases(data[,6]),]
  
  #initialprobability
  number_ij = table(both$depreg,both$arrreg)
  prop_dep = prop.table(number_ij, 1)
  prop_dep[is.na(prop_dep)] = 1/5
  prop_arr = prop.table(number_ij, 2)
  prop_arr[is.na(prop_arr)] = 1/8
  
  #total probability
  new_ij = number_ij + diag(summary(dep$depreg)) %*% prop_dep + prop_arr %*% diag(summary(arr$arrreg))
  prop_new_dep = prop.table(new_ij, 1)
  prop_new_dep[is.na(prop_new_dep)] = 1/5
  prop_new_arr = prop.table(new_ij, 2)
  prop_new_arr[is.na(prop_new_arr)] = 1/8
  prop_new = prop.table(new_ij)
  
  #generate missing arrival region
  for (i in levels(dep$depreg)) {
    assign_arr = colSums(diag(1:5) %*% rmultinom(length(dep[dep$depreg == i,1]),1,prop_new_dep[as.integer(i)/10,]) )
    dep[dep$depreg == i,"arrreg"] = assign_arr
  }
  
  #generate missing departure region
  for (i in levels(arr$arrreg)) {
    assign_dep = colSums(diag((1:8)*10) %*% rmultinom(length(arr[arr$arrreg == i,1]),1,prop_new_arr[,i]))
    arr[arr$arrreg == i,"depreg"] = assign_dep
  }
  #generate both missing regions
  assign_both = colSums(diag(1:40) %*% rmultinom(length(none[,1]),1,as.vector(prop_new)))
  none$arrreg = as.factor((as.integer(assign_both)-1)%/%8 + 1)
  none$depreg = as.factor(((assign_both-1) %% 8 + 1)*10)
  
  #put the imputation back
  data1=data
  data1[complete.cases(data1[,5]) & !complete.cases(data1[,5:6]),"arrreg"] = dep$arrreg
  data1[complete.cases(data1[,6]) & !complete.cases(data1[,5:6]),"depreg"] = arr$depreg
  data1[!complete.cases(data1[,5]) & !complete.cases(data1[,6]), 5:6] = none[,5:6]
  data1$route = as.factor(as.numeric(as.character(data1$depreg)) + as.numeric(as.character(data1$arrreg)))
  return(data1)
}
################################# migaration pattern function ########################
migration_pattern <- function(data, nbreak = c(-1,0,10,50,100,300,500,1000,10000) ){
  prop=table(data$route,data$decade)
  par(mfrow=c(1,1), mar=c(1,2,2,5), xpd=F)
  gray_palette=gray.colors(length(nbreak)-1, start = 1, end = 0)
  image(as.matrix(prop[,ncol(prop):1]),col = gray_palette, breaks = nbreak,axes=F)
  box()
  grid(nx=nrow(prop), ny=ncol(prop), lty = 3, col = "GRAY")
  
  move=0.005
  par(xpd=T)
  text(-move,seq(1, 0, length.out = ncol(prop)), colnames(prop),cex=0.8, font=1, pos=2)
  text(seq(0, 1, length.out = nrow(prop)), 1+2*move, rownames(prop),cex=0.6, font=1, pos=3)
  text(1+1/nrow(prop)+0.01,1+2*move, "total",cex=0.6, font=1, pos=3)
  text(1+move,seq(1, 0, length.out = ncol(prop)), colSums(prop),cex=0.8, font=1, pos=4)
  
  width=0.03 
  height=0.01
  dis=0.09
  rect(1+dis+move, 0.03 + seq(0,by=0.1,length.out = length(gray_palette)), 1+dis+width+move, 0.03 + height + seq(0,by=0.1,length.out = length(gray_palette)), col = gray_palette)
  text_legend=c("= 0")
  for(i in 2 : (length(nbreak)-2)) {text_legend = c(text_legend, paste(nbreak[i]+1,nbreak[i+1],sep="~"))}
  text_legend = c(text_legend, paste(nbreak[length(nbreak)-1]+1,"+",sep=""))
  text(1+dis+0.02+move, 0.03 + seq(0,by=0.1,length.out = length(gray_palette)), text_legend, cex=0.6, font=1, pos=1)
}

##############################################impute regions####################################
# solution 1
data1 = data

for(i in data$decade){
  data1[data1$decade == i & is.na(data1$arrnum),] = assign_region(data[data$decade == i & is.na(data1$arrnum),])
}
for(i in data$decade){
  data1[data1$decade == i & !is.na(data1$arrnum) & data1$arrnum > 300,] = assign_region(data[data$decade == i & !is.na(data1$arrnum) & data1$arrnum > 300,])
}
for(i in data$decade){
  data1[data1$decade == i & !is.na(data1$arrnum) & data1$arrnum <= 300,] = assign_region(data[data$decade == i & !is.na(data1$arrnum) & data1$arrnum <= 300,])
}
migration_pattern(data1)
write.table(data1, "data_impute_region_1.txt")

# solution 2
data2 = data
for(i in data$decade){
  data2[data2$decade == i,] = assign_region(data[data$decade == i,])
}
write.table(data2, "data_impute_region_2.txt")
migration_pattern(data2)


#######################check the validation of separating the arrnum (we don't need this step in paper)#########################
################### check the missing part of route ################################
check_partial_miss_dep<-function(data){
  both = data[complete.cases(data[,5:6]),]
  dep = data[complete.cases(data[,5]),] 
  both_p = table(both$depreg, both$decade)
  both_p[both_p>0] = 1
  dep_p = table(dep$depreg, dep$decade)
  dep_p[dep_p>0] = 1
  print(table(dep$depreg, dep$decade)[(dep_p - both_p) == 1])
}
check_partial_miss_arr<-function(data){
  both = data[complete.cases(data[,5:6]),]
  dep = data[complete.cases(data[,6]),] 
  both_p = table(both$arrreg, both$decade)
  both_p[both_p>0] = 1
  dep_p = table(dep$arrreg, dep$decade)
  dep_p[dep_p>0] = 1
  print(table(dep$arrreg, dep$decade)[(dep_p - both_p) == 1])
}
################## step function about the arrnum ################################
check_partial_miss_dep(data)
check_partial_miss_arr(data)

check_partial_miss_dep(data[!complete.cases(data[,4]),])
check_partial_miss_arr(data[!complete.cases(data[,4]),])

check_partial_miss_dep(data[data$arrnum>400,])
check_partial_miss_arr(data[data$arrnum>400,])

check_partial_miss_dep(data[data$arrnum<400 & data$arrnum>200,])
check_partial_miss_arr(data[data$arrnum<400 & data$arrnum>200,])

check_partial_miss_dep(data[data$arrnum<200,])
check_partial_miss_arr(data[data$arrnum<200,])


#########################################pic 5 and 10######################################
draw_facet <-function(data){
pic=data
pic=pic[!is.na(pic$route),]
pic$count = 1

pic_list=ddply(pic,c("decade","route"),summarise,avearr=mean(arrnum, na.rm = T),avedep=mean(depnum, na.rm = T))
pic_list$depreg = as.numeric(as.character(pic_list$route)) %/% 10
pic_list$depreg = factor(pic_list$depreg, labels = c( "Senegambia","Sierra Leone","Windward \n  Coast","Gold Coast","Bight of \n Benin","Bight of \n Biafra n' Gulf of \n Guinea islands","West Central \n Africa and \n St. Helena","Southeast Africa \n and Indian  \n Ocean islands"
))
pic_list$arrreg = as.numeric(as.character(pic_list$route)) %% 10 
pic_list$arrreg = factor(pic_list$arrreg, labels = c("Mainland N.America","Caribbean","Spanish","Brazil","Africa" ))
ggplot(pic_list, aes(x = decade)) +
geom_point(aes(y = avedep), colour = "red", size = 0.5)  +
geom_point(aes(y = avearr), colour = "blue", size = 0.5)  +
  theme(axis.title.x=element_blank(),
        axis.title.y=element_blank(),
        axis.text.x=element_blank(),
        axis.ticks.x=element_blank(),
        strip.text.y = element_text(size = 6, angle = 90))+
facet_grid(depreg ~ arrreg, scales = "free_y")
}

draw_facet(data)
draw_facet(data1)
