# Richard Kavanagh 23/05/19


work_dir <- "C:\\workspace\\advanced_data_mining\\datasets"
setwd(work_dir)

set.seed(1337)

titanic_data <- read.csv("titanic.csv", header=T, na.strings=c(""), stringsAsFactors = T)

# extract 
y <- titanic_data$Survived
table(y)

y <-factor(y, levels =c(0,1), labels =c("No", "Yes"))
table(y)

prop.table(table(y))

barplot(table(y), main = "Distribution of Titanic Surivial", ylab="Frequency")

# randomly select 25% of dataset for testing
index <-sample(1:length(y),length(y) * .25, replace=FALSE)
testing <- y[index]
