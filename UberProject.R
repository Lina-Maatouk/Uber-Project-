library(tidytext)
library(shiny)
library(tidyr)
library(dplyr)
library(readr)
library(ggplot2)
library(stringr)
library(lubridate)
library(shiny)
library(leaflet)
library(viridis)


rm(list=ls())
setwd("C:/Users/linamaatouk21/Documents/UberProject")

#read as an csv file >> save as RDS >> read as RDS
april <- read.csv("uber-raw-data-apr14.csv")
august <- read.csv("uber-raw-data-aug14.csv")
july <- read.csv("uber-raw-data-jul14.csv")
june <- read.csv("uber-raw-data-jun14.csv")
may <- read.csv("uber-raw-data-may14.csv")
september <- read.csv("uber-raw-data-sep14.csv")


saveRDS(april, file = "uber-raw-data-apr14.csv")
saveRDS(august, file = "uber-raw-data-aug14.csv")
saveRDS(july, file = "uber-raw-data-jul14.csv")
saveRDS(june, file = "uber-raw-data-jun14.csv")
saveRDS(may, file = "uber-raw-data-may14.csv")
saveRDS(september, file = "uber-raw-data-sep14.csv")


april <- readRDS("uber-raw-data-apr14.csv")
august <- readRDS("uber-raw-data-aug14.csv")
july <- readRDS("uber-raw-data-jul14.csv")
june <- readRDS("uber-raw-data-jun14.csv")
may <- readRDS("uber-raw-data-may14.csv")
september <- readRDS("uber-raw-data-sep14.csv")

months <- rbind(april, august, july, june, may, september)
months$Date.Time <- as.POSIXct(months$Date.Time, format = "%m/%d/%Y %H:%M:%S")

# Pivot table to display trips by the hour
hourlyTrips <- months %>%
  mutate(hour = lubridate::hour(Date.Time)) %>%
  group_by(hour) %>%
  summarize(total_trips = n()) %>%
  arrange(hour)

# Create a pivot table
hourlyTrips_pivot <- hourlyTrips %>%
  pivot_wider(names_from = hour, values_from = total_trips)

# Chart that shows Trips by Hour and Month
trips.hour.month <- months %>%
  mutate(hour = hour(Date.Time), month = month(Date.Time, label = TRUE)) %>%
  group_by(hour, month) %>%
  summarize(total_trips = n())

ggplot(trips.hour.month, aes(x = hour, y = total_trips, color = month)) +
  geom_line() +
  labs(x = "Hour of the day", y = "Total trips", color = "Month")

# Chart that displays Trips Every Hour
trips.hour <- months %>%
  mutate(hour = as.POSIXlt(Date.Time)$hour) %>%
  group_by(hour) %>%
  summarize(trips = n())

ggplot(trips.hour, aes(x = hour, y = trips, fill = trips)) +
  geom_bar(stat = "identity") +
  scale_fill_gradient(low = "blue", high = "red") +
  labs(title = "Trips Every Hour", x = "Hour of Day", y = "Number of Trips")

# Plot data by trips taken during every day of the month
trips.day <- months %>%
  mutate(day = as.numeric(format(Date.Time, "%d"))) %>%
  group_by(day) %>%
  summarize(trips = n())

ggplot(trips.day, aes(x = day, y = trips)) +
  geom_line(color = "blue") +
  labs(title = "Trips Every Day", x = "Day of Month", y = "Number of Trips")


# Chart by Trips by Day and Month:
trips.month.day <- months %>%
  mutate(day = day(Date.Time), month = month(Date.Time, label = TRUE)) %>%
  group_by(day, month) %>%
  summarize(total_trips = n())

ggplot(trips.month.day, aes(x = factor(day), y = total_trips, fill = month)) +
  geom_bar(stat = "identity", position = position_dodge()) +
  labs(x = "Day of the month", y = "Total trips", fill = "Month")


# Chart Trips by Bases and Month:
month.base <- months %>%
  group_by(Base, month = month(Date.Time, label = TRUE)) %>%
  summarize(total_trips = n())

ggplot(month.base, aes(x = Base, y = total_trips, fill = month)) +
  geom_bar(stat = "identity") +
  labs(x = "Base", y = "Total trips", fill = "Month")



#Heat maps:
#Heat map that displays by hour and day:
hours.day <- months %>%
  mutate(day = as.Date(Date.Time), hour = as.integer(format(Date.Time, "%H"))) %>%
  group_by(day, hour) %>%
  summarize(trips = n())

ggplot(hours.day, aes(x = hour, y = day, fill = trips)) +
  geom_tile() +
  scale_fill_gradient(low = "white", high = "red") +
  labs(title = "Trips by Hour and Day", x = "Hour of Day", y = "Day of Month")

#Heat map by month and day:
trip.day <- months %>%
  mutate(day = as.Date(Date.Time)) %>%
  group_by(day) %>%
  summarize(trips = n())

trip.day$month <- format(trip.day$day, "%m")
trip.day$day_of_month <- format(trip.day$day, "%d")

ggplot(trip.day, aes(x = day_of_month, y = month, fill = trips)) +
  geom_tile() +
  scale_fill_gradient(low = "white", high = "red") +
  labs(title = "Trips by Month and Day", x = "Day of Month", y = "Month")

#Heat map by month and week:
trip.week <- months %>%
  mutate(week = format(Date.Time, "%Y-%U")) %>%
  group_by(week) %>%
  summarize(trips = n())

trip.week$year <- substr(trip.week$week, 1, 4)
trip.week$week_number <- substr(trip.week$week, 6, 7)

ggplot(trip.week, aes(x = week_number, y = year, fill = trips)) +
  geom_tile() +
  scale_fill_gradient(low = "white", high = "red") +
  labs(title = "Trips by Month and Week", x = "Week Number", y = "Year")

#Heat map Bases and Day of Week:
base.day<- months %>%
  mutate(day = weekdays(Date.Time)) %>%
  group_by(Base, day) %>%
  summarize(trips = n())

ggplot(base.day, aes(x = day, y = Base, fill = trips)) +
  geom_tile() +
  scale_fill_gradient(low = "white", high = "red") +
  labs(title = "Trips by Bases and Day of Week", x = "Day of Week", y = "Base")
