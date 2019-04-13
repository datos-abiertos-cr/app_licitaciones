# ui.R

# Encabezado --------------------------------------------------------------
header <- dashboardHeader(
  title = "Licitaciones adjudicadas 2014-2015"
)


# Sidebar -----------------------------------------------------------------
sidebar <- dashboardSidebar(
  sidebarMenu(
    menuItem("Resumen General", tabName = "resumen_general", icon = icon("suitcase")),
    menuItem("Figuras", tabName = "figuras_tipo_tramite", icon = icon("chart-bar")),
    menuItem("Instituciones Públicas", tabName = "proveedores_por_institucion",
             icon = icon("building "))
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
    ),
    tabItem(
      tabName = "proveedores_por_institucion",
      fluidRow(
        plotOutput("instituciones")
      ),
      fluidRow(
        column(
          width = 6,
          uiOutput("proveedores_slider")
      ),
      column(
        width = 6,
        selectInput("institucion", "Institución pública",
                    choices = adjudicaciones_colones$institucion)
      )
      )
    )
  )
})

# App completo ------------------------------------------------------------
dashboardPage(
  skin = "black",
  header,
  sidebar,
  body
)



