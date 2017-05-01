# Sberbank Kaggle Competition
## Overview
This is my repository for the Kaggle competition involving Sberbank,
the state bank of Russia. The objective of this competition is to 
predict realty prices in Russia, and doing so will involve capturing 
complex macroeconomic trends. The deadline is June 29, 2017. 

## Methodology
### Data Cleaning
The `Data Processing.R` code shows how I prepped the data for XGBoost
modeling. 
* Null values are set to `-1e6` 
* Yes/no variables are set to 1/0 
* Training predictors are joined to the macroeconomic variables on the 
`timestamp` field 
* Certain features are selected based on initial gut feelings (i.e.: I 
included variables that included `raion` because they describe features 
of the neighborhood, as described in `data/data_dictionairy.txt`)
	+ Other predictors may be included later, but this will provide 
	an initial look

### Gradient Boosting
My first approach was a standard XGBoost model, which can be seen in the 
`Initial GBM.R` code. , I used `caret` to train another GBM 
using 4-fold cross-validation. I initially used a random parameter search
to provide some guidance on parameter optimization. Root mean squared error
is used as the evaluation metric, but it may be beneficial to use the 
metric by which submissions are scored (RMSLE). 