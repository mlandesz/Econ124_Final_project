# Tamar - descriptive statistics and tables
#do it for education, race, and gender
#regression and then scatter plot
rm(list = ls())
library(dplyr)
library(tidyr)
library(ggplot2)

df <- read.csv("cps_00010.csv") #loads the dataset
df <- df[df$AGE >= 22,] #restricts dataset to ages where one typically gets a bachelor's degree
df$college <- ifelse(df$EDUC>=111,1,0) #creates a dummy variable =1 if person has a bachelor's degree (or higher)

#Race Descriptive Statistics
#groupings for race
df$asian_pi <- ifelse(df$RACE >= 650 & df$RACE <= 652,1,0)
df$mixed_ancestry <- ifelse(df$RACE >= 801 & df$RACE<= 999,1,0)

#group variable for race
df$race_group <- 0
df$race_group[df$RACE==100] <- 1 #=1 if person is white
df$race_group[df$RACE==200] <- 2 #=2 if person is Black
df$race_group[df$RACE==300] <- 3 #=3 if person is Native American
df$race_group[df$asian_pi==1] <- 4 #=4 if person is Asian or Pacific Islander
df$race_group[df$mixed_ancestry==1] <- 5 #=5 if person has mixed ancestry of 2 or more races

df$total_white_college <- ifelse(df$race_group==1 & df$college==1,1,0) #=1 if person is white and completed college

tabulate(as.numeric(df$total_white_college)) #calculates the total number of white people in college

df <- df[df$race_group != 1,] #drops white people from the dataset

race_totals <- df %>%
  group_by(race_group) %>%
  summarise(totals=sum(tabulate(race_group))) #data with the total number of each race group
race_college_totals <- df %>%
  group_by(race_group, college) %>%
  summarise(totals=sum(tabulate(race_group))) #data with the total number that completed college of each race

#building dataframe for barplot
race_college_totals2 <- filter(race_college_totals, college == 1)
race_college_barplot_df <- cbind(race_totals, race_college_totals2)
race_college_barplot_df$college_totals <- race_college_barplot_df[,5]
race_college_barplot_df <- subset(race_college_barplot_df, select = -c(3,4,5))
race_college_barplot_df$race_group[race_college_barplot_df$race_group == 2] <- "Black"
race_college_barplot_df$race_group[race_college_barplot_df$race_group == 3] <- "Native-American"
race_college_barplot_df$race_group[race_college_barplot_df$race_group == 4] <- "Asian/Pacific Islander"
race_college_barplot_df$race_group[race_college_barplot_df$race_group == 5] <- "Mixed"

ggplot(data= race_college_barplot_df, aes(x=race_group)) +
  theme(plot.title = element_text(hjust = 0.5)) +
  geom_bar(aes(y=totals), stat="identity", position ="identity", alpha=1, fill='lightblue') +
  geom_bar(aes(y=college_totals), stat="identity", position="identity", alpha=1, fill='palegreen3') +
  ggtitle("Total Number of Individuals Who \n Completed College by Race") +
  xlab("Race Group") +
  ylab("Total Number of Individuals") #plots the total number of people who completed college by race

#Gender Descriptive Statistics
gender_totals <- df %>%
  group_by(SEX) %>%
  summarise(totals=sum(tabulate(SEX))) #data with the total number of each gender
gender_college_totals <- df %>%
  group_by(SEX, college) %>%
  summarise(totals=sum(tabulate(SEX))) #data with the total number that completed college of each gender

#building data frame for barplot
gender_college_totals2 <- filter(gender_college_totals, college == 1)
gender_college_barplot_df <- cbind(gender_totals, gender_college_totals2)
gender_college_barplot_df$college_totals <- gender_college_barplot_df[,5]
gender_college_barplot_df <- subset(gender_college_barplot_df, select = -c(3,4,5))
gender_college_barplot_df$SEX[gender_college_barplot_df$SEX == 1] <- "Men"
gender_college_barplot_df$SEX[gender_college_barplot_df$SEX == 2] <- "Women"

ggplot(data= gender_college_barplot_df, aes(x=SEX)) +
  theme(plot.title = element_text(hjust = 0.5)) +
  geom_bar(aes(y=totals), stat="identity", position ="identity", alpha=1, fill='lightblue') +
  geom_bar(aes(y=college_totals), stat="identity", position="identity", alpha=1, fill='palegreen3') +
  ggtitle("Total Number of Individuals Who \n Completed College by Gender") +
  xlab("Gender") +
  ylab("Total Number of Individuals") #plots the total number of people who completed college by race


#Family Income Descriptive Statistics
#income grouping
quantile(df$FAMINC, probs = c(0.25,0.5,0.75)) #shows the 25th, 50th, and 75th percentiles for family income
df$lowerclass <- ifelse(df$FAMINC <= 720,1,0) #classifies someone as being lower class if their family income is less than or equal to $34,999
df$lowermiddle <- ifelse(df$FAMINC >= 730 & df$FAMINC < 830,1,0) #classifies someone as being lower middle class if their family income is greater than or equal
#to 35,000 and less than $60,000
df$uppermiddle <- ifelse(df$FAMINC >= 830 & df$FAMINC < 842,1,0) #classifies someone as being upper middle class if their family income is greater than or equal 
#to $60,000 and less than $100,000
df$upperclass <- ifelse(df$FAMINC >= 842 & df$FAMINC != 999,1,0) #classifies someone as being upper class if their family income is greater than or equal to
#$100,000

#variable for income group
df$income_group <- 0
df$income_group[df$lowerclass==1] <- 1 #=1 if person is in the lower class
df$income_group[df$lowermiddle==1] <- 2 #=2 if person is in the lower middle class
df$income_group[df$uppermiddle==1] <- 3 #=3 if person is in the upper middle class
df$income_group[df$upperclass==1] <- 4 #=4 if person is in the upper class

income_totals <- df %>%
  group_by(income_group) %>%
  summarise(totals=sum(tabulate(income_group))) #data with the total number of each income group
income_college_totals <- df %>%
  group_by(income_group, college) %>%
  summarise(totals=sum(tabulate(income_group)))  #data with the total number that completed college of each income group

#building dataframe for barplot
income_college_totals2 <- filter(income_college_totals, college == 1)
income_college_barplot_df <- cbind(income_totals, income_college_totals2)
income_college_barplot_df$college_totals <- income_college_barplot_df[,5]
income_college_barplot_df <- subset(income_college_barplot_df, select = -c(3,4,5))
income_college_barplot_df$income_group[income_college_barplot_df$income_group == 1] <- "Lower"
income_college_barplot_df$income_group[income_college_barplot_df$income_group == 2] <- "Lower-Middle"
income_college_barplot_df$income_group[income_college_barplot_df$income_group == 3] <- "Upper-Middle"
income_college_barplot_df$income_group[income_college_barplot_df$income_group == 4] <- "Upper"

ggplot(data= income_college_barplot_df, aes(x=income_group)) +
  theme(plot.title = element_text(hjust = 0.5)) +
  geom_bar(aes(y=totals), stat="identity", position ="identity", alpha=1, fill='lightblue') +
  geom_bar(aes(y=college_totals), stat="identity", position="identity", alpha=1, fill='palegreen3') +
  ggtitle("Total Number of Individuals Who \n Completed College by Income Group") +
  xlab("Income Group") +
  ylab("Total Number of Individuals") #plots the total number of people who completed college by income group
