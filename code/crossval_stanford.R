
#### Libraries ####)
library(tree)
library(gbm)
library(randomForest)
library(tidyverse)


#### Functions ####
calc_RMSE <- function(x, y) {
  sqrt(mean((x - y)^2))
}

kfcv_boost <- function(formula, data, params, k) {
  
  folds <- sample(1:k, nrow(data), replace = TRUE)
  
  results <- params
  results[,"MSE"] <- rep(NA, nrow(params))
  
  for (i in 1:nrow(params)) {
    print(paste0("parameter df row = ", i))    
    temp <- rep(NA, k)
    
    for (j in 1:k) {
      
      fit <- data[folds != j,]
      val <- data[folds == j,]
      
      mod <- gbm(formula, 
                 data = fit, 
                 distribution = "gaussian",
                 n.trees = params[i, "n.trees"],
                 shrinkage = params[i, "shrinkage"],
                 interaction.depth = params[i, "interaction.depth"])
      
      preds <- predict(mod, newdata = val, 
                       n.trees = params[i, "n.trees"])
      temp <- mean((val$Outcome - preds)^2)
    }
    
    results[i, "MSE"] <- mean(temp)

    outpath <- "../data"
    
    if (i == 1) {
      # write.csv(results[i,], file = paste0(outpath, "/cv_results_new.csv"),
      #              col.names = TRUE, row.names = FALSE, append = FALSE)
      
      write.table(results[i,], 
                  file = paste0(outpath, "/cv_results_new.csv"), 
                  sep = ",", 
                  col.names = FALSE, 
                  qmethod = "double", 
                  row.names = FALSE,
                  append = TRUE)
      
      } else {
        # write.csv(results[i,], file = paste0(outpath, "/cv_results_new.csv"),
        #            col.names = FALSE, row.names = FALSE, append = TRUE)
        
        write.table(results[i,], 
                    file = paste0(outpath, "/cv_results_new_test.csv"), 
                    sep = ",", 
                    col.names = FALSE, 
                    qmethod = "double", 
                    row.names = FALSE,
                    append = TRUE)
      }
    }
}


#### Read Data ####
# MATT <- FALSE
# 
# mattswd = '/Users/mathieurolfo/Dropbox/Coterm/Fall 2017-2018/STATS202/kaggle_project'
# samswd <- ".."
# 
# if (MATT) {
#   trainfile = paste(mattswd, '/data/train_train.csv', sep = '')
#   validatefile = paste(mattswd, '/data/train_validate.csv', sep = '')
#   fulltrainfile <- paste(mattswd, '/data/train.csv', sep = '')
#   testfile = paste(mattswd, '/data/test.csv', sep = '')
# } else {
#   trainfile = paste(samswd, '/data/train_train.csv', sep = '')
#   validatefile = paste(samswd, '/data/train_validate.csv', sep = '')
#   fulltrainfile <- paste(samswd, '/data/train.csv', sep = '')
#   testfile = paste(samswd, '/data/test.csv', sep = '')
# }

inpath <- ".."

trainfile = paste(inpath, '/data/train_train.csv', sep = '')
validatefile = paste(inpath, '/data/train_validate.csv', sep = '')
fulltrainfile <- paste(inpath, '/data/train.csv', sep = '')
testfile = paste(inpath, '/data/test.csv', sep = '')

train = read.csv(trainfile, header = TRUE)
validate <- read.csv(validatefile, header = TRUE)
trainFull <- read.csv(fulltrainfile, header = TRUE)
test = read.csv(testfile, header = TRUE)


#### Calculate Floor Area and Volumes ####
train <- train %>%
  mutate(Floor.Area = Surface.Area - Wall.Area - Roof.Area) %>%
  mutate(Volume = Floor.Area * Height)

validate <- validate %>% 
  mutate(Floor.Area = Surface.Area - Wall.Area - Roof.Area) %>%
  mutate(Volume = Floor.Area * Height)

trainFull <- trainFull %>%
  mutate(Floor.Area = Surface.Area - Wall.Area - Roof.Area) %>%
  mutate(Volume = Floor.Area * Height)

test <- test %>% 
  mutate(Floor.Area = Surface.Area - Wall.Area - Roof.Area) %>%
  mutate(Volume = Floor.Area * Height)


#### Clean Data Frame ####

# Remove ID variable and turn Orientation and Glazing.Distr to factors
train <- train %>% 
  select(-ID, -X) %>% 
  mutate(Orientation = as.factor(Orientation),
         Glazing.Distr = as.factor(Glazing.Distr))

validate <- validate %>% 
  select(-ID, -X) %>% 
  mutate(Orientation = as.factor(Orientation),
         Glazing.Distr = as.factor(Glazing.Distr))

trainFull <- trainFull %>% 
  select(-ID) %>% 
  mutate(Orientation = as.factor(Orientation),
         Glazing.Distr = as.factor(Glazing.Distr))

test <- test %>% 
  mutate(Orientation = as.factor(Orientation),
         Glazing.Distr = as.factor(Glazing.Distr))


#### Set Formula ####
curr.formula <- formula(Outcome ~ . -Height -Roof.Area -Floor.Area -Rel.Compact)


#### Set Parameters ####

# shrinkages <- c(0.00001, 0.0001, 0.001, 0.005, 0.01, 0.05, 0.1, 0.25)
shrinkages <- c(0.001)

# num.trees <- c(10000, 20000, 40000, 80000, 160000)
num.trees <- c(20000)

#inter.depths <- c(1:5)
inter.depths <- c(5)

params <- expand.grid(shrinkage = shrinkages, n.trees = num.trees, 
                      interaction.depth = inter.depths)

cv.results <- kfcv_boost(curr.formula, train, params, 5)



#### Write Results
# if (MATT) {
#   outpath <- paste0(mattswd, "/data/")
# } else {
#   outpath <- paste0(samswd, "/data")
# }
outpath <- paste0(inpath, "/data")

write.csv(cv.results, file = paste0(outpath, "/cv_results_final.csv"),
          col.names = TRUE, row.names = FALSE, append = TRUE)






