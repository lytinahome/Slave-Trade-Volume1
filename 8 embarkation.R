require(VennDiagram)
#######################################################
setwd("C:/Users/Yu/Desktop/Atlantic Slave Trading/database")
temp=read.csv("tastdb-exp-2010.csv",T)
data=temp[,c("ï..voyageid","mjbyptimp","mjselimp","year10","tslavesd","slaarriv","voy2imp")]

################################summary the original data#########################
dim(data)
summary(data)
venn1=data[!is.na(data$mjbyptimp),1]
venn2=data[!is.na(data$mjselimp),1]
venn3=data[!is.na(data$voy2imp),1]
venn4=data[,1]
x=list(
  "depreg"=venn1,
  "arrreg"=venn2,
  "length"=venn3,
  "all"=venn4
)
overlap=calculate.overlap(x)
venn.diagram(x,filename="venn diagram lossrate.png")

#########################
data=data[data$year10>15,]  ##select 1650s-1860s

summary(as.factor(floor(data$mjbyptimp/100)))
nrow(data[data$mjbyptimp %in% c(60912,60916,60917),])
summary(as.factor(floor(data$mjselimp/10000)))
data$id=data$ï..voyageid
data$decade=(data$year10-16)*10+1650

#############truncate the population data$$$$$$$$$$$$$$$$$$$$$$$$$$$
data$depnum=as.integer(data$tslavesd)
data$arrnum=as.integer(data$slaarriv)
data$length=data$voy2imp
head(data)

########################depreg#############################################################
levels(as.factor(data$mjbyptimp))
data=data[!(data$mjbyptimp %in% 80399),]
levels(as.factor(data$mjbyptimp))

data$depreg=NA
data$depnames=""

##region60100
data[data$mjbyptimp %in% c(60101:60199),]$depreg=10
data[data$mjbyptimp %in% c(60101:60199),]$depnames="Senegambia"

##region60200
data[data$mjbyptimp %in% c(60201:60299),]$depreg=20
data[data$mjbyptimp %in% c(60201:60299),]$depnames="Sierra Leone"

##region60300
data[data$mjbyptimp %in% c(60301:60399,60912,60916,60917),]$depreg=30
data[data$mjbyptimp %in% c(60301:60399,60912,60916,60917 ),]$depnames="Windward Coast"

##region60400
data[data$mjbyptimp %in% c(60401:60499),]$depreg=40
data[data$mjbyptimp %in% c(60401:60499),]$depnames="Gold Coast"

##region60500
data[data$mjbyptimp %in% c(60501:60599),]$depreg=50
data[data$mjbyptimp %in% c(60501:60599),]$depnames="Bight of Benin"

##region60600
data[data$mjbyptimp %in% c(60601:60699),]$depreg=60
data[data$mjbyptimp %in% c(60601:60699),]$depnames="Bight of Biafra and Gulf of Guinea islands"

##region60700
data[data$mjbyptimp %in% c(60701:60799),]$depreg=70
data[data$mjbyptimp %in% c(60701:60799),]$depnames="West Central Africa and St. Helena"

##region60800
data[data$mjbyptimp %in% c(60801:60899),]$depreg=80
data[data$mjbyptimp %in% c(60801:60899),]$depnames="Southeast Africa and Indian Ocean islands"


###########################arrreg########################################################
levels(as.factor(data$mjselimp))
data=data[!(data$mjselimp %in% 10000:19999),]
levels(as.factor(data$mjselimp))

data$arrreg=floor(data$mjselimp/10000)
data[data$mjselimp %in% 80200,]$arrreg=NA
data[data$mjselimp %in% 80400,]$arrreg=4

data$arrnames=""
##data[data$arrreg %in% 1,]$arrnames="Europe"
data[data$arrreg %in% 2,]$arrnames="Mainland North America"
data[data$arrreg %in% 3,]$arrnames="Caribbean"
data[data$arrreg %in% 4,]$arrnames="Spanish"
data[data$arrreg %in% 5,]$arrnames="Brazil"
data[data$arrreg %in% 6,]$arrnames="Africa"
data$arrreg=data$arrreg-1

summary(as.factor(data$depreg))
summary(as.factor(data$arrreg))
data$route=data$depreg+data$arrreg

############delete the depnum in the cases of neg or zero loss rate#######################
data[!is.na(data$arrnum)&!is.na(data$depnum)&(data$depnum<=data$arrnum),]$depnum=NA

#########################reserve useful variables##########################################
final=data[,c("id","decade","depnum","arrnum","length","depreg","arrreg","route")]
write.table(final,"needed data_8.txt")
final=data[,c("id","decade","depnum","arrnum","length","depreg","arrreg","route","depnames","arrnames")]
write.csv(final,"8 embarkation.csv")
