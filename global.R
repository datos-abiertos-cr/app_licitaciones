# global.R
library(shiny)
library(shinydashboard)
library(ggplot2)
library(dplyr)
library(feather)
library(kableExtra)

# Datos -------------------------------------------------------------------
licitaciones <- read_feather("datos/licitaciones.feather")

adjudicaciones_dolares <- licitaciones %>% 
  filter(monedda == "USD")

adjudicaciones_colones <- licitaciones %>% 
  filter(monedda == "CRC")

# Funcion formato moneda --------------------------------------------------
moneda <- function(x, moneda = "colones") {
  if (moneda == "colones") {
    lucr::to_currency(x, currency_symbol = "₡",
                      symbol_first = TRUE, group_size = 3,
                      group_delim = ".", decimal_size = 2,
                      decimal_delim = ",")
  } else if (moneda == "dolares") {
    lucr::to_currency(x, currency_symbol = "$",
                      symbol_first = TRUE, group_size = 3,
                      group_delim = ".", decimal_size = 2,
                      decimal_delim = ",")
  } else {
    print("Error de denominación de moneda")
  }
}

# Formato números --------------------------------------------------------

options(scipen = 9999)


