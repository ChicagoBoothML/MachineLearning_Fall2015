rm(list = ls())

library(depmixS4)
library(TTR)
library(xts)

## Bull and Bear Markets ##
# Load S&P 500 returns
Sys.setenv(tz = "UTC")
sp500 <- getYahooData("^GSPC", start = 19500101, end = 20120909, freq = "daily")

# Preprocessing
ep <- endpoints(sp500, on = "months", k = 1)
sp500 <- sp500[ep[2:(length(ep)-1)]]
sp500$logret <- log(sp500$Close) - lag(log(sp500$Close))
sp500 <- na.exclude(sp500)

# Plot the S&P 500 returns
plot(sp500$logret, main = "S&P 500 log Returns")

# Regime switching model
mod <- depmix(logret ~ 1, family = gaussian(), nstates = 4, data = sp500)
set.seed(1)
fm2 <- fit(mod, verbose = FALSE)
# Initial probabilities
summary(fm2, which = "prior")
# Transition probabilities
summary(fm2, which = "transition")
# Reponse/emission function
summary(fm2, which = "response")

# Classification (inference task)
tsp500 <- as.ts(sp500)
pbear <- as.ts(posterior(fm2)[, 2])
tsp(pbear) <- tsp(tsp500)
plot(cbind(tsp500[, 6], pbear),
     main = "Posterior Probability of State=1 (Volatile, Bear Market)")

map.bear <- as.ts(posterior(fm2)[, 1] == 1)
tsp(map.bear) <- tsp(tsp500)
plot(cbind(tsp500[, 6], map.bear),
     main = "Maximum A Posteriori (MAP) State Sequence")
