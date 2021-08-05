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

tot_pm_type<-NEI %>%
        filter(fips == "24510") %>%
        group_by(type,year) %>%
        summarise(sum(Emissions, na.rm = TRUE)) 

colnames(tot_pm_type)[3]<-"pm"

png(file = "Plot3.png", width = 960,height = 480,units = "px")

g<-ggplot(tot_pm_type,aes(factor(year),pm,fill = type))
g+geom_bar(stat = "identity")+facet_grid(.~type) +
        ggtitle("Yearly PM2.5 Emissions by type") +
        theme(plot.title = element_text(hjust = 0.5)) +
        xlab("Year") + 
        ylab("Total PM2.5") +
        geom_col() +
        geom_text(aes(label = round(pm,digits = 1)), vjust = 1.0, colour = "white",size = 2)
        

dev.off()

