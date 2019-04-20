# ui.R

# Encabezado --------------------------------------------------------------
header <- dashboardHeader(
  title = "Licitaciones adjudicadas 2014-2015"
)


# Sidebar -----------------------------------------------------------------
sidebar <- dashboardSidebar(
  sidebarMenu(
    menuItem("Resumen General", 
             tabName = "resumen_general",
             icon = icon("suitcase")),
    
    menuItem("Proveedores", 
             tabName = "instituciones_por_proveedor",
             icon = icon("chart-bar")),
    
    menuItem("Instituciones Públicas", 
             tabName = "proveedores_por_institucion",
             icon = icon("building "))
  )
)

# Cuerpo ------------------------------------------------------------------
body <- dashboardBody({
  tabItems(

# TAB GENERAL -------------------------------------------------------------

    tabItem(
      tabName = "resumen_general",
      fluidRow(
        box(width = 6,
            title = "Cuadro mayores instituciones  con adjudicaciones",
            status = "danger",
            tableOutput("instituciones_adjudicacion"))
      )
    ),
    

# TAB PROVEEDORES ---------------------------------------------------------

    tabItem(
      tabName = "instituciones_por_proveedor",
      fluidRow(
        column(
          width = 6,
          box(
            width = 12,
            title = "ELegir cantidad de instituciones a graficar",
            status = "info",
            solidHeader = TRUE,
            uiOutput("cantidad_instituciones_slider")
          )
        ),
        column(
          width = 6,
          box(
            width = 12,
            title = "ELegir proveedor a explorar",
            status = "info",
            solidHeader = TRUE,
            selectInput("proveedor", "Proveedor",
                        choices = adjudicaciones_colones$proveedor_adjudicado)
          )
        )),
      
      fluidRow(
        column(
          width = 8,
          box(
            width = 12,
            title = "Cantidad de instituciones con mayores montos",
            status = "primary",
            solidHeader = TRUE,
            plotOutput("proveedores")
          )
        ),
        column(
          width = 4,
          box(
            width = 12,
            title = "Porcentaje de instituciones elegidos con respecto al total",
            status = "warning",
            solidHeader = TRUE,
            plotOutput("porcentaje_seleccion_proveedor")
          )
        ))
      
    ),


# TAB INSTITUCIONES -------------------------------------------------------

    tabItem(
      tabName = "proveedores_por_institucion",
      fluidRow(
        column(
          width = 6,
          box(
            width = 12,
            title = "ELegir cantidad de proveedores a graficar",
            status = "info",
            solidHeader = TRUE,
            uiOutput("cantidad_proveedores_slider")
          )
        ),
        column(
          width = 6,
          box(
            width = 12,
            title = "ELegir institución pública a explorar",
            status = "info",
            solidHeader = TRUE,
            selectInput("institucion", "Institución pública",
                        choices = adjudicaciones_colones$institucion)
          )
        )),
      
      fluidRow(
        column(
          width = 8,
          box(
            width = 12,
            title = "Cantidad de proveedores con mayores montos",
            status = "primary",
            solidHeader = TRUE,
            plotOutput("instituciones")
          )
      ),
      column(
        width = 4,
        box(
          width = 12,
          title = "Porcentaje de proveedores elegidos con respecto al total",
          status = "warning",
          solidHeader = TRUE,
          plotOutput("porcentaje_seleccion")
        )
      ))
      
    )
  )
})

# App completo ------------------------------------------------------------
dashboardPage(
  skin = "purple",
  header,
  sidebar,
  body
)



