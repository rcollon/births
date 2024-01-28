

#Data Source: https://www.data.qld.gov.au/dataset/births-by-month

library (lubridate)
library (tidyverse)

setwd("C:\\Files\\Births")

#Get the list of files
files <- list.files(pattern = "*.csv")

#Read in each of the files as a list of dataframes
fileDF <- lapply(files, read.csv)

#Get the year from the filename
years <- str_sub(files, start = 1, end = 4)

#Add year to each of the dataframes
dfs <- fileDF %>% map2(years,~mutate(.x,year=.y))

#Conmbine dataframes
birthYears <- bind_rows(dfs)

#Add year and month variable using lubridate
birthYearMon <- mutate(birthYears, yearMonth = make_date(year=year, month=Month, day=1))

glimpse (birthYearMon)

# Summary stats
birthYearMon %>% summarise(average=mean(Transactions), total=sum(Transactions), numberOfMonths=n())
birthYearMon %>% group_by (year) %>% summarise(average=mean(Transactions), total=sum(Transactions), numberOfMonths=n())

#Line Plots
ggplot(birthYearMon, aes(x=yearMonth, y=Transactions)) + geom_line() + geom_point () +
labs (x = "Year and Month", y="Number of Births", title="Total Births by Month and Year", caption="Data Source - www.data.qld.gov.au/dataset/births-by-month") 

birthYearMon %>% group_by (year) %>% summarise(average=mean(Transactions), total=sum(Transactions), numberOfMonths=n()) %>% 
ggplot(aes(x=year, y=total, group=1)) + geom_line() + geom_point () + 
labs (x = "Year", y="Number of Births", title="Total Births by Year", caption="Data Source - www.data.qld.gov.au/dataset/births-by-month")


#Write dataframe to file for later use 
write.csv(birthYearMon,'birthsYear.csv')

