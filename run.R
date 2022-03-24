library(shiny)
library(shinydashboard)
library(shinydashboardPlus)
library(tidyverse)
library(plotly)
library(europepmc)
source("function.R")
### Default shop list
shop_list <- c("nestle.official.store", "indofooddapurcitarasa", 
               "unileverindonesia", "wingsofficialshop", "pgofficialstore")
### Create Empty dataframe
shop_df <- data.frame(matrix(ncol = 5, nrow = 0))
colnames(shop_df) <- c("Shop.id", "Shopname", "Shop.location", "Shop.rating", "Shop.follower")
### Append shop details to dataframe
for (shop in shop_list){
  shop_df[nrow(shop_df)+1,] <- set_shop(shop)
}
#shop_df

library(shiny)

port <- Sys.getenv('PORT')

shiny::runApp(
  appDir = getwd(),
  host = '0.0.0.0',
  port = as.numeric(port)
)
