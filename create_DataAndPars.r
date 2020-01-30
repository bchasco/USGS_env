library(TMB)
library(mvtnorm)
library(matrixcalc)
library(corpcor)


tmpenv <- envdata[envdata$year>=eStartYr & envdata$year<=eLastYr,]
if(eLastYr>max(envdata$year)){
  projEnv <- as.data.frame(matrix(NA,eLastYr-max(envdata$year),ncol(envdata)))
  projEnv[,1] <- (max(envdata$year)+1):eLastYr
  names(projEnv) <- names(tmpenv)
  tmpenv <- rbind(tmpenv,projEnv)
}
names(tmpenv)[1] <- "Year"

# Jinky step to get the most recent coastal summer data
load(paste0("envData_7302018.Rdata"))
tmpenv$ersstWAcoast.sum[tmpenv$year%in%envdata$Year] <- envdata$ersstWAcoast.sum[tmpenv$year%in%envdata$Year]

#Get the scaling data
env_mu <- apply(tmpenv,2,function(x){return(mean(na.omit(x)))})
env_sc <- apply(tmpenv,2,function(x){return(sd(na.omit(x)))})

#Rescale variables and years
tmpenv[,names(tmpenv)!="Year"] <- t((t(tmpenv[,names(tmpenv)!="Year"]) - env_mu[names(tmpenv)!="Year"])/env_sc[names(tmpenv)!="Year"])
tmpenv$Year <- tmpenv$Year - eStartYr

subData <- tmpenv[,myVars]
subData[is.na(subData)] <- -10000

CO2 <- read.table("CO2.dat", header=F)
CO2proj <- CO2[CO2[,1]%in%(eStartYr:eLastYr),2]

data <- list(CO2 = CO2[,2]
             ,nvar = nvar
             ,env = as.matrix(subData)
             ,env_mu = as.vector(env_mu[myVars])
             ,env_sc = as.vector(env_sc[myVars])
)

env_mu <- apply(tmpenv,2,function(x){return(mean(na.omit(x)))})
env_sc <- apply(tmpenv,2,function(x){return(sd(na.omit(x)))})

parameters <- list(fsd=log(0.0001),
                   slope = rep(0,ncol(data$env))
                   ,alpha = rep(0,ncol(data$env))
                   ,frho_x = rep(0)
                   ,frho_Rx = rep(0,nvar*(nvar-1)/2)
                   ,fpsi_x = rep(0,nvar)
                   ,eps_x = matrix(0,nvar,length(eStartYr:eLastYr))
)

pt <- Sys.time()
