library(shiny)
shinyServer(function(input, output) {
  
  # Plot the variance pairs, start with a blank page
  output$plot1 <- renderPlot({
  
  if (input$plotGraph == 0) { 
        return()
 
  }
  else {
    #Get the user input on feature selection
    userInput <- mtcars[, c("mpg", input$show_vars), drop = FALSE]
    
    input$plotGraph 
    
    if (ncol(userInput) > 1) {
    pairs(userInput, panel = panel.smooth)
    }
  }  
   
  })
  
  testFit <- reactive({
    
    # Get the user input on selected features
    userInput <- mtcars[, c("mpg", input$show_vars), drop = FALSE]
   
    #Create the multivariate model fit based on selected features
    newFit <- lm(mpg ~ ., data = data.frame(userInput))
    
    if (ncol(userInput) > 1) {
      #Perform hypothesis testing and check significance based on the p-values 
      nVar <- nrow(summary(newFit)$coef)
      if (any(summary(newFit)$coef[2:nVar,4] > 0.05)) 0 else 1  
    }
    else 0
  })
  
  modelFit <- reactive({
  
    # Get the user input on selected features
    userInput <- mtcars[, c("mpg", input$show_vars), drop = FALSE]
    
    #Create the multivariate model fit based on selected features
    newFit <- lm(mpg ~ ., data = data.frame(userInput))
    
    summary(newFit)$adj.r.squared
    
  })
  
  output$predict <- renderText({
    
  if (input$fitLM == 0) 
    return()  
  
  input$fitLM 
     
  isolate(  
    if(testFit()) {
      
      #The benchmark regression fit (based on previous analysis)
      #bkFit <- lm(mpg ~ wt + qsec + am + wt * am, data = mtcars)
      bkFit <- lm(mpg ~ wt + qsec + am, data = mtcars)
      bMark <- summary(bkFit)$adj.r.squared
      
      if(bMark - modelFit() < 0.01) {
        paste("<font color=\"#FF0000\"><b>", "You've nailed it! The adjusted R-squared value of your best model is ", 
              round(modelFit(), digits = 3), "</b></font>")
        
      }
      else {
        paste("But you can do better than this, R-squared = ", round(modelFit(), digits = 3), "\n", 
        ".Try to select additional features!")
      }
      
    }
    else {
      "Selection indicates no linear relationship. Please try again!"
    }
  )  
 
  })
  
  
})

