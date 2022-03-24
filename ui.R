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
