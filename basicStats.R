
# load the met data for gridmet and prism - monthly freq
myData<- read.csv('processed_data/210923_monthly_gridmet_prism_wy20.txt')

# load the isotope data - daily freq
isoData <- read.csv("raw_data/210923_rawdat_table.csv")

# Aggregate the isotope values into monthly values and import them to 
## the met data table
isoData = isoData %>% separate(Date, sep="/", into = c("month", "day", "year"))
setDT(isoData)
isoDataMonthly <- (isoData[
  , lapply(.SD,mean), by=c("month","location"),
  .SDcols=names(isoData)[c(14,16,20)]]) 

# sum precip amnt for each month
amntMonthly <- (isoData[
  , lapply(.SD,sum), by=c("month","location"),
  .SDcols=names(isoData)[c(12,20)]])

# join the amnt column to the isotope data
isoDataMonthly <- isoDataMonthly %>% merge(., amntMonthly)

# join gridmet/prism data with isotope and amnt data
myData <- merge(myData,isoDataMonthly,by=c("month","location"))

# plot D and weighted D as a function of elevation, avg temp(don't have this)

plot(myData[,c(3,5,12,13)])
pairs(myData[,c(3,5,12,13)])
# add in lat and or long as var 

