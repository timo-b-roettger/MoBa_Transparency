# Assign test data to coders
# Timo Roettger (timo.b.roettger@gmail.com), 25 October 2023

# force relevant packages
if (!require("pacman")) install.packages("pacman")
pacman::p_load(rstudioapi, tidyverse)

# set the current working directory to the one where this file is
current_working_dir <- dirname(rstudioapi::getActiveDocumentContext()$path)
setwd(current_working_dir)

# read list of test articles
test <- read_csv("test_data.csv")
# n = 945

# randomize order
shuffled_data = test[sample(1:nrow(test)), ] 

# assign coders to the N = 945 articles, each coder takes 157 or 158 articles
# since rows are already shuffled we just assign in order
shuffled_data$Coder <- c(rep(c("Julien", "Tamara", "Ivana", "Agata", "Max", "Timo"), times = 157), c("Julien", "Tamara", "Ivana"))

# double check
xtabs(~Coder, shuffled_data)

# now select 20% and assign another coder
subset_n <- 0.2*nrow(shuffled_data) # 189
shuffled_data$Coder2 <- as.character("")
shuffled_data[1:subset_n,]$Coder2 <- c(rep(c("Agata", "Max", "Timo","Julien", "Tamara", "Ivana"), times = 31), c("Agata", "Max", "Timo"))

# double check
xtabs(~Coder + Coder2, shuffled_data)

write.csv(shuffled_data, "test_coding_assignment.csv")

