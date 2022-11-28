library(ggplot2)

path = '/Users/vladaefremenko/R_Lab3/data/data_tula.csv'

plot_graphics <- function(df){
  gg1 <- ggplot(data = df, mapping = aes(x = Breeds, y = Value_indicator, fill = Breeds)) +
    geom_col() + coord_flip() +
    xlab("Породы") + ylab("Тыс. га") +
    ggtitle('Площадь земель, занятых лесными насаждениями') + 
    geom_text(aes(label = Value_indicator), vjust = 0.5)
  
  gg1 <- gg1 + guides( fill = guide_legend(title = "Породы", override.aes = aes(label = "")))
  print(gg1)
  
  gg2 <- ggplot(data = df, mapping = aes(x = '', y = Value_indicator, fill = Breeds)) +
    geom_col() + coord_polar(theta = 'y') +
    ggtitle('Площадь земель, занятых лесными насаждениями') + ylab('Тыс. га')
  gg2 <- gg2 + guides(fill = guide_legend(title = "Породы", override.aes = aes(label = "")))
  print(gg2)
}

data <- read.csv(path, sep=";")
colnames(data) <- c("Breeds", "Name_indicator", "Unit", "Value_indicator")
new_data <- subset(data, Name_indicator == "Площадь земель, занятых лесными насаждениями (покрытых лесной растительностью), всего")
new_data[[4]] <- sub(',', '.', new_data[[4]])
new_data[[4]] <- as.numeric(new_data[[4]])
plot_graphics(new_data)