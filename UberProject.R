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


april <- readRDS("uber-raw-data-apr14.rds")
august <- readRDS("uber-raw-data-aug14.rds")
july <- readRDS("uber-raw-data-jul14.rds")
june <- readRDS("uber-raw-data-jun14.rds")
may <- readRDS("uber-raw-data-may14.rds")
september <- readRDS("uber-raw-data-sep14.rds")

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

saveRDS(trips.hour.month, file = "Trips by Hours and Month.rds")

# Chart that displays Trips Every Hour
trips.hour <- months %>%
  mutate(hour = as.POSIXlt(Date.Time)$hour) %>%
  group_by(hour) %>%
  summarize(trips = n())

ggplot(trips.hour, aes(x = hour, y = trips, fill = trips)) +
  geom_bar(stat = "identity") +
  scale_fill_gradient(low = "blue", high = "red") +
  labs(title = "Trips Every Hour", x = "Hour of Day", y = "Number of Trips")

saveRDS(trips.hour, file = "Trips every Hour.rds")


# Plot data by trips taken during every day of the month
trips.day <- months %>%
  mutate(day = as.numeric(format(Date.Time, "%d"))) %>%
  group_by(day) %>%
  summarize(trips = n())

ggplot(trips.day, aes(x = day, y = trips)) +
  geom_line(color = "blue") +
  labs(title = "Trips Every Day", x = "Day of Month", y = "Number of Trips")

saveRDS(trips.day, file = "Trips every day.rds")

# Chart by Trips by Day and Month:
trips.month.day <- months %>%
  mutate(day = day(Date.Time), month = month(Date.Time, label = TRUE)) %>%
  group_by(day, month) %>%
  summarize(total_trips = n())

ggplot(trips.month.day, aes(x = factor(day), y = total_trips, fill = month)) +
  geom_bar(stat = "identity", position = position_dodge()) +
  labs(x = "Day of the month", y = "Total trips", fill = "Month")

saveRDS(trips.month.day, file = "Trips by Day and Month.rds")

# Chart Trips by Bases and Month:
month.base <- months %>%
  group_by(Base, month = month(Date.Time, label = TRUE)) %>%
  summarize(total_trips = n())

ggplot(month.base, aes(x = Base, y = total_trips, fill = month)) +
  geom_bar(stat = "identity") +
  labs(x = "Base", y = "Total trips", fill = "Month")

saveRDS(month.base, file = "Trips by Bases and Month.rds")

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

saveRDS(hours.day, file = "Heat map by Hour and day.rds")


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

saveRDS(trip.day, file = "Heat map by Month and day.rds")


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

saveRDS(trip.week, file = "Heat map by Month and Week.rds")

#Heat map Bases and Day of Week:
base.day<- months %>%
  mutate(day = weekdays(Date.Time)) %>%
  group_by(Base, day) %>%
  summarize(trips = n())

ggplot(base.day, aes(x = day, y = Base, fill = trips)) +
  geom_tile() +
  scale_fill_gradient(low = "white", high = "red") +
  labs(title = "Trips by Bases and Day of Week", x = "Day of Week", y = "Base")

saveRDS(base.day, file = "Heat map by Bases and day.rds")

#Geospatial Map
month_sub <- months[1:100,]
map <- renderLeaflet(
  leaflet(data = month_sub) %>%
    addTiles() %>%
    setView(lng = -73.9, lat = 40.8, zoom = 12) %>%
    addMarkers(lng = month_sub$Lon, lat = month_sub$Lat, 
               popup = paste0("Date.Time: ", month_sub$Date.Time, "<br>",
                              "Base: ", month_sub$Base))
  )


saveRDS(month_sub, file = "Sub.data.frame.rds")


