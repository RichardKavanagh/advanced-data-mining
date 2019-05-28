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
index <- sample(1:length(y),length(y) * .25, replace=FALSE)
testing <- y[index]


# Model 1: Everyone perishes, we just need to know how many No values to produce
perish_model <- rep("No", length(testing))

# Coin-toss model 
coin_model <- round(runif(length(testing), min=0, max=1))
coin_model <- factor(coin_model, levels = c(0,1), labels = c("No", "Yes"))

table(testing, perish_model)
table(testing, coin_model)

# Convert into % of correctly classified instances i.e prediction accuracy
(coin_accuracy <- 1 - mean(coin_model != testing))

(perish_accuracy <- 1 - mean(perish_model != testing))


# distribution of our sample
prop.table(table(testing))


# build and evaluate 1000 models
perish <- c()
coin <- c()

for (i in 1:1000) {
  
  index <- sample(1:length(y), length(y) * .25, replace = FALSE)
  testing <- y[index]
  
  coin_model <- round(runif(length(testing), min=0, max=1))
  coin_model <- factor(coin_model, levels = c(0,1), labels = c("No", "Yes"))
  
  coin[i] <- mean(coin_model != testing)
  perish[i] <- mean(perish_model != testing)
  
}

results  <- data.frame(coin, perish)
names(results) <- c("Coin Toss Accuracy", "Everyone Perishes Accuracy")
summary(results)


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

  womenModel <- predictSurvival(testing)
  women[i] <- 1 - mean(womenModel != testing$Survived)
}

results$`Women Accuracy` <- women 
names(results) <- c("Coin", "All Perish", "Women")
boxplot(results)


# ------ other independent variables age, passanger-class and (woman + children) ------







