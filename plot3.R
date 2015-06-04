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

png(file="./data/figure/plot3.png",   width = 480, height = 480, units = "px" )

plot(rep(hpc_tb_df$datetime,3), 
     c(hpc_tb_df$Sub_metering_1,        
     hpc_tb_df$Sub_metering_2,        
     hpc_tb_df$Sub_metering_3),             
     type =  "n", xlab = "", 
     ylab =  "Energy sub metering", 
     bg = "transparent", 
     ylim = range(pretty(c(0,40))),
     yaxt = "n"
     )

axis(2, seq(0,30,10) )

lines(hpc_tb_df$datetime, hpc_tb_df$Sub_metering_1, type =  "l", xlab = "", ylab =  "Energy sub metering", col = "black", bg = "transparent")
lines(hpc_tb_df$datetime, hpc_tb_df$Sub_metering_2, type =  "l", xlab = "", ylab =  "Energy sub metering", col = "red", bg = "transparent")
lines(hpc_tb_df$datetime, hpc_tb_df$Sub_metering_3, type =  "l", xlab = "", ylab =  "Energy sub metering", col = "blue", bg = "transparent")

legend("topright", col = c("black","red","blue"), 
       legend = c("Sub_metering_1","Sub_metering_2","Sub_metering_3"), lwd = 2)

dev.off()

