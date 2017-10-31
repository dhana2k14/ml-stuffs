install.packages("choroplethr")
install.packages("choroplethrAdmin1")
library(choroplethr)
library(choroplethrAdmin1)
library(ggplot2)

data(admin1.map)
ggplot(admin1.map, aes(long, lat, group = group)) + geom_polygon()
data(admin1.regions)
head(admin1.regions)
admin1.map("india")

admin <- function(x)
{
  subset(admin1.map, admin == x)
}

admin("united kingdom")

ggplot(admin("india"), aes(long, lat, group = group)) + 
  geom_polygon()

data(df_japan_census)
df_japan_census$value <- df_japan_census$pop_density_km2_2010

admin1_choropleth('japan', df_japan_census, num_colors = 1, reference_map = TRUE)
