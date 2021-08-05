library(dplyr)
library(tidyr)
library(ggplot2)

directory <- "./Graph"
file_name <- "exdata_data_NEI_data.zip"
dir <- paste(directory,"/",file_name,sep = '')

unzip(zipfile = dir)

NEI<-readRDS("summarySCC_PM25.rds")
NEI <- as.tbl(NEI)
head(NEI)
NEI$Emissions<-as.numeric(NEI$Emissions)

SCC <- readRDS("Source_Classification_Code.rds")
SCC <- as.tbl(SCC)
head(SCC)

pm_tot_balt <- NEI %>%
        filter(fips == "24510" & type == "ON-ROAD") %>%
        group_by(year) %>%
        summarise(sum(Emissions))

pm_tot_la <- NEI %>%
        filter(fips == "06037" & type == "ON-ROAD") %>%
        group_by(year) %>%
        summarise(sum(Emissions))

colnames(pm_tot_balt)[2]<-"pm"
colnames(pm_tot_la)[2]<-"pm"
pm_tot_balt$city<-"Baltimore"
pm_tot_la$city<-"LA"

pm_tot<-rbind(pm_tot_balt,pm_tot_la)

png(file = "Plot6.png", width = 960,height = 480,units = "px")

g<-ggplot(pm_tot,aes(factor(year),pm,fill = city))
g+geom_bar(stat = "identity",width = 0.5) +
        ggtitle("Yearly PM2.5 Emissions Vehicles in Baltimore vs. LA") +
        theme(plot.title = element_text(hjust = 0.5)) +
        facet_grid(city~.,scales = "free") +
        xlab("Year") + 
        ylab("Total PM2.5") +
        geom_text(aes(label = round(pm,digits = 1)), vjust = 1.0, colour = "white",size = 2)
        

dev.off()

