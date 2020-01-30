myMap <- list(fsd=as.factor(NA))
obj <- MakeADFun(data = data,
                 parameters = parameters,
                 map = myMap,
                 random=c("eps_x"
                 ),
                 silent = FALSE,
                 bias.correct=TRUE,
                 DLL = "env")

out <- nlminb(obj$par,obj$fn,obj$gr)
rep <- obj$report()
SD <- sdreport(obj, getJointPrecision = TRUE)

