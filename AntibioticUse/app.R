library(shiny)
library(shinyWidgets)
library(DT)
library(ggplot2)
library(dplyr)
library(plotly)

# Define UI
ui <- fluidPage(
  titlePanel("Antibiotic Usage in Livestock"),
  
  # Introduction Text
  HTML("<p>Welcome to the Antibiotic Usage in Livestock app. This tool allows you to explore antibiotic usage data across various countries. Select one or more countries from the list to see the data visualized. Created by James Forward.</p>"),
  
  # Sidebar with Country Filter and Search
  sidebarLayout(
    sidebarPanel(
      pickerInput(
        inputId = "countryInput", 
        label = "Select Country", 
        choices = NULL, # to be updated from server
        options = list(`actions-box` = TRUE), # allows for select/deselect all
        multiple = TRUE
      ),
      textInput("searchCountry", "Search Country", value = "")
    ),
    
    # Main Panel for Table, Plot, and Summary organized in Tabset
    mainPanel(
      tabsetPanel(
        tabPanel("Table", DT::dataTableOutput("data_table"), downloadButton("download_data", "Download Data")),
        tabPanel("Bar Chart", plotlyOutput("usage_plot")),
        tabPanel("Trend Line", plotlyOutput("trend_plot")),
        tabPanel("Summary Statistics", uiOutput("summaryStats"))
      )
    )
  )
)

# Define server logic
server <- function(input, output, session) {
  
  # Load data from the web
  data <- read.csv("https://raw.githubusercontent.com/owid/owid-datasets/master/datasets/Antibiotic%20use%20in%20livestock%20-%20European%20Commission%20%26%20Van%20Boeckel%20et%20al./Antibiotic%20use%20in%20livestock%20-%20European%20Commission%20%26%20Van%20Boeckel%20et%20al..csv")
  
  # Calculate countries with more than one year of data
  data_counts <- data %>%
    group_by(Entity) %>%
    summarise(Count = n_distinct(Year)) %>%
    filter(Count > 1) %>%
    ungroup() # Important to ungroup to avoid grouping affecting further operations
  
  # Update the select input choices dynamically
  observe({
    updatePickerInput(session, "countryInput", choices = data_counts$Entity)
  })
  
  # Reactive expression for filtered data
  filteredData <- reactive({
    req(input$countryInput)  # Require at least one country to be selected
    data %>% filter(Entity %in% input$countryInput)
  })
  
  # Feature: Interactive Table
  output$data_table <- DT::renderDataTable({
    DT::datatable(filteredData(), options = list(pageLength = 10, order = list(1, 'asc')), rownames = FALSE)
  })
  
  # Feature: Bar Plot Visualization (Plotly)
  output$usage_plot <- renderPlotly({
    gg <- ggplot(filteredData(), aes(x = Entity, y = `Antibiotic.use.in.livestock`, fill = Entity)) +
      geom_bar(stat = "identity") +
      theme_minimal() +
      labs(title = "Antibiotic Usage in Livestock by Country", x = "Country", y = "Usage")
    ggplotly(gg)
  })
  
  # Feature: Line Chart Showing Variation Over Years (Plotly)
  output$trend_plot <- renderPlotly({
    gg <- ggplot(filteredData(), aes(x = Year, y = `Antibiotic.use.in.livestock`, group = Entity, color = Entity)) +
      geom_line() +
      geom_point() +
      theme_minimal() +
      labs(title = "Trend of Antibiotic Usage Over the Years", x = "Year", y = "Usage")
    ggplotly(gg)
  })
  
  # Feature: Dynamic Summary Statistics
  output$summaryStats <- renderUI({
    req(filteredData())
    data <- filteredData()
    
    if(nrow(data) > 0) {
      meanUsage <- mean(data$`Antibiotic.use.in.livestock`, na.rm = TRUE)
      medianUsage <- median(data$`Antibiotic.use.in.livestock`, na.rm = TRUE)
      rangeUsage <- range(data$`Antibiotic.use.in.livestock`, na.rm = TRUE)
      
      tagList(
        h4("Summary Statistics:"),
        p("Mean Antibiotic Usage: ", round(meanUsage, 2)),
        p("Median Antibiotic Usage: ", round(medianUsage, 2)),
        p("Range of Antibiotic Usage: ", paste(rangeUsage[1], "to", rangeUsage[2]))
      )
    } else {
      p("No data available for the selected countries.")
    }
  })
  
  # Reactivity for the search bar
  observeEvent(input$searchCountry, {
    choices <- if (input$searchCountry != "") {
      grep(input$searchCountry, data_counts$Entity, value = TRUE)
    } else {
      data_counts$Entity
    }
    
    updatePickerInput(session, "countryInput", choices = choices)
  })
}

# Run the application 
shinyApp(ui = ui, server = server)
