
library(tidyverse)
library(SASxport)
library(fastDummies)
library(sqldf)

#Reading in the DIQ.I.xpt datafile using the SASxport package:
DIQ <- read.xport("C:/Users/lroze_000/OneDrive/Documents/QBS 181/DIQ_I.xpt")

# Doing some exploratory data analysis to get a feel for the data:
view(DIQ)
colSums(is.na(DIQ))
colSums(is.na(DIQ))/nrow(DIQ)
str(DIQ)

#Confirming the counts within the data library
table(DIQ$DID040)
sqldf("SELECT count(DID040) from DIQ where DID040 < 100")
#Setting all of the values representing unknowns to missing values
DIQ$DID040[DIQ$DID040==999] <- NA

#666 represents "less than 1 year old" so I have decided to model this as 0
#As there is only one of them. 
DIQ$DID040[DIQ$DID040==666] <- 0

#Checking whether mean or median would be best for imputation
plot(density(DIQ$DID040, na.rm= TRUE))

#Median imputation
DIQ$DID040 <- replace_na(DIQ$DID040, median(DIQ$DID040, na.rm = TRUE))

#Checking the values within the library
table(DIQ$DIQ170)

#Converting Missing Values
DIQ$DIQ170 <- replace_na(DIQ$DIQ170, 9)

#Checking counts in library
table(DIQ$DIQ172)

#Converting refuses to unknown value
DIQ$DIQ172[DIQ$DIQ172==7] <- 9

#Converting missing values to unknown value
DIQ$DIQ172 <- replace_na(DIQ$DIQ172, 9)

#Checking Counts
table(DIQ$DIQ180)

#Converting refusals to unknowns
DIQ$DIQ180[DIQ$DIQ180==7] <- 9

#Replacing missing values with unknown value
DIQ$DIQ180 <- replace_na(DIQ$DIQ180, 9)

#Checking Counts
table(DIQ$DIQ050)

#Converting refusals to unknowns
DIQ$DIQ050[DIQ$DIQ050==7] <- 9

#Converting missing values to placeholder unknown value
DIQ$DIQ050 <- replace_na(DIQ$DIQ050, 9)

#Confirming counts
table(DIQ$DID060)
sqldf("SELECT count(DID060) from DIQ where DID060 < 666")

#Converting refusals and unknowns to missing values so I can exclude them easily
#in calculations and have them all grouped together
DIQ$DID060[DIQ$DID060==999] <- NA
DIQ$DID060[DIQ$DID060==666] <- NA

#Replacing missing values with 0 to prevent error from occuring
DIQ$DID060 <- replace_na(DIQ$DID060, 0)
DIQ$DIQ060U <- replace_na(DIQ$DIQ060U, 0)

#Converting years to months based on the unit column
DIQ$DID060[DIQ$DIQ060U == 2] <- DIQ$DID060[DIQ$DIQ060U == 2]*12

#Converting placeholder back to missing values
DIQ$DID060[DIQ$DID060==0] <- NA

#median imputing missing values
DIQ$DID060 <- replace_na(DIQ$DID060, median(DIQ$DID060, na.rm = TRUE))

#Confirming Counts
table(DIQ$DIQ070)

#Replacing refusals with unknown placeholder value
DIQ$DIQ070[DIQ$DIQ070==7] <- 9

#Converting missing values to unknown placeholder
DIQ$DIQ070 <- replace_na(DIQ$DIQ070, 9)

#Confirming counts
table(DIQ$DIQ230)

#Converting missing values to unknown placeholder
DIQ$DIQ230 <- replace_na(DIQ$DIQ230, 9)

#Checking Counts
table(DIQ$DIQ240)

#Replacing missing values
DIQ$DIQ240 <- replace_na(DIQ$DIQ240, 9)

#Confirming counts in dictionary
table(DIQ$DID250)
sqldf("SELECT count(DID250) from DIQ where DID250 < 100")

#Converting unknown placeholder to missing value for easy exclusion
DIQ$DID250[DIQ$DID250==9999] <- NA

#Checking whether median or mean is better
plot(density(DIQ$DID250, na.rm = TRUE))

#Median imputation
DIQ$DID250 <- replace_na(DIQ$DID250, median(DIQ$DID250, na.rm = TRUE))

#Checking counts
table(DIQ$DID260)
sqldf("SELECT count(DID260) from DIQ where DID040 < 500")
table(DIQ$DIQ260U)

#first remove NAs to prevent errors from occuring
DIQ$DID260 <- replace_na(DIQ$DID260, 999)
DIQ$DIQ260U <- replace_na(DIQ$DIQ260U, 999)

#Converting based on units column
DIQ$DID260[DIQ$DIQ260U == 2] <- DIQ$DID260[DIQ$DIQ260U == 2]*7

DIQ$DID260[DIQ$DIQ260U == 3] <- DIQ$DID260[DIQ$DIQ260U == 3]*30.44

DIQ$DID260[DIQ$DIQ260U == 4] <- DIQ$DID260[DIQ$DIQ260U == 4]*365.25

table(DIQ$DID260)

#Put the NA's back in
DIQ$DID260[DIQ$DID260 == 999] <- NA

#Median imputate the NA's
DIQ$DID260 <- replace_na(DIQ$DID260, median(DIQ$DID260, na.rm = TRUE))

#Then remove the units column
DIQ$DIQ260U <- c()

#Check counts
table(DIQ$DIQ275)

#Replace missing values
DIQ$DIQ275 <- replace_na(DIQ$DIQ275, 9)

#Check counts
table(DIQ$DIQ280)
sqldf("SELECT count(DIQ280) from DIQ where DIQ280 < 100")

#Standardize missing values
DIQ$DIQ280[DIQ$DIQ280 == 999] <- NA
DIQ$DIQ280[DIQ$DIQ280 == 777] <- NA

#Checking whether mean or median is best
plot(density(DIQ$DIQ280, na.rm = TRUE))

#Mean imputation
DIQ$DIQ280 <- replace_na(DIQ$DIQ280, mean(DIQ$DIQ280, na.rm = TRUE))

#Checking counts
table(DIQ$DIQ291)

#Standardizing missing values
DIQ$DIQ291[DIQ$DIQ291==6] <- 99
DIQ$DIQ291[DIQ$DIQ291==77] <- 99
DIQ$DIQ291 <- replace_na(DIQ$DIQ291, 99)

#Checking counts
table(DIQ$DIQ300S)
sqldf("SELECT count(DIQ300S) from DIQ where DIQ300S < 1000")

#Standardize missing values
DIQ$DIQ300S[DIQ$DIQ300S == 9999] <- NA
DIQ$DIQ300S[DIQ$DIQ300S == 7777] <- NA

#Check distribution
plot(density(DIQ$DIQ300S, na.rm = TRUE))

#Mean imputation
DIQ$DIQ300S <- replace_na(DIQ$DIQ300S, mean(DIQ$DIQ300S, na.rm = TRUE))

#Identical process as for DIQ300S
table(DIQ$DIQ300D)
sqldf("SELECT count(DIQ300D) from DIQ where DIQ300D < 1000")

DIQ$DIQ300D[DIQ$DIQ300D == 9999] <- NA
DIQ$DIQ300D[DIQ$DIQ300D == 7777] <- NA

plot(density(DIQ$DIQ300D, na.rm = TRUE))

DIQ$DIQ300D <- replace_na(DIQ$DIQ300D, mean(DIQ$DIQ300D, na.rm = TRUE))

#Checking counts
table(DIQ$DID310S)
sqldf("SELECT count(DID310S) from DIQ where DID310S < 1000")

#Standardize missing values
DIQ$DID310S[DIQ$DID310S == 9999] <- NA
DIQ$DID310S[DIQ$DID310S == 6666] <- NA
DIQ$DID310S[DIQ$DID310S == 7777] <- NA

#Check whether mean or median would be better
plot(density(DIQ$DID310S, na.rm = TRUE))

#Median imputation
DIQ$DID310S <- replace_na(DIQ$DID310S, median(DIQ$DID310S, na.rm = TRUE))

#Exact same as DID310S
table(DIQ$DID310D)
sqldf("SELECT count(DID310D) from DIQ where DID310D < 1000")

DIQ$DID310D[DIQ$DID310D == 9999] <- NA
DIQ$DID310D[DIQ$DID310D == 6666] <- NA
DIQ$DID310D[DIQ$DID310D == 7777] <- NA

plot(density(DIQ$DID310D, na.rm = TRUE))

DIQ$DID310D <- replace_na(DIQ$DID310D, median(DIQ$DID310D, na.rm = TRUE))

#Checking counts
table(DIQ$DID320)
sqldf("SELECT count(DID320) from DIQ where DID320 < 1000")

#Standardized missing values
DIQ$DID320[DIQ$DID320 == 9999] <- NA
DIQ$DID320[DIQ$DID320 == 7777] <- NA
DIQ$DID320[DIQ$DID320 == 6666] <- NA
DIQ$DID320[DIQ$DID320 == 5555] <- NA

#Check distribution
plot(density(DIQ$DID320, na.rm = TRUE))

#Median impute
DIQ$DID320 <- replace_na(DIQ$DID320, median(DIQ$DID320, na.rm = TRUE))

#Checking counts
table(DIQ$DID330)

#Removing column
DIQ$DID330 <- c()

#Checking counts
table(DIQ$DID341)
sqldf("SELECT count(DID341) from DIQ where DID341 < 1000")

#Standardize missing values
DIQ$DID341[DIQ$DID341 == 9999] <- NA
DIQ$DID341[DIQ$DID341 == 7777] <- NA

#Check distribution to seen whether mean or median imputation is better
plot(density(DIQ$DID341, na.rm = TRUE))

#median impute
DIQ$DID341 <- replace_na(DIQ$DID341, median(DIQ$DID341, na.rm = TRUE))

#Checking counts
table(DIQ$DID350)
sqldf("SELECT count(DID350) from DIQ where DID350 < 1000")
table(DIQ$DIQ350U)

#Standardize NA values
DIQ$DID350 <- replace_na(DIQ$DID350, 9999)
DIQ$DIQ350U <- replace_na(DIQ$DIQ350U, 9999)

#Converting based on the unit variable
DIQ$DID350[DIQ$DIQ350U == 2] <- DIQ$DID350[DIQ$DIQ350U == 2]*7
DIQ$DID350[DIQ$DIQ350U == 3] <- DIQ$DID350[DIQ$DIQ350U == 3]*30.44
DIQ$DID350[DIQ$DIQ350U == 4] <- DIQ$DID350[DIQ$DIQ350U == 4]*365.25

#Bringing the unknown value placeholder to NA
DIQ$DID350[DIQ$DID350 == 9999] <- NA
DIQ$DIQ350U[DIQ$DIQ350U == 9999] <- NA

#Median imputation
DIQ$DID350 <- replace_na(DIQ$DID350, median(DIQ$DID350, na.rm = TRUE))

#Removing the units column
DIQ$DIQ350U <- c()

#Checking counts
table(DIQ$DIQ360)

#NA replacement
DIQ$DIQ360 <- replace_na(DIQ$DIQ360, 9)

#Checking counts
table(DIQ$DIQ080)

#NA replacement
DIQ$DIQ080 <- replace_na(DIQ$DIQ080, 9)

sum(is.na(DIQ))

LETTERS1 <- LETTERS[1:24]

#Creating a vector of all the column names
Vars <- paste0("DIQ175", LETTERS1)

#Replacing any non-zero number in all of the columns with 1
DIQ[,Vars][DIQ[,Vars]>1] <- 1

#Replacing all NA's with 0
DIQ[,Vars][is.na(DIQ[,Vars])==TRUE] <- 0

#Checking Counts
colSums(DIQ[,Vars])

#First, I am making a vector of all of the column names that I want one hot encoded
Vars.Ohe <- c("DIQ010","DIQ160", "DIQ170", "DIQ172", "DIQ180", "DIQ050", "DIQ070", "DIQ230", "DIQ240", "DIQ275", "DIQ291", "DIQ360", "DIQ080")

#Then I will use the dummy_cols function
DIQ.OHE <- dummy_cols(DIQ, select_columns = Vars.Ohe)
view(DIQ.OHE)

#Looks like it worked, now I'll remove all of the null columns
DIQ.OHE$DIQ010_9 <- c()
DIQ.OHE$DIQ160_9 <- c()
DIQ.OHE$DIQ170_9 <- c()
DIQ.OHE$DIQ172_9 <- c()
DIQ.OHE$DIQ180_9 <- c()
DIQ.OHE$DIQ050_9 <- c()
DIQ.OHE$DIQ070_9 <- c()
DIQ.OHE$DIQ230_9 <- c()
DIQ.OHE$DIQ240_9 <- c()
DIQ.OHE$DIQ275_9 <- c()
DIQ.OHE$DIQ291_99 <- c()
DIQ.OHE$DIQ360_9 <- c()
DIQ.OHE$DIQ080_9 <- c()

#Now I will remove the original columns that have been one hot encoded
DIQ.OHE$DIQ010 <- c()
DIQ.OHE$DIQ160<- c()
DIQ.OHE$DIQ170 <- c()
DIQ.OHE$DIQ172 <- c()
DIQ.OHE$DIQ180 <- c()
DIQ.OHE$DIQ050 <- c()
DIQ.OHE$DIQ070 <- c()
DIQ.OHE$DIQ230 <- c()
DIQ.OHE$DIQ240 <- c()
DIQ.OHE$DIQ275 <- c()
DIQ.OHE$DIQ291 <- c()
DIQ.OHE$DIQ360 <- c()
DIQ.OHE$DIQ080 <- c()

write_csv(DIQ.OHE, "C:/Users/lroze_000/OneDrive/Documents/QBS 181/lrozema_Midterm_QBS181.csv")