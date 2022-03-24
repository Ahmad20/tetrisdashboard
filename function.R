library(shiny)
library(shinydashboard)
library(shinydashboardPlus)
library(tidyverse)
library(plotly)
library(httr)
library(jsonlite)

set_shop <- function(x){
  shop_api <- GET(
    sprintf("https://shopee.co.id/api/v4/shop/get_shop_detail?sort_sold_out=0&username=%s",x)
  )
  data = fromJSON(rawToChar(shop_api$content))
  return (c(data$data$shopid, data$data$name, 
            data$data$shop_location, data$data$rating_star, 
            data$data$follower_count))
}

get_product <- function(x){
  res <- GET(
    sprintf(
      "https://shopee.co.id/api/v4/search/search_items?by=pop&entry_point=ShopBySearch&limit=30&match_id=%s&newest=0&order=desc&page_type=shop&scenario=PAGE_OTHERS&version=2"
      ,x)
  )
  data = fromJSON(rawToChar(res$content))
  names(data)
  item_id <-data$items$item_basic$itemid
  name <-data$items$item_basic$name
  sold <-data$items$item_basic$historical_sold
  price <-data$items$item_basic$price
  rating <-data$items$item_basic$item_rating$rating_star
  normalize_prize <- function(x){
    x/100000
  }
  price <-sapply(price, FUN=normalize_prize)
  return (data.frame(item_id, name, sold, price, rating))
}
get_shopid <- function(df, x) {
  return (df[df$Shopname == x, ]$Shop.id)
}