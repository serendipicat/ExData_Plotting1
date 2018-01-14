## Exploratory Data Analysis Course Project 1
## plot4.R
## This script reads in the Electrical Power Consumption dataset and generates 
## the file plot4.png in the working directory.

## Before using this script:
## 1. Download the Electric Power Consumption dataset from the following link
##    https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip
## 2. Rename to "household_power_consumption.zip" and unzip
## 3. Set the working directory to the directory that contains "household_power_consumption.txt"

library(dplyr)
library(lubridate)

## Reads in the input file, which is expected to be in the working directory

# Reads data for just the relevant dates: 2007-02-01 and 2007-02-02
# There is one reading every minute, so there are 60 * 24 readings per day.
# I calculated the number of rows to skip by subtracting the starting date of the data
# (16/12/2006 17:24:00) from the first desired date (2007-02-01 00:00:00) and added one
# to also skip over the header line.
# Only reading 2880 rows, which cover the 60 * 24 * 2 readings
ds <- read.table("household_power_consumption.txt",skip = 66637, header = FALSE, 
                 stringsAsFactors = FALSE, na.strings = "?", sep = ";", nrows = 2880)
ds <- ds %>%
    # Rename columns to match original headers
    rename("Date" = V1, 
           "Time" = V2,
           "Global_active_power" = V3,
           "Global_reactive_power" = V4,
           "Voltage" = V5,
           "Global_intensity" = V6,
           "Sub_metering_1"  = V7,
           "Sub_metering_2"  = V8,
           "Sub_metering_3"  = V9) %>%
    # Merge Date and Time columns and convert to a POSIXct time object
    mutate("Date.Time" = as.POSIXct(strptime(paste(Date, Time), "%d/%m/%Y %H:%M:%S"))) %>%
    
    # Reorder the columns, starting with the new Date.Time column discarding the original Data and Time 
    select(Date.Time, Global_active_power:Sub_metering_3, -Date, -Time)

# Filter the data to only include readings on Thursdays and Fridays
ds <- filter(ds, wday(Date.Time) > 4 & wday(Date.Time) < 7)

#Plot 4
par(mfrow = c(2,2)) # Prepare to do 4 plots

# Plot 1 (top/left)
with(ds, plot(Date.Time, Global_active_power, type = "l", xlab = "", 
     ylab = "Global Active Power (kilowatts)"))

# Plot 2 (top/right)
with(ds, plot(Date.Time, Voltage, xlab = "datetime", type = "l"))

# Plot 3 (bottom/left)
with(ds, plot(Date.Time, Sub_metering_1, type = "l", col = "black", xlab = "", 
              ylab = "Energy sub metering"))
with(ds, points(Date.Time, Sub_metering_2, type = "l", col = "red"))
with(ds, points(Date.Time, Sub_metering_3, type = "l", col = "blue"))
legend("topright", col = c("black", "red", "blue"), 
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), lty = "solid")

# Plot 4 (bottom/right)
with(ds, plot(Date.Time, Global_reactive_power, xlab = "datetime", type = "l"))

dev.copy(png, file="plot4.png")   
dev.off()

# Reset global parameter
par(mfrow = c(1, 1))


