#Sberbank data processing
library(reshape2)
library(data.table)
library(dplyr)
library(ggplot2)
setwd('C:/Users/Mitch/Desktop/Kaggle/Sberbank/data')

train <- fread('train.csv')
test <- fread('test.csv')
macro <- fread('macro.csv')
colnames(train) <- make.names(colnames(train))
colnames(test) <- colnames(train[,1:291])
train$timestamp <- as.Date(train$timestamp)
macro$timestamp <- as.Date(macro$timestamp)
test$timestamp <- as.Date(test$timestamp)

macro <- macro %>%
  select(timestamp, gdp_annual, gdp_annual_growth, cpi, usdrub, eurrub, 
         starts_with('deposit'), starts_with('mortgage'), income_per_cap, 
         unemployment, employment)

predictors <- train %>%
  select(timestamp, full_sq, life_sq, floor, max_floor, material, build_year, num_room,
         kitch_sq, state, indust_part, contains('raion'), ends_with('km'), starts_with('metro'),
         starts_with('build_count'), ends_with('male'), price_doc) %>%
  mutate(thermal_power_plant_raion = ifelse(thermal_power_plant_raion == 'no', 0, 1),
         incineration_raion = ifelse(incineration_raion == 'no', 0, 1),
         oil_chemistry_raion = ifelse(oil_chemistry_raion == 'no', 0, 1),
         radiation_raion = ifelse(radiation_raion == 'no', 0, 1),
         railroad_terminal_raion = ifelse(railroad_terminal_raion == 'no', 0, 1),
         big_market_raion = ifelse(big_market_raion == 'no', 0, 1),
         nuclear_reactor_raion = ifelse(nuclear_reactor_raion == 'no', 0, 1),
         detention_facility_raion = ifelse(detention_facility_raion == 'no', 0, 1)) %>%
  left_join(macro, by = 'timestamp') 

predictors[is.na(predictors)] <- -1e6

test <- test %>%
  select(timestamp, full_sq, life_sq, floor, max_floor, material, build_year, num_room,
         kitch_sq, state, indust_part, contains('raion'), ends_with('km'), starts_with('metro'),
         starts_with('build_count'), ends_with('male')) %>%
  mutate(thermal_power_plant_raion = ifelse(thermal_power_plant_raion == 'no', 0, 1),
         incineration_raion = ifelse(incineration_raion == 'no', 0, 1),
         oil_chemistry_raion = ifelse(oil_chemistry_raion == 'no', 0, 1),
         radiation_raion = ifelse(radiation_raion == 'no', 0, 1),
         railroad_terminal_raion = ifelse(railroad_terminal_raion == 'no', 0, 1),
         big_market_raion = ifelse(big_market_raion == 'no', 0, 1),
         nuclear_reactor_raion = ifelse(nuclear_reactor_raion == 'no', 0, 1),
         detention_facility_raion = ifelse(detention_facility_raion == 'no', 0, 1)) %>%
  left_join(macro, by = 'timestamp') 


fwrite(predictors, file = 'cleaned_train.csv', row.names = F)
fwrite(test, file = 'cleaned_test.csv', row.names = F)