# Richard Kavanagh 23/05/19

library(ggplot2)
library(reshape)

work_dir <- "C:\\workspace\\advanced_data_mining\\datasets"
setwd(work_dir)

set.seed(1337)

titanic_data <- read.csv("titanic.csv", header=T, na.strings=c(""), stringsAsFactors = T)

# extract survived array
y <- titanic_data$Survived
table(y)

# convert 1/- to No/Yes values
y <-factor(y, levels =c(0,1), labels =c("No", "Yes"))
table(y)

# proportion of values
prop.table(table(y))

barplot(table(y), main = "Distribution of Titanic Surivial", ylab="Frequency")

# ------ randomly select 25% of dataset for testing ------ 
# 25% of row (grabs array of indexes) 222 values
index <- sample(1:length(y),length(y) * .25, replace=FALSE)
# subset y using those random indexes
testing <- y[index]

# Model 1: Everyone perishes, we just need to know how many No values to produce in array
perish_model <- rep("No", length(testing))
# Strictly speaking we should transform our perish model too
perish_model <- factor(perish_model, levels = c("No", "Yes"), labels = c("No", "Yes")) 

# Coin-toss model, random 1/0 values
coin_model <- round(runif(length(testing), min=0, max=1))
coin_model <- factor(coin_model, levels = c(0,1), labels = c("No", "Yes"))

table(testing, perish_model)
table(testing, coin_model)


# Convert into % of correctly classified instances i.e prediction accuracy
# Coin Accuracy is unsuprisngly roughly accurate 50% of the time
(coin_accuracy <- 1 - mean(coin_model != testing))
# Everyone perish is roughly .65 accurate
(perish_accuracy <- 1 - mean(perish_model != testing))

# but  distribution of our sample is roughly .65 too
prop.table(table(testing))


# build and evaluate 1000 models(i.e 1000 arrays), different test selection each time
perish <- c()
coin <- c()

# no point computing 1000 everyboy perishes model because model is unchanging
for (i in 1:1000) {
  
  index <- sample(1:length(y), length(y) * .25, replace = FALSE)
  testing <- y[index]
  
  coin_model <- round(runif(length(testing), min=0, max=1))
  coin_model <- factor(coin_model, levels = c(0,1), labels = c("No", "Yes"))
  
  coin[i] <- mean(coin_model != testing)
  perish[i] <- mean(perish_model != testing)
  
}

results  <- data.frame(perish, coin)
names(results) <- c("Coin Toss Accuracy", "Everyone Perishes Accuracy")
summary(results)

# How do our models compare?
ggplot(melt(results), mapping = aes (fill = variable, x = value)) + geom_density (alpha = .5)
boxplot(results)


# ------ Using independent variables,  lets assume gender playes a role # ------ 

df <- titanic_data[, c("Survived", "Sex")]
df$Survived <- factor(df$Survived, levels = c(0,1), labels = c("No", "Yes"))
index <- sample(1:dim(df)[1], dim(df)[1] * .75, replace=FALSE)

# split before and after index to get training & testing subsets
training <- df[index, ]
testing <- df[-index, ]

table(training$Survived, training$Sex)


predictSurvival <- function(data) { 
  model <- rep("No", dim(data)[1]) 
  model[data$Sex == 'female'] <- "Yes" 
  return(model) 
}

women <- c()

for (i in 1:1000) {
  index <- sample(1:dim(df)[1], dim(df)[1] * .75, replace=FALSE) 
  testing <- df[-index, ]

  woman_model <- predictSurvival(testing)
  women[i] <- 1 - mean(woman_model != testing$Survived)
}

results$`Women Accuracy` <- women 
names(results) <- c("Coin", "All Perish", "Women")
boxplot(results)


# ------ other independent variables age, passanger-class and (woman + children) ------







