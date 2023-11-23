library(shiny)
library(DT)
library(ggplot2)
library(dplyr)

# Define UI
ui <- fluidPage(
  titlePanel("Antibiotic Usage in Livestock"),
  
  # Introduction Text
  HTML("<p>Welcome to the Antibiotic Usage in Livestock app. This tool allows you to explore antibiotic usage data across various countries. Select one or more countries from the list to see the data visualized. Created by James Forward.</p>"),
  
  # Sidebar with Country Filter Only
  sidebarLayout(
    sidebarPanel(
      selectInput("countryInput", "Select Country", choices = NULL, selected = NULL, multiple = TRUE)
    ),
    
    # Main Panel for Table, Plot, and Summary organized in Tabset
    mainPanel(
      tabsetPanel(
        tabPanel("Table", DT::dataTableOutput("data_table")),
        tabPanel("Bar Chart", plotOutput("usage_plot")),
        tabPanel("Trend Line", plotOutput("trend_plot")),
        tabPanel("Download", downloadButton("download_data", "Download Data"))
      )
    )
  )
)

# Define server logic
server <- function(input, output, session) {
  
  # Load data from the web
  data <- read.csv("https://raw.githubusercontent.com/owid/owid-datasets/master/datasets/Antibiotic%20use%20in%20livestock%20-%20European%20Commission%20%26%20Van%20Boeckel%20et%20al./Antibiotic%20use%20in%20livestock%20-%20European%20Commission%20%26%20Van%20Boeckel%20et%20al..csv")
  
  # Preprocess to find countries with more than one year of data
  data_counts <- data %>%
    group_by(Entity) %>%
    summarise(Count = n_distinct(Year)) %>%
    filter(Count > 1)
  
  # Update the select input choices dynamically
  updateSelectInput(session, "countryInput", choices = data_counts$Entity)
  
  # Reactive expression for filtered data
  filteredData <- reactive({
    req(input$countryInput)  # Require at least one country to be selected
    data %>% filter(Entity %in% input$countryInput)
  })
  
  # Feature: Interactive Table
  output$data_table <- DT::renderDataTable({
    DT::datatable(filteredData(), options = list(pageLength = 10, order = list(1, 'asc')))
  })
  
  # Feature: Bar Plot Visualization
  output$usage_plot <- renderPlot({
    ggplot(filteredData(), aes(x = Entity, y = `Antibiotic.use.in.livestock`, fill = Entity)) +
      geom_bar(stat = "identity") +
      theme_minimal() +
      labs(title = "Antibiotic Usage in Livestock by Country", x = "Country", y = "Usage")
  })
  
  # Feature: Line Chart Showing Variation Over Years
  output$trend_plot <- renderPlot({
    ggplot(filteredData(), aes(x = Year, y = `Antibiotic.use.in.livestock`, group = Entity, color = Entity)) +
      geom_line() +
      geom_point() +  # Add points to the line chart for better visibility
      theme_minimal() +
      labs(title = "Trend of Antibiotic Usage Over the Years", x = "Year", y = "Usage")
  })
  
  # Feature: Data Download Option
  output$download_data <- downloadHandler(
    filename = function() { "filtered_antibiotic_usage_data.csv" },
    content = function(file) {
      write.csv(filteredData(), file)
    }
  )
}

# Run the application 
shinyApp(ui = ui, server = server)
