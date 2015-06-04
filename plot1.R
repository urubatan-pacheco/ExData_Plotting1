library(sqldf)
library(gsubfn)
library(dplyr)
library(lubridate)

# Loads rows with Date between '2007-02-01' and '2007-02-02'
query <- "select * from file where substr(Date, -4) || '-' || substr('0' || replace(substr(Date, instr(Date, '/') + 1, 2), '/', ''), -2) || '-' || substr('0' || replace(substr(Date, 1, 2), '/', ''), -2) between '2007-02-01' and '2007-02-02'"

data_file <- "/media/My Passport/work/materia/ds_eda/project/p1/household_power_consumption.txt"
hpc_df <- read.csv.sql(data_file,
                   sql= query,
                   stringsAsFactors=FALSE,
                   sep = ";", header = TRUE)

hpc_tb_df <- ( hpc_df 
%>% mutate(datetime = dmy_hms(paste(hpc_df$Date, hpc_df$Time))) 
%>% select(-Date,-Time))

op_restore <- par(no.readonly = TRUE) # the whole list of settable par's.

png(file="./data/figure/plot1.png",   width = 480, height = 480, units = "px" )
hist(hpc_tb_df$Global_active_power, main = "Global Active Power", xlab = "Global Active Power (kilowatts)", col= "red")
dev.off()


