library(corrplot)
M <- rep$`Sigma_x.cov()`
names(M) <- myVars
row.names(M) <- myVars
corrplot(M)
