# Twitter Bot Detection

library(lintr)
library(lubridate)

dir <- "/home/richardk/nci-workspace/modules/advanced_data_mining/project/"
data_set <- "social_honeypot_icwsm_2011"

# set working directory to /advanced_data_mining/labs folder 
setwd(paste(dir,data_set, sep=""))
set.seed(1337)


# ------------- Loading data-sets into R -------------- #

profile_headers <- c("user_id","created_at","collected_at","number_of_followings", "number_of_followers", "number_of_tweets", "length_of_screen_name", "length_of_description_in_user_profile")
tweet_headers <- c("user_id", "tweet_id", "tweet", "created_at")
followings_headers <- c("user_id", "series_of_number_of_followings")

content_polluters <- "content_polluters.txt"
content_polluters_tweets <- "content_polluters_tweets.txt"
content_polluters_followings <- "content_polluters_followings.txt"
  
legitimate_users <- "legitimate_users.txt"
legitimate_users_tweets <- "legitimate_users_tweets.txt"  
legitimate_users_followings <- "legitimate_users_followings.txt"

user_count <- 1
number_rows <- 25
content_polluters_df <- read.csv(content_polluters, header=FALSE, na.strings=c(""), sep="\t", encoding="UTF-8",stringsAsFactors=T, nrows=user_count, col.names=profile_headers)
content_polluters_tweets_df <- read.csv(content_polluters_tweets, header=FALSE, na.strings=c(""), sep="\t", encoding="UTF-8", stringsAsFactors=T, nrows=100, col.names=tweet_headers)
content_polluters_followings_df <- read.csv(content_polluters_followings, header=FALSE, na.strings=c(""), sep="\t", encoding="UTF-8", stringsAsFactors=T, nrows=number_rows, col.names=followings_headers)

legitimate_users_df <- read.csv(legitimate_users, header=FALSE, na.strings=c(""), sep="\t", encoding="UTF-8",stringsAsFactors=T, nrows=number_rows, col.names=profile_headers)
legitimate_users_tweets_df <- read.csv(legitimate_users_tweets, header=FALSE, na.strings=c(""), sep="\t", encoding="UTF-8",stringsAsFactors=T, nrows=number_rows, col.names=tweet_headers)
legitimate_users_followings_df <-read.csv(legitimate_users_followings, header=FALSE, na.strings=c(""), sep="\t", encoding="UTF-8",stringsAsFactors=T, nrows=number_rows, col.names=followings_headers)


# ------------- Loading data-sets into R -------------- #

# ------------- Feature Editing -------------- #

# we don't need to know when these profiles were collected
content_polluters_df$collected_at  <- NULL

# mark as bot for when datasets are merged
content_polluters_df$is_bot <- "True"

# ration of followings over followers
content_polluters_df$following_follower_ratio <- content_polluters_df$number_of_followings / content_polluters_df$number_of_followers 


# avg number of tweets per day
# out of the 1000 bot tweets, 125 should belong to our test bot-profile
# with user-id 6301

for (user_id in content_polluters_df$user_id) {
  
  print(paste("Looking for tweets belonging to user:", user_id))
  
  # get tweets belonging to this user  
  users_tweets_df <- content_polluters_tweets_df[content_polluters_tweets_df$user_id == user_id, ,]
  tweet_count <- nrow(users_tweets_df)
  
  # sort tweets by created_at column
  users_tweets_df <- users_tweets_df[order(users_tweets_df$created_at),] 
  
  # is this working ?  
  min_tweet_date <- users_tweets_df[1,]
  max_tweet_date <- users_tweets_df[tweet_count,]
  
  
}

# twitter_df$avg_tweets_per_day <- 


# ------------- Feature Editing -------------- #










