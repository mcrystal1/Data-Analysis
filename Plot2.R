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

tot_pm_balt<-NEI %>%
        filter(fips == "24510") %>%
        group_by(year) %>%
        summarise(sum(Emissions, na.rm = TRUE)) 

png(file = "Plot2.png", width = 480,height = 480,units = "px")

barplot(tot_pm_balt$`sum(Emissions, na.rm = TRUE)`,names.arg = tot_pm_balt$year,xlab = "Year", ylab = "PM2.5",
     main = "Total PM2.5 per year - Baltimore City",pch = 3,col = "green",ylim = c(0,3500))

dev.off()
