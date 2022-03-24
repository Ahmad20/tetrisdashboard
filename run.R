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

shinyUI(
  dashboardPage(
    
    skin = "midnight",
    #title = "FMCG Indonesia | Tetris 2022",
    title = "FMCG Indonesia | Tetris 2022",
    dashboardHeader(
      title = tagList(
        tags$span(
          class = "logo-mini", "AJT",
        ),
        tags$span(
          class = "logo-lg", "Tetris 2022 | DQLab",
        )
      )
    ),
    dashboardSidebar(
      sidebarMenu(
        menuItem(
          text = "Dashboard", 
          tabName = "page1",
          badgeLabel = "New!", 
          badgeColor = "green",
          icon = icon("bar-chart")
        )
      )
    ),
    dashboardBody(
      tabItems(
        tabItem(
          tabName = "page1",
          
          fluidRow(
            box(
              title = "Overview Dashboard", 
              closable = FALSE, 
              enable_label = TRUE,
              label_status = "danger",
              status = "primary", 
              solidHeader = FALSE, 
              collapsible = TRUE,
              width = 12,
              
              infoBoxOutput(
                outputId = "nshop", 
                width = 4
              ),
              
              infoBoxOutput(
                outputId = "popularshop",
                width = 4
              ),
              
              infoBoxOutput(
                outputId = "ratingshop",
                width = 4
              )
            )
          ),
          
          fluidRow(
            
            box(
              title = "Select Shop Name", 
              closable = FALSE, 
              enable_label = TRUE,
              label_status = "danger",
              status = "primary", 
              solidHeader = FALSE, 
              collapsible = TRUE,
              width = 3,
              height = "600px",
              
              selectInput(
                inputId = "shopname", 
                label = "Select Shop Name", 
                choices = c(shop_df$Shopname),
                selected = "Wings Official Shop"
              ),
              selectInput(
                inputId = "typegraph", 
                label = "Select Type of Graph", 
                choices = c("Penjualan terbanyak",
                            "Korelasi harga - rating", 
                            "Korelasi harga - terjual", 
                            "Korelasi rating - terjual"),
                selected = "Wings Official Shop"
              ),
              plotlyOutput(
                outputId = "pie"
              )
            ),
            
            box(
              title = "Graph", 
              closable = FALSE, 
              enable_label = TRUE,
              label_status = "danger",
              status = "primary", 
              solidHeader = FALSE, 
              collapsible = TRUE,
              width = 9,
              height = "600px",
              
              plotlyOutput(
                outputId = "graph"
              )
            )
          ) 
        )
      )
    )
  )
)

server <- shinyServer(function(input, output, session) {
  output$nshop <- renderInfoBox({
    
    infoBox(title = "Jumlah Toko",
            value = tags$p(style = "font-size: 35px;", nrow(shop_df)), 
            #subtitle = FALSE,
            color = "red",
            icon = icon("store"),
            fill = TRUE)
    
  })
  
  output$popularshop <- renderInfoBox({
    
    infoBox(title = "Popular Shop",
            value = shop_df[shop_df$Shop.follower == max(shop_df$Shop.follower), ]$Shopname, 
            subtitle = shop_df[shop_df$Shop.follower == max(shop_df$Shop.follower), ]$Shop.location,
            color = "green",
            icon = icon("user"),
            fill = TRUE)
    
  })
  
  output$ratingshop <- renderInfoBox({
    
    infoBox(title = "Highest Rating", 
            value = shop_df[shop_df$Shop.rating == max(shop_df$Shop.rating), ]$Shopname,
            subtitle = shop_df[shop_df$Shop.rating == max(shop_df$Shop.rating), ]$Shop.location,
            color = "blue",
            icon = icon("star"),
            fill = TRUE)
    
  })
  
  top_country <- reactive({input$shopname})
  other <- reactive({input$typegraph})
  
  output$graph <- renderPlotly({
    if (input$typegraph=="Penjualan terbanyak"){
      plot_ly(
        data =get_product(get_shopid(shop_df, input$shopname)) %>%
          select(name, sold) %>% head(5),
        y= ~name,
        x= ~sold,
        name = "A",
        type = "bar",
        orientation = "h"
      ) %>% 
        layout(xaxis = list(title = ""), yaxis = list(title =""))
    }else{
      data = get_product(get_shopid(shop_df, input$shopname))%>%
        select(name, sold, price, rating)
      if (input$typegraph=="Korelasi harga - rating"){
        x1 = data$price 
        y1 = data$rating
        size1 = data$sold
      }else if(input$typegraph=="Korelasi harga - terjual"){
        x1 = data$price 
        y1 = data$sold
        size1 = data$rating
      }else{#input$typegraph=="Korelasi terjual - rating"
        x1 = data$sold
        y1 = data$rating
        size1 = data$price
      }
      plot_ly(
        data = data,
        x= x1,
        y= y1,
        size = size1,
        color = size1,
        trendline="lm"
        
      ) %>%
        layout(xaxis = list(title = ""), yaxis = list(title =""), showlegend =T)
    }
  })
  
  
  data_for_plot <-
    shop_df %>%
    count(Shop.location)
  output$pie <- renderPlotly({
    plot_ly(data_for_plot, labels = ~Shop.location, values = ~n, type = 'pie', hole = 0.6,
            textposition = 'inside',textinfo = 'percent') %>%
      layout(title = list(text = "Sebaran Lokasi Toko", xanchor = "center", font = list(color ="white", family="Arial")),
             showlegend = F,
             margin = list(l = 20, r = 20, t = 30)) %>%
      layout(paper_bgcolor = 'rgba(0,0,0,0)')
  })
  
})
shinyApp(ui, server)
