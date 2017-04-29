#Initial GBM for Sberbank competition
library(xgboost)
setwd('C:/Users/Mitch/Desktop/Kaggle/Sberbank')

train <- fread('data/cleaned_train.csv')

train.matrix <- model.matrix(~ . - 1, data = train %>% select(-c(price_doc, timestamp)))
train.xgb <- xgb.DMatrix(train.matrix, label = train$price_doc, missing = -1e6)

set.seed(100)
model1 <- xgb.train(data = train.xgb,
                    eta = 0.3,
                    nrounds = 200,
                    gamma = 0.8,
                    colsample_bytree = 0.9,
                    max_depth = 7,
                    objective = 'reg:linear',
                    eval_metric = 'rmse')
model1
imp <- xgb.importance(model1, feature_names = colnames(train.matrix))
xgb.ggplot.importance(imp[1:25,])
