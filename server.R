#source("function.R")
shinyServer(function(input, output, session) {
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
