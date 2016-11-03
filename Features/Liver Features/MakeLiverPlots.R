library(dplyr)
library(ggplot2)

#Get T_df dataset
setwd(dirname(rstudioapi::getActiveDocumentContext()$path)) #set directory to current directory
setwd("../../SuperMatrix/")
source("MatrixBuilder2.R")
setwd("../Features/Liver Features")

head(T_df)

Liver = filter(T_df, LiverMask==1, Pre > -200, Art > -200, Ven > -200, Del > -200)
Tumor = filter(T_df, TumorMask == 1, Pre > -200, Art > -200, Ven > -200, Del > -200)
Liver = mutate(Liver, new = Art - Pre)
Tumor = mutate(Tumor, new= Art - Pre)


ggplot(Liver) + geom_area(aes(Pre, color = "Pre"),stat="bin",color="red", fill="red",alpha=.5,binwidth=10)+
  geom_area(aes(Art, color = "Art"),stat="bin", fill="green",color="green",alpha=.5,binwidth=10) + 
  geom_area(aes(Ven, color = "Ven"),stat="bin", fill="pink",color="pink",alpha=.5,binwidth=10)  +
  geom_area(aes(Del, color = "Del"),stat="bin", fill="blue",color="blue",alpha=.5,binwidth=10) +
  theme(legend.position="left") +
  scale_colour_manual("Legend:", values = c("red","green","pink","blue")) +
  labs(title="Four Liver Phases", x="HU",y="Frequency")

ggplot(Liver) +
  geom_area(aes(new), stat="bin", fill = "blue",alpha=.5) +
  geom_area(data = Tumor, aes(new), stat = "bin", fill = "red")
