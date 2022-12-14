library(stringr)
library(dplyr)
library(tidyr)
library(ggplot2)

path = '/Users/vladaefremenko/R_Lab3/data/ExpImp.RData'
REGION <- 'Сибирский федеральный округ'

plot_graphics <- function(data, str){
  data <- data[complete.cases(data),]
  for (i in 2:length(names(data))) {
    data[[i]] <- gsub("-", 0, data[[i]])
    data[[i]] <- as.numeric(data[[i]])
  }
  
  flt <- str_detect(data$Регион, 'федеральный округ')
  rdf <- mutate(data, Округ = if_else(flt, Регион, NULL))
  rdf <- fill(rdf, Округ)
  flt2 <- !str_detect(rdf$Регион, 'Федерация|федеральный округ')
  rdf <- filter(rdf, flt2)
  
  match_exp <- select_at(rdf, vars(matches("Экспорт")))
  match_imp <- select_at(rdf, vars(matches("Импорт")))
  
  match_exp$Сумма <- rowSums(match_exp, na.rm = TRUE)
  match_imp$Сумма <- rowSums(match_imp, na.rm = TRUE)
  
  rdf$SumExport <- match_exp$Сумма
  rdf$SumImport <- match_imp$Сумма
  
  if (str == 'Reflect'){
    rdf[,"SumImport"] <- -rdf[,"SumImport"]
  }

  rdf <- filter(rdf, Округ == REGION)
  rdf <- rdf[,c("Регион", "SumExport", "SumImport" )]
  rdf <- pivot_longer(rdf, !Регион, names_to = "Экспорт/Импорт", values_to = "млн долларов США")
  
  
  sum_reg <- rdf %>% group_by(Регион, `Экспорт/Импорт`) 
  sum_reg <- sum_reg %>% summarise(sum = sum(`млн долларов США`))
  
  sum_reg |>
    ggplot(mapping = aes(x = Регион, y = sum, fill = `Экспорт/Импорт`)) +
    geom_col(color = 'black', size = 0.2, position = 'dodge') + 
    ggtitle(REGION) + ylab('млн долларов США') + coord_flip() 
    #geom_text(aes(label = sum), hjust=0.5, vjust = 1, angle = 45)
}

load(path)
plot_graphics(ExpImp, 'Non-reflect')
plot_graphics(ExpImp, 'Reflect')


