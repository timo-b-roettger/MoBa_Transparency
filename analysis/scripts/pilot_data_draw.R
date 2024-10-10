# description: Create random selection of pilot articles
# author: Max Korbmacher & Timo Roettger
# date: 2023-10-24

# force relevant packages
if (!require("pacman")) install.packages("pacman")
pacman::p_load(rstudioapi, tidyverse)

# set the current working directory to the one where this file is
current_working_dir <- dirname(rstudioapi::getActiveDocumentContext()$path)
setwd(current_working_dir)


##################### PREP DATA

# read data (Moba Publication list dated 1 December 2022)
xdata  <-  read_tsv("../../parseHTML-MoBaPublications/prasedHTML_MoBaPublications.csv", )
# extract DOIs
xdata$doi  <-  sapply(strsplit(xdata$TexttoParse, "https://"), "[", 2)

# count entries
paste("Entries including duplicates:", nrow(xdata))

# exclude duplicates
xdata = xdata[!duplicated(xdata$ApproximateTitle),]

# count entries after exclusions
paste("Unique entries:", nrow(xdata))


#################### PILOT - TEST DATA SPLIT

# draw a random sample
pilot = xdata[sample(nrow(xdata), size = 60, replace = FALSE), ]

# remove pilot from test data
test = data[!data$ApproximateTitle %in% pilot$ApproximateTitle,]

# assign coders randomly to the N = 60 articles, each coder takes 10 articles
# since pilot is already randomly drawn we just assign in order
pilot$Coder <- rep(c("Julien", "Tamara", "Ivana", "Agata", "Max", "Timo"), n = 10)

# save coder sheet and test tables
#write.csv(test, "../data/test_data.csv")
#write.csv(pilot, "../data/pilot_data.csv")
