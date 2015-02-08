library(pryr)
library(plyr)

# Download and unzip file
fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(fileUrl,destfile="./power.zip")
unzip ("./power.zip")

# First calculate a rough estimate of how much memory 
size <- object_size(read.table("household_power_consumption.txt",na.strings="?",sep=";",
                               stringsAsFactors = FALSE, skip=66637, nrow=2880)) 

#290 kB is OK for my memmory so I store in variable power:
power<- read.table("household_power_consumption.txt",na.strings="?",sep=";",
                   stringsAsFactors = FALSE, skip=66637, nrow=2880,
                   col.names = c("Date","Time","Global_active_power",
                                 "Global_reactive_power","Voltage",
                                 "Global_intensity","Sub_metering_1",
                                 "Sub_metering_2","Sub_metering_3"))

# Convert the Date and Time variables to Date/Time classes in R 
# I add a new column with date and time
Date_time = paste(power$Date,power$Time)
power =  mutate(power,Date_time = strptime(Date_time, "%d/%m/%Y %H:%M:%S"))


#plot4

par(mfrow = c(2, 2))

#1
plot(power$Date_time, power$Global_active_power,type="l",main ="", xlab = "",
     ylab="Global Active Power (kilowatts)")

#2
with(power, plot(Date_time,Voltage, type ="l"))

#3
with(power, plot(Date_time, Sub_metering_1, main = "",type = "n",
                 ylab="Energy sub metering", xlab=""))
with(power, points(Date_time, Sub_metering_1, type="l", col = "black"))
with(power, points(Date_time, Sub_metering_2, type="l", col = "red"))
with(power, points(Date_time, Sub_metering_3, type="l", col = "blue"))
legend("topright", col = c("black","red","blue"), lty = c(1, 1, 1),
       legend = c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),
       cex=0.6)


#4
with(power, plot(Date_time,Global_reactive_power, type ="l"))

dev.copy(png, file = "plot4.png") ## Copy my plot to a PNG file
dev.off()
