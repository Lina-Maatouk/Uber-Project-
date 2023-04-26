library(tidytext)
library(tidyr)
library(dplyr)
library(readr)
library(ggplot2)
library(stringr)
library(lubridate)
library(shiny)
library(leaflet)
library(viridis)

#read the RDS files of the pivot tables created in the UberProject.R
trips.hour.month <- readRDS("Trips by Hours and Month.rds")
trips.day<- readRDS("Trips every day.rds") 
trips.month.day<- readRDS("Trips by Day and Month.rds") 
month.base<- readRDS("Trips by Bases and Month.rds") 

heatmap1<- readRDS("Heat map by Hour and day.rds") 
heatmap2<- readRDS("Heat map by Month and day.rds") 
heatmap3<- readRDS("Heat map by Month and Week.rds") 
heatmap4<- readRDS("Heat map by Bases and day.rds") 


april <- readRDS("uber-raw-data-apr14.rds")
august <- readRDS("uber-raw-data-aug14.rds")
july <- readRDS("uber-raw-data-jul14.rds")
june <- readRDS("uber-raw-data-jun14.rds")
may <- readRDS("uber-raw-data-may14.rds")
september <- readRDS("uber-raw-data-sep14.rds")

months <- rbind(april, august, july, june, may, september)
months$Date.Time <- as.POSIXct(months$Date.Time, format = "%m/%d/%Y %H:%M:%S")
month_sub <- months[1:100,]

ui <- fluidPage(
  titlePanel("Uber Rides Analysis"),
  tabsetPanel(
    tabPanel("Trips by Hour and Month",
             plotOutput("trips_hour_month_plot"),
             p("Analysis: This line chart represents the total trips on the various months highlighing the hours where the trip was booked. 
               As we can see, there is a high rate of trips on the month of September especially between the 15 and 20 hours.")),
    tabPanel("Trips Every Day",
             plotOutput("trips_day_plot"),
             p("Analysis: This line plot shows how the trips change in relation to days of the month. We can see that it reaches its maximum on the 30th and drops signigicantly.")),
    tabPanel("Trips by Day and Month",
             plotOutput("trips_day_month_plot"),
             p("Analysis: This chart shows the relationship between Day, month and trips. As we can see there is a high rate on the month of September throughout the days of the month, especially on the 13th.")),
    tabPanel("Trips by Bases and Month",
             plotOutput("trips.month.base_plot"),
             p("Analysis: This bar chart shows that there is high rate of trips in the base B02617 especially on the month of September and August.")),
    tabPanel("Heat map by Hour and day",
             plotOutput("heat_map_plot"),
             p("Analysis: This heat map shows us that there are more trips booked at the end of the months between the hours 15 and 20.")),
    tabPanel("Heat Map by Month and Day",
             plotOutput("heat_map_plot2"),
             p("Analysis: There is a higher rate of trips in the month of September especially between the 5th and 7th 
               of the month and 18th to 28th.")),
    tabPanel("Heat map by Month and Week",
             plotOutput("heat_map_plot3"),
             p("Analysis: The highest rate of trips is duringweeks 35 and 38 of the year.")),
    tabPanel("Heat map by Bases and day",
             plotOutput("heat_map_plot4"),
             p("Analysis: The highest rate of trips is mainly in the bases B02617
               and B02598 ON Friday and Thursday.")),
    tabPanel("Geospatial Map",
             leafletOutput("map"),
             p("Analysis: This map shows the pickup locations of Uber rides.")),
  
  )

)


server <- function(input, output) {
  
  # Trips by Hour and Month
  output$trips_hour_month_plot <- renderPlot({
    ggplot(trips.hour.month, aes(x = hour, y = total_trips, color = month)) +
      geom_line() +
      labs(x = "Hour of the day", y = "Total trips", color = "Month")
  })
  

  # Trips Every Day
  output$trips_day_plot <- renderPlot({
    ggplot(trips.day, aes(x = day, y = trips)) +
      geom_line(color = "blue") +
      labs(title = "Trips Every Day", x = "Day of Month", y = "Number of Trips")
  })
 
 
  # Trips by Day and Month
  output$trips_day_month_plot <- renderPlot({
    ggplot(trips.month.day, aes(x = factor(day), y = total_trips, fill = month)) +
      geom_bar(stat = "identity", position = position_dodge()) +
      labs(x = "Day of the month", y = "Total trips", fill = "Month")
  })

  # Trips by Bases and Month:
  output$trips.month.base_plot <- renderPlot({
    ggplot(month.base, aes(x = Base, y = total_trips, fill = month)) +
      geom_bar(stat = "identity") +
      labs(x = "Base", y = "Total trips", fill = "Month")
  })

 
  #Heat map by Hour and day:
  output$heat_map_plot <- renderPlot({
    ggplot(heatmap1, aes(x = hour, y = day, fill = trips)) +
      geom_tile() +
      scale_fill_gradient(low = "white", high = "red") +
      labs(title = "Trips by Hour and Day", x = "Hour of Day", y = "Day of Month")
  
  })
  
  #Heat map by Month and day
  output$heat_map_plot2 <- renderPlot({
    ggplot(heatmap2, aes(x = day_of_month, y = month, fill = trips)) +
      geom_tile() +
      scale_fill_gradient(low = "white", high = "red") +
      labs(title = "Trips by Month and Day", x = "Day of Month", y = "Month")
  })
  
  #Heat map by Month and Week
  output$heat_map_plot3 <- renderPlot({
    ggplot(heatmap3, aes(x = week_number, y = year, fill = trips)) +
      geom_tile() +
      scale_fill_gradient(low = "white", high = "red") +
      labs(title = "Trips by Month and Week", x = "Week Number", y = "Year")
  })
 
  #Heat map by Bases and day
  output$heat_map_plot4 <- renderPlot({
    ggplot(heatmap4, aes(x = day, y = Base, fill = trips)) +
      geom_tile() +
      scale_fill_gradient(low = "white", high = "red") +
      labs(title = "Trips by Bases and Day of Week", x = "Day of Week", y = "Base")
    
  })
  
   
  #Geo spatial map: 
  output$map <- renderLeaflet({
    leaflet(data = month_sub) %>%
      addTiles() %>%
      setView(lng = -73.9, lat = 40.8, zoom = 12) %>%
      addMarkers(lng = month_sub$Lon, lat = month_sub$Lat, 
                 popup = paste0("Date.Time: ", month_sub$Date.Time, "<br>",
                                "Base: ", month_sub$Base))
  })
  
  
}


shinyApp(ui = ui, server = server) 