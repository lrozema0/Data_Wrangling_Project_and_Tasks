library(RODBC)
library(tidyverse)
library(sqldf)
library(tinytex)
library(lubridate)
library(ggthemes)

#Creating the connection
myconn <- odbcConnect("dartmouth", "lrozema", "lrozema@qbs181")

#Reading in the dataset from the database
Phonecall <- sqlQuery(myconn, "select * from Phonecall_Encounter")

#Adding and updating the values of a new column based on encounter
Phonecall1 <- sqldf(c(("ALTER table Phonecall add EncounterGroup nvarchar"),("select * from Phonecall")))

Phonecall1 <- sqldf(c("UPDATE Phonecall1 set EncounterGroup = 'Clinical Alert' where EncounterCode = 125060000", "select * from Phonecall1"))

Phonecall1 <- sqldf(c("UPDATE Phonecall1 set EncounterGroup = 'Health Coaching' where EncounterCode = 125060001", "select * from Phonecall1"))

Phonecall1 <- sqldf(c("UPDATE Phonecall1 set EncounterGroup = 'Technical Question' where EncounterCode = 125060002", "select * from Phonecall1"))

Phonecall1 <- sqldf(c("UPDATE Phonecall1 set EncounterGroup = 'Administrative' where EncounterCode = 125060003", "select * from Phonecall1"))

Phonecall1 <- sqldf(c("UPDATE Phonecall1 set EncounterGroup = 'Other' where EncounterCode = 125060004", "select * from Phonecall1"))

Phonecall1 <- sqldf(c("UPDATE Phonecall1 set EncounterGroup = 'Lack of Engagement' where EncounterCode = 125060005", "select * from Phonecall1"))

(Phonecall1[sample(nrow(Phonecall1),10),])

#Getting the number of records per each enrollment group
table(Phonecall1$EncounterGroup)

CallDuration <- sqlQuery(myconn, "Select * from CallDuration")

#Merging the two datasets by ID
PhonecallMerged <- sqldf("select A.*, B.* from Phonecall1 A
                               Inner join CallDuration B
                               on A.CustomerId=B.tri_CustomerIDEntityReference")

(PhonecallMerged[sample(nrow(PhonecallMerged),10),])

#Finding the counts of each call type
Calltypes <- PhonecallMerged%>%
  group_by(CallType)%>%
  summarize(table(CallType))

#Finding the counts of each call outcome
CallOutcomes <- PhonecallMerged%>%
  group_by(CallOutcome)%>%
  summarize(table(CallOutcome))

#Cleaning up the dataframes created above
Calltypes$CallType <- c("Inbound", "Outbound")
CallOutcomes$CallOutcome <- c("No Response", "Left Voicemail","Successful")
names(Calltypes) <- c("CallType","Records")
names(CallOutcomes) <- c("CallOutcome","Records")
(Calltypes)
(CallOutcomes)

#Finding different measures of call duration per enrollment group
CallDurationGroups <- PhonecallMerged%>%
  group_by(EncounterGroup)%>%
  summarize(TotalCallDuration = sum(CallDuration), 
            MeanCallDuration = mean(CallDuration),
            MedianCallDuration = median(CallDuration))

#Loading in the datasets from the database
Demographics <- sqlQuery(myconn, "select * from demographics")
Conditions <- sqlQuery(myconn, "select * from conditions")
TextMessages <- sqlQuery(myconn, "select * from TextMessages")

#Merging the datasets based on ID
temmp <- merge(Demographics, Conditions, by.x="contactid", by.y='tri_patientid')
DemoConText <- merge(temmp, TextMessages, by.x = 'contactid', by.y='tri_contactId')
DemoConText$TextSentDate <- as.Date(DemoConText$TextSentDate, "%m/%d/%y")
DemoConText$TextSentWeek <- floor_date(DemoConText$TextSentDate, unit = "week")


(DemoConText[sample(nrow(DemoConText),10),])


#Finding the number of texts sent per week per sender type
TextsPerWeek <- DemoConText %>%
  group_by(TextSentWeek)%>%
  summarize(SystemCount = length(which(SenderName == "System")),
            CustomerCount = length(which(SenderName == "Customer")),
            ClinicianCount = length(which(SenderName == "Clinician")), 
            Total = table(TextSentWeek))

(TextsPerWeek[sample(nrow(TextsPerWeek),10),])

#Plotting the amount of texts per week by sender
ggplot(DemoConText, aes(x = TextSentWeek, fill = SenderName))+
  geom_bar()+
  theme_tufte()+
  labs(x = "Week", y = "Number of Texts Sent", 
       fill = "Sender", title = "Number of Texts Sent Per Week by Sender")

#Checking the values that conditions can take
summary(DemoConText$tri_name)

#Getting the number of texts per week by condition
TextsPerWeekConditions <- DemoConText %>%
  group_by(TextSentWeek)%>%
  summarize(ActivityMonitoring = length(which(tri_name == "Activity Monitoring")),
            CHF = length(which(tri_name == "Congestive Heart Failure")),
            COPD = length(which(tri_name == "COPD")),
            Diabetes = length(which(tri_name == "Diabetes")),
            Hypertension = length(which(tri_name == "Hypertension")),
            Total = table(TextSentWeek))

(TextsPerWeekConditions[sample(nrow(TextsPerWeekConditions),10),])

#Plotting the relationship above
ggplot(DemoConText, aes(x = TextSentWeek, fill = tri_name))+
  geom_bar()+
  theme_tufte()+
  labs(x = "Week", y = "Number of Texts Sent", fill = "Conditions", 
       title = "Number of Texts Sent Per Week by Condition")