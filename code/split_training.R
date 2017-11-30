
# Set Path
path <- "/Users/Kramer/Dropbox/School/Fall/STATS 202/kaggle_project/data/"

# Read full training set
train.full <- read.csv(paste(path, "train.csv", sep = ""), header = TRUE)

# Set fraction of training data to use for model selection
frac <- 0.8

# Randomly sample rows
train.indices <- sample(nrow(train.full), round(frac * nrow(train.full)))

# Split dataset
train.train <- train.full[train.indices,]
train.validate <- train.full[-train.indices,]

# Save results
write.csv(train.train, paste(path, "train_train.csv", sep = ""))
write.csv(train.validate, paste(path, "train_validate.csv", sep = ""))