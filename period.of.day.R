################################################################################################
#### Calculate the period of day (dawn, day, dusk, night) in which shark-bite incidents occur ##
################################################################################################

# required libraries
library(suncalc)
library(lutz)

# import data
dat2 <- read.delim2(file="timedb2.txt", header=T, sep="\t")
dat.nona <- dat2[is.na(as.numeric(dat2$Time.of.incident))==F,] # remove NAs
dat.bull <- subset(dat.nona, Shark.common.name=="bull shark")
dat.tiger <- subset(dat.nona, Shark.common.name=="tiger shark")
dat.white <- subset(dat.nona, Shark.common.name=="white shark")

datwk <- dat.nona # choose all data or species subset
datwk <- dat.bull
datwk <- dat.tiger
datwk <- dat.white

table(datwk$Shark.common.name) # check and fix common-name anomalies
datwk$Shark.common.name <- ifelse(datwk$Shark.common.name == "tiger shark ", "tiger shark", datwk$Shark.common.name)
datwk$Shark.common.name <- ifelse(datwk$Shark.common.name == "white shark ", "white shark", datwk$Shark.common.name)
table(datwk$Shark.common.name)

# calculate timezone for locations
datwk$timezone <- tz_lookup_coords(as.numeric(datwk$Latitude), as.numeric(datwk$Longitude), method = "accurate")
head(datwk)

time.num <- as.numeric(datwk$Time.of.incident)

datwk$time24 <- sprintf("%04d", time.num)
hr24 <- substr(datwk$time24, 1, 2)
mn60 <- substr(datwk$time24, 3, 4)

datwk$date <- paste(sprintf("%02d", datwk$Incident.day), "-", sprintf("%02d", datwk$Incident.month), "-", datwk$Incident.year, sep="")
datwk$incident.time <- strptime(paste(datwk$date, " ", hr24,":", mn60, sep=""), format="%d-%m-%Y %H:%M")

# cycle through records to calculate period of day when incident occurs (dawn, day, dusk, night)
day.period <- rep(NA, dim(datwk)[1])
for (i in 1:dim(datwk)[1]) {
  sunlight.times <- getSunlightTimes(date = as.Date(datwk$date[i]), lat = as.numeric(datwk$Latitude[i]), lon = as.numeric(datwk$Longitude[i]), tz=datwk$timezone[i])
  dawn <-c(strftime(sunlight.times$dawn, format="%H:%M"), strftime(sunlight.times$sunrise, format="%H:%M"))
  day <- c(strftime(sunlight.times$sunrise, format="%H:%M"), strftime(sunlight.times$sunset, format="%H:%M"))
  dusk <- c(strftime(sunlight.times$sunset, format="%H:%M"), strftime(sunlight.times$night, format="%H:%M"))
  night <- c(strftime(sunlight.times$night, format="%H:%M"), strftime(sunlight.times$dawn, format="%H:%M"))
  
  dawn.num <- c(strptime(paste(datwk$date[i], " ", dawn[1], sep=""), format="%d-%m-%Y %H:%M"), strptime(paste(datwk$date[i], " ", dawn[2], sep=""), format="%d-%m-%Y %H:%M"))
  day.num <- c(strptime(paste(datwk$date[i], " ", day[1], sep=""), format="%d-%m-%Y %H:%M"), strptime(paste(datwk$date[i], " ", day[2], sep=""), format="%d-%m-%Y %H:%M"))
  dusk.num <- c(strptime(paste(datwk$date[i], " ", dusk[1], sep=""), format="%d-%m-%Y %H:%M"), strptime(paste(datwk$date[i], " ", dusk[2], sep=""), format="%d-%m-%Y %H:%M"))
  night.num <- c(strptime(paste(datwk$date[i], " ", night[1], sep=""), format="%d-%m-%Y %H:%M"), strptime(paste(datwk$date[i], " ", night[2], sep=""), format="%d-%m-%Y %H:%M"))
  
  day.period.dawn <- ifelse(datwk$incident.time[i] >= dawn.num[1] & datwk$incident.time[i] < dawn.num[2], "dawn", NA)
  day.period.day <- ifelse(datwk$incident.time[i] >= day.num[1] & datwk$incident.time[i] < day.num[2], "day", NA)
  day.period.dusk <- ifelse(datwk$incident.time[i] >= dusk.num[1] & datwk$incident.time[i] < dusk.num[2], "dusk", NA)
  day.period.night <- ifelse(is.na(day.period.dawn)==T & is.na(day.period.day)==T & is.na(day.period.dusk)==T, "night", NA)
  
  day.period[i] <- as.character(na.omit(c(day.period.dawn, day.period.day, day.period.dusk, day.period.night)))
}
datwk$day.period <- day.period
head(datwk)
table(datwk$day.period) # frequency of incidents in each day period
sum(table(datwk$day.period)) # total number of records
table(datwk$day.period)/sum(as.numeric(table(datwk$day.period))) # proportions in each day period
sum(table(datwk$day.period)/sum(as.numeric(table(datwk$day.period))))

