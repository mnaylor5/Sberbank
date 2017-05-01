# Cross-validated GBM for Sberbank (using caret)
library(caret)
library(xgboost)
library(plyr)
library(data.table)
library(dplyr)
setwd('C:/Users/Mitch/Desktop/Kaggle/Sberbank')

train <- fread('data/cleaned_train.csv')

params <- expand.grid(eta = c(0.35, 0.4, 0.45),
                      max_depth = 5:6,
                      gamma = 0.4,
                      colsample_bytree = 0.55,
                      min_child_weight = 20,
                      subsample = 0.75,
                      nrounds = c(200, 400, 600))

tc <- trainControl(method = 'cv', 
                   number = 4,
                   allowParallel = TRUE,
                   verboseIter = TRUE)

set.seed(100)
gbm <- train(price_doc ~ .,
             data = train %>% select(-timestamp),
             method = 'xgbTree',
             trControl = tc)

saveRDS(gbm, 'models/cv_gbm.RDS')
