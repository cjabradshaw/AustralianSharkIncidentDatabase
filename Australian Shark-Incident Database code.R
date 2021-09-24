### Australian Shark-Incident Database code ###
## Madeline Riley 2021 (data from Taronga Conservation Society Australia)
## Flinders University, College of Science and Engineering

## Remove everything
rm(list = ls())

##libraries
library(magrittr)
library(ggplot2)
library(dplyr)
library(forcats)
library(leaflet)
library(viridis)
library(scales)
library(ggmap)
library(gridExtra)
library(rgdal)
library(magrittr)
library(tibble)
library(ozmaps)
library(ggpubr)


# MAPPING -----------------------------------------------------------------
#Import data
setwd("~/.../")
ASID.top.sharks <- read.csv("top.sharks.csv", fileEncoding = "Latin1", check.names = F, header=T, na.strings=c("", " ", "NA"))
ASID.top.unprov <- subset(ASID.top.sharks, Provoked.unprovoked == "Unprovoked")
str(ASID.top.unprov)

oz_states1 <- tribble(
  ~state, ~lat, ~long,
  "NSW",  -32.451944,   146.565833,
  "NT", -19.606389, 133.595556,
  "QLD",   -22.8375,   144.1475,
  "SA",  -29.835556,   134.801389,
  "TAS", -41.83292234,   146.6166613,
  "VIC", -36.73119953,   144.0234135,
  "WA",    -26.6125,   122.372222
)

totalmap <- ggplot(ozmap_states)+
  geom_sf()+
  geom_point(data = ASID.top.unprov, mapping = aes(x = Longitude, y = Latitude), colour = "Red", size = 0.5) + 
  geom_text(data = oz_states1, aes(long, lat, label = state), size=2)+
  theme_void() 
totalmap

### white shark bites
ASID.ws <- subset(ASID.top.unprov, Shark.common.name == "white shark")
str(ASID.ws)

whitemap <- ggplot(ozmap_states)+
  geom_sf()+
  geom_point(data = ASID.ws, mapping = aes(x = Longitude, y = Latitude), colour = "Red", size = 0.5) + 
  geom_text(data = oz_states1, aes(long, lat, label = state), size=2)+
  theme_void() 
whitemap

### tiger shark bites
ASID.ts <- subset(ASID.top.unprov, Shark.common.name == "tiger shark")
str(ASID.ts)

tigermap <- ggplot(ozmap_states)+
  geom_sf()+
  geom_point(data = ASID.ts, mapping = aes(x = Longitude, y = Latitude), colour = "Red", size = 0.5) + 
  geom_text(data = oz_states1, aes(long, lat, label = state), size=2)+
  theme_void() 
tigermap

### bull shark bites
ASID.bs <- subset(ASID.top.unprov, Shark.common.name == "bull shark")
str(ASAF.bs)

bullmap <- ggplot(ozmap_states)+
  geom_sf()+
  geom_point(data = ASID.bs, mapping = aes(x = Longitude, y = Latitude), colour = "Red", size = 0.5) + 
  geom_text(data = oz_states1, aes(long, lat, label = state), size=2)+
  theme_void()
bullmap

# Arrange all maps
plot3 <- grid.arrange(totalmap, whitemap, tigermap, bullmap, ncol = 2, nrow = 2)


# PROPORTION OF FATALITIES OVER TIME -----------------------------------------------
#import data
setwd("~/.../")
ASID <- read.csv("ASID r version.csv", fileEncoding = "Latin1", check.names = F, header=T, na.strings=c("", " ", "NA"))

#subset unprovoked bites
ASID_unprovoked <- subset(ASID, Provoked.unprovoked == "unprovoked")
str(ASID_unprovoked)

# calculating proportions 
ASID_fatalities <- ASID_unprovoked %>%
  group_by(Incident.year, Victim.injury)%>%
  summarise(count= n())
ASID_fatalities

ASID_fatalities_prop <- ASID_fatalities  %>%
  group_by(Incident.year, Victim.injury) %>%
  summarise(n = sum(count)) %>%
  mutate(percentage = n / sum(n))
ASID_fatalities_prop

# plotting all bites 
p1.total <- ggplot(ASID_fatalities_prop, aes(x = Incident.year, y = percentage, fill = Victim.injury)) +
  labs(fill='Recovery status') + 
  geom_bar(width = 1, stat = "identity") +
  scale_fill_manual(values = c("lightskyblue","Black","Dark grey")) +
  scale_x_continuous(name = "Year", limits = c(1900, 2021), breaks = seq(1900, 2021, 10), expand = c(0,0))+
  scale_y_continuous(expand = c(0,0)) +
  ylab("proportion of bites") +
  theme_classic()+
  theme(axis.title.x=element_blank(),
        axis.text.x=element_blank(),
        plot.margin=unit(c(0.5,0.5,0.5,0.5), "cm"))
p1.total   

# plotting white shark bites 
ASID.ws.unprovoked <- subset(ASID_unprovoked, Shark.common.name == "white shark")
str(ASID.ws.unprovoked )

ASID_fatalities_ws <- ASID.ws.unprovoked %>%
  group_by(Incident.year, Victim.injury)%>%
  summarise(count= n())
ASID_fatalities_ws

ASID_fatalities_ws_prop <- ASID_fatalities_ws  %>%
  group_by(Incident.year, Victim.injury) %>%
  summarise(n = sum(count)) %>%
  mutate(percentage = n / sum(n))
ASID_fatalities_ws_prop

p2.total.ws <- ggplot(ASID_fatalities_ws_prop, aes(x = Incident.year, y = percentage, fill = Victim.injury)) +
  labs(fill='Recovery status') + 
  geom_bar(width = 1, stat = "identity") +
  scale_fill_manual(values = c("lightskyblue","Black","Dark grey")) +
  scale_x_continuous(name = "Year", limits = c(1900, 2021), breaks = seq(1900, 2021, 10), expand = c(0,0))+
  scale_y_continuous(expand = c(0,0)) +
  xlab("") +
  ylab("") +
  theme_classic() +
  theme(axis.title.x=element_blank(),
        axis.text.x=element_blank(),
        axis.title.y=element_blank(),
        axis.text.y=element_blank(),
        plot.margin=unit(c(0.5,0.5,0.5,0.5), "cm"))
p2.total.ws 

#plotting tiger shark bites
ASID.ts.unprovoked <- subset(ASID_unprovoked, Shark.common.name == "tiger shark")
str(ASID.ts.unprovoked )

ASID_fatalities_ts <- ASID.ts.unprovoked %>%
  group_by(Incident.year, Victim.injury)%>%
  summarise(count= n())
ASID_fatalities_ts

ASID_fatalities_ts_prop <- ASID_fatalities_ts  %>%
  group_by(Incident.year, Victim.injury) %>%
  summarise(n = sum(count)) %>%
  mutate(percentage = n / sum(n))
ASID_fatalities_ts_prop

p3.total.ts <- ggplot(ASID_fatalities_ts_prop, aes(x = Incident.year, y = percentage, fill = Victim.injury)) +
  labs(fill='Recovery status') + 
  geom_bar(width = 1, stat="identity") +
  scale_fill_manual(values = c("lightskyblue","Black","Dark grey")) +
  scale_x_continuous(name = "Year", limits = c(1900, 2021), breaks = seq(1900, 2021, 10), expand = c(0,0))+
  scale_y_continuous(expand = c(0,0)) +
  xlab("") +
  ylab("proportion of bites") +
  theme_classic() +
  theme(axis.title.x=element_blank(),
        plot.margin=unit(c(0.5,0.5,0.5,0.5), "cm"))
p3.total.ts

#plotting bull shark bites
ASID.bs.unprovoked <- subset(ASAF_unprovoked, Shark.common.name == "bull shark")
str(ASID.bs.unprovoked )

ASID_fatalities_bs <- ASID.ts.unprovoked %>%
  group_by(Incident.year, Victim.injury)%>%
  summarise(count= n())
ASID_fatalities_bs

ASID_fatalities_bs_prop <- ASID_fatalities_bs  %>%
  group_by(Incident.year, Victim.injury) %>%
  summarise(n = sum(count)) %>%
  mutate(percentage = n / sum(n))
ASID_fatalities_bs_prop

p4.total.bs <- ggplot(ASID_fatalities_bs_prop, aes(x = Incident.year, y = percentage, fill = Victim.injury)) +
  labs(fill='Recovery status') + 
  geom_bar(width = 1, stat="identity") +
  scale_fill_manual(values = c("lightskyblue","Black","Dark grey")) +
  scale_x_continuous(name = "Year", limits = c(1900, 2021), breaks = seq(1900, 2021, 10), expand = c(0,0))+
  scale_y_continuous(expand = c(0,0)) +
  xlab("") +
  ylab("proportion of bites") +
  theme_classic() +
  theme(axis.title.x=element_blank(),
        plot.margin=unit(c(0.5,0.5,0.5,0.5), "cm"))
p4.total.bs

# Arrange plots
ggarrange(p1.total, p2.total.ws, p3.total.ts, p4.total.bs, ncol=2, nrow=2, common.legend = TRUE, legend="bottom")

# INJURY LOCATION ---------------------------------------------------------
#import data
setwd("~/.../")
injuryprop <- read.csv("ASID_injury_prop.csv", fileEncoding = "Latin1", check.names = F, header=T, na.strings=c("", " ", "NA"))

#plot proportions
Injury.proportion <- ggplot(injuryprop, aes(x = injury.location, y = percentage, fill = recovery.status)) +
  labs(fill='recovery status') + 
  geom_bar(width = 0.9, stat = "identity") +
  scale_fill_manual(values = c("deepskyblue", "lightskyblue", "lightskyblue3")) +
  geom_text(aes(label = percentage), position = position_stack(vjust = 0.5), colour = "Black") +
  scale_y_discrete(expand = c(0,0)) +
  xlab("injury location") +
  ylab("proportion of bites") +
  theme_classic()
Injury.proportion


# SPECIES TIME OF DAY -----------------------------------------------------
#total bites
#import data
setwd("~/.../")
total.bites <- read.csv("total.bites.csv", fileEncoding = "Latin1", check.names = F, header=T, na.strings=c("", " ", "NA"))
str(total.bites)

#plot total bites
tod.tot1 <-ggplot(total.bites, aes(tod, total.bites)) +
  geom_rect(aes(xmin = -Inf, xmax = 600, ymin = -Inf, ymax = Inf), fill = "lightskyblue3", color = NA, alpha = 0.1) +
  geom_rect(aes(xmin = 1800, xmax = Inf, ymin = -Inf, ymax = Inf), fill = "lightskyblue3", color = NA, alpha = 0.1) +
  scale_x_continuous(breaks = c(0,300,600,900,1200,1500,1800,2100,2400))+
  scale_y_continuous(expand = c(0,0)) +
  labs(y = "total bites", x = "") +
  geom_col(fill = "black") + theme_classic() +
  theme(axis.text.x=element_blank())
tod.tot1

#white shark bites
#import data
setwd("~/.../")
tod.ws <- read.csv("tod.ws.csv", fileEncoding = "Latin1", check.names = F, header=T, na.strings=c("", " ", "NA"))
str(tod.ws)

#plot white shark bites
tod.ws1 <- ggplot(tod.ws, aes(tod, total.bites)) +
  geom_rect(aes(xmin = -Inf, xmax = 600, ymin = -Inf, ymax = Inf), fill = "lightskyblue3", color = NA, alpha = 0.1) +
  geom_rect(aes(xmin = 1800, xmax = Inf, ymin = -Inf, ymax = Inf), fill = "lightskyblue3", color = NA, alpha = 0.1) +
  scale_x_continuous(breaks = c(0,300,600,900,1200,1500,1800,2100,2400))+
  scale_y_continuous(expand = c(0,0)) +
  labs(y = "", x = "") +
  geom_col(fill = "black")+ theme_classic() +
  theme(axis.text.x=element_blank())
tod.ws1

#tiger shark bites
#import data
setwd("~/.../")
tod.ts <- read.csv("tod.ts.csv", fileEncoding = "Latin1", check.names = F, header=T, na.strings=c("", " ", "NA"))
str(tod.ts)

#plot tiger shark bites
tod.ts1 <- ggplot(tod.ts, aes(tod, total.bites)) +
  geom_rect(aes(xmin = -Inf, xmax = 600, ymin = -Inf, ymax = Inf), fill = "lightskyblue3", color = NA, alpha = 0.1) +
  geom_rect(aes(xmin = 1800, xmax = Inf, ymin = -Inf, ymax = Inf), fill = "lightskyblue3", color = NA, alpha = 0.1) +
  scale_x_continuous(breaks = c(0,300,600,900,1200,1500,1800,2100,2400))+
  scale_y_continuous(expand = c(0,0)) +
  labs(y = "total bites", x = "time of day") +
  geom_col(fill = "black")+ theme_classic() 
tod.ts1

#bull shark bites
#import data
setwd("~/.../")
tod.bs <- read.csv("tod.bs.csv", fileEncoding = "Latin1", check.names = F, header=T, na.strings=c("", " ", "NA"))
str(tod.bs)

#plot bull shark bites
tod.bs1 <- ggplot(tod.bs, aes(tod, total.bites)) +
  geom_rect(aes(xmin = -Inf, xmax = 600, ymin = -Inf, ymax = Inf), fill = "lightskyblue3", color = NA, alpha = 0.1) +
  geom_rect(aes(xmin = 1800, xmax = Inf, ymin = -Inf, ymax = Inf), fill = "lightskyblue3", color = NA, alpha = 0.1) +
  scale_x_continuous(breaks = c(0,300,600,900,1200,1500,1800,2100,2400))+
  scale_y_continuous(expand = c(0,0)) +
  labs(y = "", x = "time of day") +
  geom_col(fill = "black")+ theme_classic() 
tod.bs1

## Arrange plots
panel.tod <- grid.arrange(grobs = list(tod.tot1, tod.ws1, tod.ts1, tod.bs1), ncol = 2, common.legend = FALSE, legend="bottom")
panel.tod

# SPECIES FATALITIES ------------------------------------------------------
#import data
setwd("~/.../")
top.3 <- read.csv("top.3.csv", fileEncoding = "Latin1", check.names = F, header=T, na.strings=c("", " ", "NA"))
str(top.3)

#calculate proportions and arrange data
ASID_recovery <- top.3 %>%
  group_by(Shark.common.name, Recovery.status)%>%
  summarise(count= n())
ASID_recovery

ASID_recovery_prop <- ASID_recovery  %>%
  group_by(Shark.common.name, Recovery.status) %>%
  summarise(n = sum(count)) %>%
  mutate(percentage = n / sum(n))

is.num <- sapply(ASID_recovery_prop, is.numeric)
ASID_recovery_prop[is.num] <- lapply(ASID_recovery_prop[is.num], round, 2)

ASID_recovery_prop$Shark.common.name <- factor(ASID_recovery_prop$Shark.common.name,levels = c("tiger shark", "bull shark","white shark", "wobbegong", "other"))
str(ASID_recovery_prop)

#plot proportions
Recovery.proportion <- ggplot(ASID_recovery_prop, aes(x = Shark.common.name, y = percentage, fill = Recovery.status)) +
  labs(fill='recovery status') + 
  geom_bar(width = 0.85, stat = "identity") +
  geom_text(aes(label = percentage), position = position_stack(vjust = 0.5), colour = "Black") +
  scale_fill_manual(values = c("deepskyblue", "lightskyblue")) +
  ylab("proportion of unprovoked bites") +
  theme_classic() 
Recovery.proportion + theme(axis.title.x = element_blank())+
  scale_y_discrete(expand = c(0,0)) 

