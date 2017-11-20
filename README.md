# kaggle_project

## Techniques
+ Splitting training data
	+ Holdout set? 70/30 split? 
	+ 10-fold CV?  
	+ Compare results of some train splits to loss on actual test set?

## Data features
+ ID: just a number. we probably will want to toss this  
+ Rel.Compact: a value between 0.62/1.00, not sure what it represents, takes 12 values
+ Surface.Area: probably area of house, takes 12 values   
+ Wall.Area: also a dimensional variable  
+ Roof.Area: takes 4 values  
+ Height: 2 values. probably 1/2 story house  
+ Orientation: takes 4 values  
+ Glazing.Area: takes 4 values  
+ Glazing.Distribution: takes 6 values  

## Models to try (all regression methods)
[x]    Linear model, all predictors  
[ ]    Linear model, best subset  
[ ]    Linear model, ridge regularization  
[ ]    Linear model, lasso regularization  
[ ]    KNN  
[ ]		PCR  
[ ]    Polynomial model  
[ ]    Smoothing spline  
[ ]    Natural spline  
[ ]		GAM  
[ ]		Regression tree  
[ ]		Bagging/boosting/random forest