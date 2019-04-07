# ui.R
library(shiny)
library(shinydashboard)
library(ggplot2)
library(dplyr)
library(feather)

# Encabezado --------------------------------------------------------------
header <- dashboardHeader(
  title = "Licitaciones adjudicadas 2014-2015"
)


# Sidebar -----------------------------------------------------------------
sidebar <- dashboardSidebar(
  sidebarMenu(
    menuItem("Resumen General", tabName = "resumen_general", icon = icon("suitcase"))
  )
)

# Cuerpo ------------------------------------------------------------------
body <- dashboardBody({
  tabItems(
    tabItem(
      tabName = "resumen_general",
      fluidRow(
        box(width = 6,
            title = "Cuadro mayores instituciones  con adjudicaciones",
            status = "danger",
            tableOutput("instituciones_adjudicacion"))
      )
    )
  )
})

# App completo ------------------------------------------------------------
dashboardPage(
  skin = "blue",
  header,
  sidebar,
  body
)



