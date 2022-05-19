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

write.table(bullshark.dat,file="BULL.txt",sep="\t", row.names = F, col.names = T)
write.table(tigershark.dat,file="TIGER.txt",sep="\t", row.names = F, col.names = T)
write.table(whiteshark.dat,file="WHITE.txt",sep="\t", row.names = F, col.names = T)

## choose full dataset or main species
dat.base <- dat
#dat.base <- bullshark.dat
#dat.base <- tigershark.dat
#dat.base <- whiteshark.dat

year.vec <- seq(1900, 2022, 1)
tot.bite <- fatal <- injured <- uninjured <- unknown <- rep(NA,length(year.vec))

for (i in 1:length(year.vec)) {
  ydat <- subset(dat.base, Incident.year == year.vec[i])
  tot.bite[i] <- ifelse(dim(ydat)[1] == 0, 0, dim(ydat)[1])
  ydat.inj.tab <- table(ydat$Victim.injury)
  
  if (dim(ydat.inj.tab)[1] > 0) {
    fatal[i] <- ifelse(length(which(names(ydat.inj.tab) == "fatal")) == 0, 0, as.numeric(ydat.inj.tab[which(names(ydat.inj.tab) == "fatal")]))
    injured[i] <- ifelse(length(which(names(ydat.inj.tab) == "injured")) == 0, 0, as.numeric(ydat.inj.tab[which(names(ydat.inj.tab) == "injured")]))
    uninjured[i] <- ifelse(length(which(names(ydat.inj.tab) == "uninjured")) == 0, 0, as.numeric(ydat.inj.tab[which(names(ydat.inj.tab) == "uninjured")]))
    unknown[i] <- ifelse(length(which(names(ydat.inj.tab) == "")) == 0, 0, as.numeric(ydat.inj.tab[which(names(ydat.inj.tab) == "")]))
  }
}

out.dat <- data.frame(year.vec,fatal, injured, uninjured, unknown, tot.bite)
tot.known <- fatal + injured + uninjured
prop.dat <- data.frame(year.vec, fatal/tot.known, injured/tot.known, uninjured/tot.known, unknown/tot.bite, tot.bite)
colnames(prop.dat) <- c("year", "fatal", "injured", "uninjured", "NA", "totbites")
head(prop.dat)
apply(prop.dat[,2:4], MARGIN=1, sum, na.rm=T)
