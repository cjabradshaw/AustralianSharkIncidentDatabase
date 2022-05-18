################################################################################################
#### Calculate the proportional activities occurring during a bite incident across categories ##
#### (provoked, unprovoked, fatal, non-fatal)                                                 ##
################################################################################################

# import data
dat <- read.csv("Activity plot data updated2.csv", header=T)
dat$Victim.activity1 <- ifelse(dat$Victim.activity == "unmotorised boating" | dat$Victim.activity == "motorised boating", "boating", dat$Victim.activity)
dat$Victim.activity2 <- ifelse(dat$Victim.activity1 == "spearfishing", "fishing", dat$Victim.activity1)
dat$Victim.activity3 <- ifelse(dat$Victim.activity2 == "surfing", "boarding", dat$Victim.activity2)
dat$Victim.activity4 <- ifelse(dat$Victim.activity3 == "scuba diving", "diving", dat$Victim.activity3)
dat$Victim.activity5 <- ifelse(dat$Victim.activity4 == "standing", "other: standing in water", dat$Victim.activity4)
dat$Victim.activityN <- ifelse(dat$Victim.activity5 == "swimming" | dat$Victim.activity5 == "snorkelling" | dat$Victim.activity5 == "other:floating" | dat$Victim.activity5 == "wading", "swimming", dat$Victim.activity5)
dat$Recovery.status2 <- ifelse(dat$Recovery.status == "Injured", "injured", dat$Recovery.status)

table(dat$Recovery.status2)
table(dat$Victim.activityN)
table(dat$Provoked.unprovoked)

provoked.dat <- subset(dat, Provoked.unprovoked == "provoked")
unprovoked.dat <- subset(dat, Provoked.unprovoked == "unprovoked")
fatal.dat <- subset(dat, Recovery.status2 == "fatal")
nonfatal.dat <- subset(dat, Recovery.status2 != "fatal")

# choose subset
dat.base <- provoked.dat
#dat.base <- unprovoked.dat
#dat.base <- fatal.dat
#dat.base <- nonfatal.dat

year.vec <- seq(1900, 2022, 1)
tot.bite <- boarding <- boating <- diving <- fishing <- standing <- swimming <- unknown <- rep(NA,length(year.vec))

for (i in 1:length(year.vec)) {
  ydat <- subset(dat.base, Incident.year == year.vec[i])
  tot.bite[i] <- ifelse(dim(ydat)[1] == 0, 0, dim(ydat)[1])
  ydat.act.tab <- table(ydat$Victim.activityN)
  
  if (dim(ydat.act.tab)[1] > 0) {
    boarding[i] <- ifelse(length(which(names(ydat.act.tab) == "boarding")) == 0, 0, as.numeric(ydat.act.tab[which(names(ydat.act.tab) == "boarding")]))
    boating[i] <- ifelse(length(which(names(ydat.act.tab) == "boating")) == 0, 0, as.numeric(ydat.act.tab[which(names(ydat.act.tab) == "boating")]))
    diving[i] <- ifelse(length(which(names(ydat.act.tab) == "diving")) == 0, 0, as.numeric(ydat.act.tab[which(names(ydat.act.tab) == "diving")]))
    fishing[i] <- ifelse(length(which(names(ydat.act.tab) == "fishing")) == 0, 0, as.numeric(ydat.act.tab[which(names(ydat.act.tab) == "fishing")]))
    standing[i] <- ifelse(length(which(names(ydat.act.tab) == "other: standing in water")) == 0, 0, as.numeric(ydat.act.tab[which(names(ydat.act.tab) == "other: standing in water")]))
    swimming[i] <- ifelse(length(which(names(ydat.act.tab) == "swimming")) == 0, 0, as.numeric(ydat.act.tab[which(names(ydat.act.tab) == "swimming")]))
    unknown[i] <- ifelse(length(which(names(ydat.act.tab) == "")) == 0, 0, as.numeric(ydat.act.tab[which(names(ydat.act.tab) == "")]))
  }
}

out.dat <- data.frame(year.vec,boarding,boating,diving,fishing,standing,swimming,unknown,tot.bite)
prop.dat <- data.frame(year.vec, boarding/tot.bite, boating/tot.bite, diving/tot.bite, fishing/tot.bite, standing/tot.bite, swimming/tot.bite, unknown/tot.bite, tot.bite)
colnames(prop.dat) <- c("year", "boarding", "boating", "diving", "fishing", "standing", "swimming", "unknown", "totbites")
head(prop.dat)
apply(out.dat[,2:8], MARGIN=1, sum, na.rm=T)/out.dat[9]
