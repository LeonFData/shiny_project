library(data.table)
library(lightgbm)

# Read model
model <- readRDS("model.rds")

# Read data
kyc_data <- read.csv("https://github.com/LeonFData/shiny_project/raw/main/kyc_data.csv")

# convert categorical to factor type
cols_cat = c("loss_comfort", "increase_risk", "investable_assets", "savings", "dependents", "goal", "objective", "debt", "horizon", "portfolio_name", "knowledge", "withdrawal")
kyc_data[cols_cat] = lapply(kyc_data[cols_cat], as.factor)

# Build model
#cols_x = c('loss_comfort', 'savings', 'increase_risk', 'investable_assets', 'objective', 'horizon', "portfolio_name")
cols_x = c("loss_comfort", "increase_risk", "investable_assets", "savings", "portfolio_name")
input_data = kyc_data[cols_x]

indexes = createDataPartition(input_data$portfolio_name, p = .75, list = F)
kyc_train = input_data[indexes, ]
kyc_test = input_data[-indexes, ]

kyc_rules <- lgb.convert_with_rules(data = kyc_train)

kyc_train <- kyc_rules$data
kyc_test <- lgb.convert_with_rules(data = kyc_test, rules = kyc_rules$rules)$data

kyc_train$portfolio_name <- as.numeric(as.factor(kyc_train$portfolio_name)) - 1
kyc_test$portfolio_name <- as.numeric(as.factor(kyc_test$portfolio_name)) - 1


shinyServer(function(input, output, session) {
  
  # Input Data
  datasetInput <- reactive({  
    
    # outlook,temperature,humidity,windy,play
    df <- data.frame(
      Name = c("loss_comfort",
               "increase_risk",
               "investable_assets",
               "savings"),
      Value = as.character(c(input$loss_comfort,
                             input$increase_risk,
                             input$investable_assets,
                             input$savings)),
      stringsAsFactors = FALSE)
    
    #portfolio_name <- "portfolio_name"  # label column
    #df <- rbind(df, portfolio_name)
    input <- transpose(df)
    write.table(input,"input.csv", sep=",", quote = FALSE, row.names = FALSE, col.names = FALSE)
    #write.table(input, paste("input_", format(Sys.time(), "%Y-%m-%d_%H:%M"), ".csv", sep = ""), sep=",", quote = FALSE, row.names = FALSE, col.names = FALSE)
    
    test_input <- read.csv(paste("input", ".csv", sep=""), header = TRUE)
    
    test_input = lgb.convert_with_rules(test_input, rules = kyc_rules$rules[c(1,2,3,4)])$data
    
    Output <- data.frame(Portfolio=c("Balanced Growth & Income", "Growth", "Income"), Probability=predict(model,as.matrix(test_input)))
  })
  
  # Status/Output Text Box
  output$contents <- renderPrint({
    if (input$submitbutton>0) { 
      isolate("Calculation complete.") 
    } else {
      return("Server is ready for prediction")
    }
  })
  
  # Prediction results table
  output$tabledata <- renderTable({
    if (input$submitbutton>0) { 
      isolate(datasetInput()) 
    } 
  })
  
})
