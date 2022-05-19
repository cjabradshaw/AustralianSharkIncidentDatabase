##################################################################################################
#### create lat/lon location files for importing into GIS software (plot commands not provided) ##
##################################################################################################

# import data
dat <- read.delim2(file="locdat2.txt", header=T, sep="\t")

dat$Victim.activity1 <- ifelse(dat$Victim.activity == "unmotorised boating" | dat$Victim.activity == "motorised boating", "boating", dat$Victim.activity)
dat$Victim.activity2 <- ifelse(dat$Victim.activity1 == "spearfishing", "fishing", dat$Victim.activity1)
dat$Victim.activity3 <- ifelse(dat$Victim.activity2 == "surfing", "boarding", dat$Victim.activity2)
dat$Victim.activity4 <- ifelse(dat$Victim.activity3 == "scuba diving", "diving", dat$Victim.activity3)
dat$Victim.activity5 <- ifelse(dat$Victim.activity4 == "standing", "other: standing in water", dat$Victim.activity4)
dat$Victim.activityN <- ifelse(dat$Victim.activity5 == "swimming" | dat$Victim.activity5 == "snorkelling" | dat$Victim.activity5 == "other:floating" | dat$Victim.activity5 == "wading", "swimming", dat$Victim.activity5)
dat$Recovery.status2 <- ifelse(dat$Victim.injury == "Injured", "injured", dat$Victim.injury)

table(dat$Recovery.status2)
table(dat$Victim.activityN)
table(dat$Provoked.unprovoked)

table(dat$Shark.common.name)
dat$Shark.common.name <- ifelse(dat$Shark.common.name == "tiger shark ", "tiger shark", dat$Shark.common.name)
dat$Shark.common.name <- ifelse(dat$Shark.common.name == "white shark ", "white shark", dat$Shark.common.name)
table(dat$Shark.common.name)

bullshark.dat <- subset(dat, Shark.common.name=="bull shark")
tigershark.dat <- subset(dat, Shark.common.name=="tiger shark")
whiteshark.dat <- subset(dat, Shark.common.name=="white shark")
