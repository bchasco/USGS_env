library(TMB)
rm(list=ls())
rootDir <- "C:/chasco/PROJECTS/USGS_env/" #root directory
setwd(rootDir)
eStartYr <- 1900 #start year of the environmental data
eLastYr <- 2100 #end year of the environmental data

#Estimated (1 is estimate, 0 is don't estimate)
fsd <- 0 #flag for estiamting the observation error for environmental covariates

reCompile <- TRUE

#marine variables
myVars <- c(
  'ersstArc.win'
  ,'ersstWAcoast.sum'
  ,'ersstArc.spr'
  ,'cui.spr'
  ,"aprmayjunetempLGR"
  ,"aprmayjuneflowLGR"
  # ,"aprmayjunBON.scrollTEMP"
  # ,"aprmayjunFLOW.obs"
)

# #total number of marine variables
nvar <- length(myVars)

load("envData.rData")

if(reCompile){
  try(dyn.unload("env.dll"))
  compile("env.cpp")
}


dyn.load("env.dll")
source("create_DataAndPars.r")
source("create_MapAndObj.r")
source("fig_env_ggplot.r")