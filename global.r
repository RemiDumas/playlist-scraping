library(dplyr)
library(tidyr)
library(ggplot2)
library(purrr)
library(rvest)
library(stringr)
library(xml2)
library(lubridate)
library(shiny)
library(xlsx)
#### Déclaration de variables globales ####

#### Appli shiny ####
data <- read.csv2("data.csv")

enr <- function(a) {
  case_when(
    a == "toto" ~  rnorm(1, 20, 5),
    a == "titi" ~  rnorm(1, 40, 5),
    a == "tata" ~  rnorm(1, 60, 5),
    TRUE ~ rnorm(1, 80, 5)
  )
}

maj <- function() {
  d <- read.csv("data.csv", stringsAsFactors = F)
  d <-
    bind_rows(d,
              tibble(
                a = sample(c("toto", "titi", "tata", "tutu"), 50, replace = T),
                x = sample(1:100, 50, replace = T)
              ) %>%
                mutate(y = map_dbl(a, ~ enr(.x))
                       )
              ) %>% sample_n(50)
  
  write.csv(d, "data.csv", row.names = F)
  return (d)
}

data_init <- maj()
