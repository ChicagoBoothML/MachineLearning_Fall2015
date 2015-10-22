## text

library(textir)
library(glmnet)
data(we8there)

head(we8thereRatings)
we8thereCounts[1, we8thereCounts[1, ]!=0]            # words in the first review
we8thereCounts[6000, we8thereCounts[6000, ]!=0]      # words in the review 6000

# transform rating into {0, 1}
y = ifelse(we8thereRatings$Overall>3, 1, 0)
y = as.factor(y)

glm_fit = cv.glmnet(x = we8thereCounts, y = y, 
                    family = "binomial",
                    alpha = 1,                        # lasso - 1, ridge - 0
                    nfold = 5
                 )
plot(glm_fit)
plot(glm_fit$glmnet.fit, xvar = "lambda")
abline(v = log(glm_fit$lambda.1se), lty=2, col="red")

glm.coef = coef(glm_fit$glmnet.fit, s=glm_fit$lambda.1se)
o = order( glm.coef, decreasing = TRUE )
# positive coefficients
glm.coef@Dimnames[[1]][o[1:10]]
glm.coef[o[1:10]]
# negative coefficients
glm.coef@Dimnames[[1]][tail(o,10)]
glm.coef[tail(o,10)]