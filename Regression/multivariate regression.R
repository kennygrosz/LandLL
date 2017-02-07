library(xlsx)
setwd("/Users/lorenzgahn/Documents/CaamSeniorDesign")
dat = read.xlsx("features_mega_matrix.xlsx", 1)
xx = dat[,c('TTP','StdD.Pre_ATROPOS_GMM','StdD.Pre_ATROPOS_GMM_ELONGATION','StdD.Pre_ATROPOS_GMM_PHYSICAL_VOLUME','StdD.Pre_ATROPOS_GMM_POSTERIORS1')]


# this is the data that boruta selected
A = subset(dat, select=c("StdD.Pre_ATROPOS_GMM","TTP"))
B = subset(dat, select=c("StdD.Pre_ATROPOS_GMM_ELONGATION","TTP"))
C = subset(dat, select=c("StdD.Pre_ATROPOS_GMM_PHYSICAL_VOLUME","TTP"))
D = subset(dat, select=c("StdD.Pre_ATROPOS_GMM_POSTERIORS1","TTP"))

# better data - best linear regression fits

W = subset(dat, select=c("Mean.Del_ATROPOS_GMM_POSTERIORS1","TTP"))
X = subset(dat, select=c("StdD.Del_ATROPOS_GMM_PHYSICAL_VOLUME","TTP"))
Y = subset(dat, select=c("StdD.Del_SIGMA_RADIUS_3","TTP"))
Z = subset(dat, select=c("StdD.Del_SIGMA_RADIUS_1","TTP"))

# one dataframe of the better data, no variable in X
mult = subset(dat, select=c("Mean.Del_ATROPOS_GMM_POSTERIORS1","StdD.Del_SIGMA_RADIUS_3","StdD.Del_SIGMA_RADIUS_1","TTP"))
samplevec = seq(1,20)
testindex = sample(samplevec, 4, replace = FALSE, prob = NULL)
trainindex = setdiff(samplevec,testindex)

test_mult = mult[testindex, ]
train_mult = mult[trainindex, ]
# training fit
#linfit = lm(formula = TTP ~ Mean.Del_ATROPOS_GMM_POSTERIORS1 + StdD.Del_SIGMA_RADIUS_3 + StdD.Del_SIGMA_RADIUS_1, data = train_mult) 
# entire fit
linfit = lm(formula = TTP ~ Mean.Del_ATROPOS_GMM_POSTERIORS1 + StdD.Del_SIGMA_RADIUS_3 + StdD.Del_SIGMA_RADIUS_1, data = mult) 
summary(linfit) 
predict(linfit)
coeff = summary(linfit)$coefficients[1:3]


test_W = W[testindex, ]
train_W = W[trainindex, ]
test_X = X[testindex, ]
train_X = X[trainindex, ]
test_Y = Y[testindex, ]
train_Y = Y[trainindex, ]
test_Z = Z[testindex, ]
train_Z = Z[trainindex, ]

# for example
plot(train_W,col="red")
points(test_W,col="blue")
abline(lm(TTP ~ Mean.Del_ATROPOS_GMM_POSTERIORS1,data=train_W))

# normal multivariable - no cross validation
test = lm(formula = TTP ~ Mean.Del_ATROPOS_GMM_POSTERIORS1 + StdD.Del_ATROPOS_GMM_PHYSICAL_VOLUME + StdD.Del_SIGMA_RADIUS_3 + StdD.Del_SIGMA_RADIUS_1, data = multimodel) 
summary(test) 

# kenny variables
#age
#Mean.Del_ATROPOS_GMM_PHYSICAL_VOLUME
#Mean.Del_SIGMA_RADIUS_1
#Mean.Del_SIGMA_RADIUS_3
#StdD.Pre_MEAN_RADIUS_1
#StdD.Ven_ATROPOS_GMM_POSTERIORS3
#StdD.Del_ATROPOS_GMM_PHYSICAL_VOLUME

#plot(A)
#abline(lm(TTP ~ StdD.Pre_ATROPOS_GMM,data=A))
#plot(B)
#abline(lm(TTP ~ StdD.Pre_ATROPOS_GMM_ELONGATION,data=B))
#plot(C)
#abline(lm(TTP ~ StdD.Pre_ATROPOS_GMM_PHYSICAL_VOLUME,data=C))
#plot(D)
#abline(lm(TTP ~ StdD.Pre_ATROPOS_GMM_POSTERIORS1,data=D))

