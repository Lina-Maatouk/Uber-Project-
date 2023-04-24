# Uber Project

## Data Cleaning & Preperation:

The first step of our data analysis is to clean the data and prepare it accordingly. The process was fairly simple since the data was already well oganized. We only had to bind the data together into one main dataset and format the Date Time column. Here is what the R code would look like:

![dataprep](https://user-images.githubusercontent.com/118494394/234019161-97787443-39a6-4e99-a4d0-3f8a696d91ee.png)

### Pivot table to display trips by the hour:

Table:

Before the pivot table, we created a first data frame that summarizes the main data by using the function group_by to only display the trips each hour.

![hourlytrips](https://user-images.githubusercontent.com/118494394/234019266-dedf39a0-c5b2-4b50-bdc7-448673a7d2c7.png)

Pivot table:

![pivotable](https://user-images.githubusercontent.com/118494394/234021182-bb74fba3-06c5-4f93-b3c0-344980ac91a7.png)

### Chart that shows Trips by Hour and Month:

Similarly to the first table, we used group_by function to add the month column.

![tripbyhourandmonth](https://user-images.githubusercontent.com/118494394/234021278-6c33160d-7a37-48a4-bf49-d7e78605084b.png)

Result:

![trips by hour and month](https://user-images.githubusercontent.com/118494394/234021405-9345db25-99af-4db1-8519-d8f1d397385f.png)

Analysis:

As we can see on the graph, the maximum amount of trips are on the month of September between the hours 15 and 20. 

### Chart that displays Trips Every Hour:

Here, we only focused on the hours columns, as we did on the first table:

![tripsbyhour](https://user-images.githubusercontent.com/118494394/234021605-468f02ba-aaea-4f46-b839-8a0a4b001299.png)

Result:

![trips hour](https://user-images.githubusercontent.com/118494394/234021496-1930424f-1304-4dda-89e4-ca0c481740d3.png)

Analysis:

Again, the range 15 to 20 are the hours in which we have the highest rate of trips.

### Plot data by trips taken during every day of the month:

Similar to the previous graph, but instead focusing on every day of the month:

![trips day](https://user-images.githubusercontent.com/118494394/234022188-f854b1c2-a942-41a0-89d7-452980be6885.png)

Table that shows Trips Every Day:

![tripsday](https://user-images.githubusercontent.com/118494394/234021921-a46c52dc-685b-4d6e-bc7e-7abce22e31f9.png)

### Chart by Trips by Day and Month:

For this chart, we combined both the day and the month columns. As a result we got the following table: 

![month day](https://user-images.githubusercontent.com/118494394/234021971-db4ff979-f71d-447d-9476-99a0029b0ce1.png)

Result:

![monthday](https://user-images.githubusercontent.com/118494394/234022312-4b9c0bb7-8797-4f82-89fb-cdf14aff3e07.png)

### Chart Trips by Bases and Month:

Finally, for this graph we used the same group_by function to display the base and month columns as shown below:

![monthbase](https://user-images.githubusercontent.com/118494394/234022003-3d88444e-8c9d-4e7d-8ccb-5049a9989ccc.png)

Result:

![monthbase](https://user-images.githubusercontent.com/118494394/234022392-1c4f270a-e6ce-4a9d-b7a6-5bde9e43361f.png)

## Heat Maps:

### Heat map that displays by hour and day:

![heat1](https://user-images.githubusercontent.com/118494394/234022826-867b9c5a-bfef-40b3-97ed-d0c7d2c25fe0.png)

Result:

![heatmap1](https://user-images.githubusercontent.com/118494394/234023127-81091448-2905-42c2-a66c-aff3a861329c.png)

### Heat map by month and day:

![heat2](https://user-images.githubusercontent.com/118494394/234022888-6847b77b-f7bf-4c83-b3ba-217162eded30.png)

Result:

![heatmap2](https://user-images.githubusercontent.com/118494394/234023171-ab836707-e6b1-4a14-a1d1-876eee65115b.png)

### Heat map by month and week:

![heat3](https://user-images.githubusercontent.com/118494394/234022946-4452947e-c2e7-4ae1-a12c-0987673015b8.png)

Result:

![heat3](https://user-images.githubusercontent.com/118494394/234023199-6dff6d44-e210-4fc9-b747-1e771d850de5.png)

### Heat map Bases and Day of Week:

![heat4](https://user-images.githubusercontent.com/118494394/234023002-5e4a55e9-ce95-4c6d-a5b8-fc24eb98a338.png)

Result:

![heat4](https://user-images.githubusercontent.com/118494394/234023278-9588242a-125a-44ab-a526-3876ab0542d5.png)


# Leaflet Shiny Geospatial Map:

insert link

# Author

Lina Maatouk
