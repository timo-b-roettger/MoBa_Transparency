# create random selection of N = 60 pilot articles distributed across M = 6 coders
# Max Korbmacher (max.korbmacher@gmail.com), 24 October 2023
# Edited by Timo Roettger (timo.b.roettger@gmail.com), 25 October 2023

# force relevant packages
if (!require("pacman")) install.packages("pacman")
pacman::p_load(rstudioapi, tidyverse)

# set the current working directory to the one where this file is
current_working_dir <- dirname(rstudioapi::getActiveDocumentContext()$path)
setwd(current_working_dir)


##################### PREP DATA

# read data (Moba Publication list dated 1 December 2022)
data = read.csv("prasedHTML_MoBaPublications.csv", sep = "\t")
# extract dois
data$doi = sapply(strsplit(data$TexttoParse, "https://"), "[", 2)

# count entries
paste("Entries including dublicates:", nrow(data))

# exclude duplicates
data = data[!duplicated(data$ApproximateTitle),]

# count entries after exclusions
paste("Unique entries:", nrow(data))


#################### PILOT - TEST DATA SPLIT

# draw a random sample
pilot = data[sample(nrow(data), size = 60, replace = FALSE), ]

# remove pilot from test data
test = data[!data$ApproximateTitle %in% pilot$ApproximateTitle,]

# assign coders randomly to the N = 60 articles, each coder takes 10 articles
# since pilot is already randomly drawn we just assign in order
pilot$Coder <- rep(c("Julien", "Tamara", "Ivana", "Agata", "Max", "Timo"), n = 10)

# save coder sheet and test tables
write.csv(test, "test_data.csv")
write.csv(pilot, "pilot_data.csv")
