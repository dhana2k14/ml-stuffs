
library(plotly)

Sys.setenv("plotly_username"="dhana")
Sys.setenv("plotly_api_key"="h5qictce9t")

set.seed(100)
d <- diamonds[sample(nrow(diamonds), 1000), ]
plot_ly(d, x = carat, y = price, text = paste("Clarity: ", clarity),
        mode = "markers", color = carat, size = carat)

# plotly_POST publishes the figure to your plotly account on the web

plotly_POST(d, filename = "r-docs/diamond-test", world_readable=TRUE)
