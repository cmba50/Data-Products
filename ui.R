library(shiny)

shinyUI(fluidPage(
  titlePanel("What drives optimal MPG?"),
  sidebarLayout(
    sidebarPanel(
      checkboxGroupInput('show_vars', 'Select only relevant features driving MPG:',
                           names(mtcars[-1])
      ),
      actionButton("plotGraph", "View Correlations"),
      helpText("Use this button to gain additional insight into the dataset"),
      actionButton("fitLM", "Test Your Knowledge"),
      helpText("Use this button when ready to see results of your selection")
    ),
    mainPanel(
      h3("Relationships Between Selected Features"),
      plotOutput("plot1"),
      br(),
      h3("Results of Statistical Analysis: "),
      htmlOutput("predict")
  
    )
  )
)) 

