library(sqldf)
library(tidyverse)
library(RODBC)
library(lubridate)

##Question 1

#Reading in the CSV
BP <- read_csv("C:/Users/lroze_000/OneDrive/Documents/QBS 181/IC_BP_v2.csv")

#Checking for missing values
colSums(is.na(BP))

###Part A.) 

#Renaming BPAlerts to BPStatus
BP <- BP %>%
  rename(BPStatus = BPAlerts)
#Showing ten random rows
(BP[sample(nrow(BP),10),])

### Part B.) 

#Changing values of BPStatus to be either controlled or uncontrolled
BP <- BP %>%
  mutate(BPStatus1 = sapply(BPStatus, function(x){
    if(x == "Normal"|x == "Hypo1"){
      return("Controlled BP")
    }
    else{
      return("Uncontrolled BP")
    }
  }
  )
  )
(BP[sample(nrow(BP),10),])
#Keying controlled BP as 1 and uncontrolled as 0
BP <- BP %>%
  mutate(BPStatus2 = sapply(BPStatus1, function(x){
    if(x == "Controlled BP"){
      return(1)
    }
    else{
      return(0)
    }
  }
  )
  )

(BP[sample(nrow(BP),10),])
#Dropping extraneous columns
BP <- BP%>%
  select(-c(BPStatus, BPStatus1))
BP <- BP%>%
  rename(BPStatus = BPStatus2)

(BP[sample(nrow(BP),10),])

### Part C.) 

#Calling in the demographics table
myconn <- odbcConnect("dartmouth", "lrozema", "lrozema@qbs181")
Demo <- sqlQuery(myconn, "select * from demographics")
#Joining the two tables using dplyr
BP.demo <- inner_join(BP, Demo, by = c("ID" = "contactid"))
BP.demo$tri_enrollmentcompletedate <- mdy(BP.demo$tri_enrollmentcompletedate)
(BP.demo[sample(nrow(BP.demo),10),])

### Part D.) 

#Converting observed time to date:
BP.demo$ObservedTime <- as.Date(BP.demo$ObservedTime, origin = "1900-01-01")
(BP.demo[sample(nrow(BP.demo),10),])
#Creating a variable that corresponds to a 12 week group based on the minimum 
#date for a given person
BP.demo.1 <- BP.demo%>%
  group_by(ID)%>%
  mutate(twelve.week.interval = cut.Date(ObservedTime, 
                                         breaks = "12 weeks", 
                                         labels = F))
(BP.demo.1[sample(nrow(BP.demo.1),10),])
#Averaging based on ID and twelve week interval
BP.demo.2 <- BP.demo.1%>%
  group_by(ID, twelve.week.interval)%>%
  summarize(SYSBP = mean(SystolicValue), 
            DIABP = mean(Diastolicvalue), 
            BPStatus = mean(BPStatus)) 
(BP.demo.2[sample(nrow(BP.demo.2),10),])

### Part E.) 

#Now I will only look at the 12 week period to see how patients progressed
#during the first 12 weeks
BP.demo.3 <- BP.demo.1%>%
  filter(twelve.week.interval == 1)
(BP.demo.3[sample(nrow(BP.demo.3),10),])
#Looking at change between min date in the first 12 weeks and max date in the first 
#12 weeks
BP.demo.4 <- BP.demo.3%>%
  group_by(ID)%>%
  summarize(SYSBPdiff = SystolicValue[which.min(ObservedTime)]-SystolicValue[which.max(ObservedTime)],
            DIASBPdiff = Diastolicvalue[which.min(ObservedTime)]-Diastolicvalue[which.max(ObservedTime)],
            BPStatusdiff = BPStatus[which.min(ObservedTime)]-BPStatus[which.max(ObservedTime)])

(BP.demo.4[sample(nrow(BP.demo.4),10),])

### Part F.)

#Looking at the total amount of people that changed from uncontrolled to controlled
#From the question we are only looking for those who were controlled at the 
#end of 12 weeks, people who relapsed do not count
table(BP.demo.4$BPStatusdiff)

#Those with a -1 went from uncontrolled (0) to controlled(1), so 29 in total. 

## Question 3

#Calling in the datasets:
Cond <- sqlQuery(myconn, "select * from conditions")
Text <- sqlQuery(myconn, "select * from textmessages")
#Merging the datasets:
demo.con <- inner_join(Demo, Cond, by = c("contactid" = "tri_patientid"))
demo.con.text <- inner_join(demo.con, Text, by = c("contactid" = "tri_contactId"))
demo.con.text$TextSentDate <- mdy(demo.con.text$TextSentDate)
#This will group by the contact id then filter to only contain max text sent date
#It will then remove any duplicate rows representing a person having two 
#messages sent on the same max date. 
demo.con.text.1 <- demo.con.text%>%
  group_by(contactid)%>%
  filter(TextSentDate == max(TextSentDate, na.rm = TRUE))%>%
  distinct(contactid, .keep_all = TRUE)
(demo.con.text.1[sample(nrow(demo.con.text.1),10),])