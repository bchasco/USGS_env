library(ggplot2)
env <- as.matrix(data$env)
env[env==(-10000)] <- NA
ny <- length(eStartYr:eLastYr)

g_dat <- data.frame(yr=rep(eStartYr:eLastYr, length(myVars)),
                    var = rep(myVars, each=ny),
                    obs = c(env),
                    pred = SD$value,
                    sd_pos = SD$value + 1.96*SD$sd,
                    sd_neg = SD$value - 1.96*SD$sd)

p <- ggplot(data=g_dat, aes(x=yr, y = pred)) +
  geom_line() +
  facet_wrap(~var, nrow=2) +
  geom_point(aes(x=yr, y=obs)) + 
  geom_ribbon(aes(ymin = sd_neg,
                  ymax = sd_pos),
              fill = "grey70")

print(p)
  