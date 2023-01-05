library(shiny)


fluidPage(theme = shinytheme("superhero"),
                
                # Page header
                headerPanel('Welcome to FWL'),
                
                # Input values
                sidebarPanel(
                  HTML("<h3>Please answer the following KYC Questions</h3>"),
                  
                  selectInput("loss_comfort", label = "If your portfolio were to decrease in value by 25% due to market conditions, what would you do?", 
                              choices = list("Do Nothing / No Change" = "Do Nothing / No Change", 
                                             "Move all liquid investments to cash or bonds" = "Move all liquid investments to cash or bonds", 
                                             "Purchase more stocks" = "Purchase more stocks",
                                             "Rebalance (Sell bonds and purchase stocks)" = "Rebalance (Sell bonds and purchase stocks)"), 
                              selected = "Do Nothing / No Change"),
                  
                  selectInput("increase_risk", label = "If you ...", 
                              choices = list("Be unlikely to take much more risk?" = "Be unlikely to take much more risk?", 
                                             "Be willing to take a little more risk with some of your money?" = "Be willing to take a little more risk with some of your money?",
                                             "Be willing to take a little more risk with all of your money?" = "Be willing to take a little more risk with all of your money?",
                                             "Be willing to take a lot more risk with some of your money?" = "Be willing to take a lot more risk with some of your money?",
                                             "Be willing to take a lot more risk with all of your money?" = "Be willing to take a lot more risk with all of your money?"), 
                              selected = "I have set aside savings to cover such expenses"),
                  
                  selectInput("investable_assets", label = "investable_assets", 
                              choices = list("Less than 25%" = "Less than 25%",
                                             "Between 25% and 50%" = "Between 25% and 50%", 
                                             "Between 51% and 75%" = "Between 51% and 75%",
                                             "More than 75%" = "More than 75%"), 
                              selected = "I have set aside savings to cover such expenses"),
                  
                  selectInput("savings", label = "Have you set aside savings to cover expenses such as purchasing a home, college tuition, or financial emergency?", 
                              choices = list("I have set aside savings to cover such expenses" = "I have set aside savings to cover such expenses", 
                                             "I have not set aside savings to cover such expenses" = "I have not set aside savings to cover such expenses"), 
                              selected = "I have set aside savings to cover such expenses"),
                  
                  actionButton("submitbutton", "Submit", class = "btn btn-primary"),
                  width = 30
                ),
                
                mainPanel(
                  tags$label(h3('Model Output')), # Status/Output Text Box
                  verbatimTextOutput('contents'),
                  tableOutput('tabledata') # Prediction results table
                  
                )
)