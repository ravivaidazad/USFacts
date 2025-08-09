library(shiny)
library(plotly)
library(dplyr)
library(readr)
library(scales)

ui <- fluidPage(
  titlePanel("US States - Hover Over for Facts by Ravi Vaid"),
  plotlyOutput("us_map", height = "600px")
)

server <- function(input, output, session) {
  
  output$us_map <- renderPlotly({
    
    state_facts = read_csv("https://raw.githubusercontent.com/ravivaidazad/USFacts/main/State_Data.csv")
    
    
    # Create hover text
    state_facts <- state_facts %>%
      mutate(hover_text = paste0(
        "<b>", State, "</b>",
        "<br>Pop 2024: ", comma(Pop_2024),
        "<br>Males: ", comma(Male),
        "<br>Females", comma(Female),
        "<br>Households Median Income: ", comma(Households_Median_Income),
        "<br>Families Median Income: ", comma(Families_Median_Income)
      ))
    
    # Build plotly map
    plot_geo(state_facts, locationmode = "USA-states") %>%
      add_trace(
        z = ~Pop_2024,
        locations = ~Abbreviation,
        text = ~hover_text,
        hoverinfo = "text",
        colors = "Blues"
      ) %>%
      layout(
        geo = list(
          scope = "usa",
          projection = list(type = "albers usa"),
          showlakes = TRUE,
          lakecolor = toRGB("white"),
          showframe = FALSE,
          showcoastlines = TRUE,
          fixedrange = TRUE
        )
      )
  })
}

shinyApp(ui, server)
