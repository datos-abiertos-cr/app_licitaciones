# ui.R
library(shiny)
library(shinydashboard)
library(ggplot2)
library(dplyr)
library(feather)
library(kableExtra)

# Encabezado --------------------------------------------------------------
header <- dashboardHeader(
  title = "Licitaciones adjudicadas 2014-2015"
)


# Sidebar -----------------------------------------------------------------
sidebar <- dashboardSidebar(
  sidebarMenu(
    menuItem("Resumen General", tabName = "resumen_general", icon = icon("suitcase")),
    menuItem("Figuras", tabName = "figuras_tipo_tramite", icon = icon("chart-bar"))
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
    ),
    tabItem(
      tabName = "figuras_tipo_tramite",
      fluidRow(
        box(width = 6,
            title = "Adjudicaciones por tipo de tramite",
            status = "danger",
            plotOutput("adjudicaciones_colones"))
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



