library(dplyr)
library(ggplot2)

#Get T_df dataset
setwd(dirname(rstudioapi::getActiveDocumentContext()$path)) #set directory to current directory
setwd("../../SuperMatrix/")
source("MatrixBuilder2.R")
setwd("../Features/Liver Features")

head(T_df)

Liver = filter(T_df,LiverMask==1, Pre > -200, Art > -200, Ven > -200, Del > -200)
Tumor = filter(T_df, TumorMask == 1, Pre > -200, Art > -200, Ven > -200, Del > -200)
Liver = mutate(Liver, new = Art - Pre)
Tumor = mutate(Tumor, new= Art - Pre)


ggplot(Liver) + geom_area(aes(Pre),stat="bin",color="red", fill="red",alpha=.5,binwidth=10)+
  geom_area(aes(Art),stat="bin", fill="green",color="green",alpha=.5,binwidth=10) + 
  geom_area(aes(Ven),stat="bin", fill="pink",color="pink",alpha=.5,binwidth=10)  +
  geom_area(aes(Del),stat="bin", fill="blue",color="blue",alpha=.5,binwidth=10) +
  geom_area(data = Tumor, aes(Pre),stat="bin", fill="red",color="red",alpha=.5,binwidth=10) +
  geom_area(data = Tumor, aes(Art),stat="bin", fill="green",color="green",alpha=.5,binwidth=10) +
  geom_area(data = Tumor, aes(Ven),stat="bin", fill="pink",color="pink",alpha=.5,binwidth=10) +
  geom_area(data = Tumor, aes(Del),stat="bin", fill="blue",color="blue",alpha=.5,binwidth=10) +
  annotate("text", x=40, y = 110000, label = "Pre") +
  annotate("text", x=83, y = 95000, label = "Art") +
  annotate("text", x=107, y = 77000, label = "Del") +
  annotate("text", x=140, y = 70000, label = "Ven") +
  labs(title="Liver and Tumor Histograms, 4 phases", x="HU" , y="Frequency")


