# server

server <- function(input, output) {

# TAB GENERAL -------------------------------------------------------------

  output$instituciones_adjudicacion <- function(){
    adjudicaciones_colones <- adjudicaciones_colones %>% 
      group_by(institucion) %>% 
      summarise(
        total = n(),
        monto = sum(monto_adjudicado, na.rm = TRUE)
      ) %>% 
      arrange(desc(total)) %>% 
      mutate(monto = moneda(monto))
    
    adjudicaciones_colones %>% 
      slice(1:30) %>% 
      knitr::kable("html") %>%
      kable_styling(bootstrap_options = c("striped", "hover"))
  }
  
  output$cantidad_instituciones <- renderValueBox({
    valueBox(length(unique(adjudicaciones_colones$institucion)),
             "Instituciones públicas en total analizadas",
             icon = icon("city"),
             color = "aqua")
  })
  
  output$cantidad_proveedores <- renderValueBox({
    valueBox(length(unique(adjudicaciones_colones$proveedor_adjudicado)),
             "Proveedores en total analizados",
             icon = icon("cart-plus"),
             color = "olive")
  })

# TAB PROVEEDORES ---------------------------------------------------------
  
  datos_proveedor <- reactive({
    datos_proveedor <- adjudicaciones_colones %>%
      filter(proveedor_adjudicado == input$proveedor) %>%
      group_by(institucion)
  }) 
  
  output$cantidad_instituciones_slider <- renderUI({
    datos_proveedor_unicos <- datos_proveedor() %>%
      summarise(
        total_contratos = n()
      )
    sliderInput("instituciones_slider", "Cantidad de instituciones públicas",
                min = 1,
                max = nrow(datos_proveedor_unicos),
                value = 10)
  })

  output$proveedores <- renderPlot({
    datos_proveedor() %>%
      summarise(
        total_contratos = n(),
        total_monto = sum(monto_adjudicado)
      ) %>%
      arrange(desc(total_monto)) %>%
      slice(1:input$instituciones_slider) %>%
      ggplot(aes(x = reorder(institucion, total_monto), y = total_monto, fill = institucion)) +
      geom_bar(stat = "identity") +
      scale_fill_viridis_d() +
      labs(y = "Total monto adjudicado",
           x = "Instituciones que adjudicaron") +
      coord_flip() +
      theme_bw(base_size = 14) +
      theme(axis.text.x  = element_text(angle = 25, vjust = 0.5, size = 16)) +
      theme(legend.position = "none")
  })


  output$porcentaje_seleccion_proveedor <- renderPlot({
    datos <- datos_proveedor() %>%
      summarise(
        total_contratos = n(),
        total_monto = sum(monto_adjudicado)
      )

    valores_seleccionar <- datos %>%
      arrange(desc(total_monto)) %>%
      slice(1:input$instituciones_slider)

    valor <- min(valores_seleccionar$total_monto)

    datos %>%
      mutate(seleccion = ifelse(total_monto >= valor, "Seleccionados", "Resto")) %>%
      mutate(unidad = "") %>%
      ggplot(aes(x = unidad, y = total_monto, fill = seleccion)) +
      geom_bar(stat = "identity", position = "fill") +
      scale_fill_manual(values = c("#2B7C8D", "#73CF56" )) +
      labs(x = "",
           y = "Porcentaje correspondiente del monto total",
           fill = "Selección de la cantidad
       de instituciones") +
      theme_classic()

  })

# TAB INSTITUCIONES -------------------------------------------------------

 datos_institucion <- reactive({
   datos_institucion <- adjudicaciones_colones %>%
     filter(institucion == input$institucion) %>%
     group_by(proveedor_adjudicado)
 }) 
  
 output$cantidad_proveedores_slider <- renderUI({
     datos_institucion_unicos <- datos_institucion() %>%
      summarise(
        total_contratos = n()
      )
    
    sliderInput("proveedores_slider", "Cantidad de proveedores",
                min = 1,
                max = nrow(datos_institucion_unicos),
                value = 10,
                round = TRUE,
                step = 1)
  })

  output$instituciones <- renderPlot({
    datos_institucion() %>%
      summarise(
        total_contratos = n(),
        total_monto = sum(monto_adjudicado)
      ) %>%
      arrange(desc(total_monto)) %>%
      slice(1:input$proveedores_slider) %>%
      ggplot(aes(x = reorder(proveedor_adjudicado, total_monto), y = total_monto, fill = proveedor_adjudicado)) +
      geom_bar(stat = "identity") +
      scale_fill_viridis_d() +
      labs(y = "Total monto adjudicado",
           x = "Proveedores adjudicados") +
      coord_flip() +
      theme_bw(base_size = 14) +
      theme(axis.text.x  = element_text(angle = 25, vjust = 0.5, size = 16)) +
      theme(legend.position = "none")
  })

  output$porcentaje_seleccion <- renderPlot({
    datos <- datos_institucion() %>%
      summarise(
        total_contratos = n(),
        total_monto = sum(monto_adjudicado)
      )

    valores_seleccionar <- datos %>%
      arrange(desc(total_monto)) %>%
      slice(1:input$proveedores_slider)

    valor <- min(valores_seleccionar$total_monto)

    datos %>%
      mutate(seleccion = ifelse(total_monto >= valor, "Seleccionados", "Resto")) %>%
      mutate(unidad = "") %>%
      ggplot(aes(x = unidad, y = total_monto, fill = seleccion)) +
      geom_bar(stat = "identity", position = "fill") +
      scale_fill_manual(values = c("#2B7C8D", "#73CF56" )) +
      labs(x = "",
           y = "Porcentaje correspondiente del monto total",
           fill = "Selección de la cantidad
       de proveedores") +
      theme_classic()

  })
}


# Visualizaciones

## Hay 188 instituciones
## Hay 1928 proveedores

# ¿Cuáles instituciones con cuáles proveedores?
# ¿Cuántos son SA, SRL o física?
# ¿Cuáles instituciones compraron a cuáles proveedores?
# Podría ser elección de institución y que cuando se selecciones aparezcan
# Los mayores proveedores, los montos a cada uno, el tipo de tramite.

# Una pantalla general con resumenes generales como los que están en el EDA.
# Luego tabs con segementos como el explicado anteriormente

# Ministerio de Educación Pública

# datos <- adjudicaciones_colones %>%
#   filter(institucion == "CONSEJO NACIONAL DE CONCESIONES") %>%
#   group_by(proveedor_adjudicado) %>%
#   summarise(
#     total_contratos = n(),
#     total_monto = sum(monto_adjudicado)
#   )
# 
# datos %>%
#   arrange(desc(total_monto)) %>%
#   slice(1:10) %>%
#   ggplot(aes(x = proveedor_adjudicado, y = total_monto, fill = proveedor_adjudicado)) +
#   geom_bar(stat = "identity") +
#   scale_fill_viridis_d() +
#   labs(y = "Total monto adjudicado",
#        x = "Proveedores adjudicados") +
#   coord_flip() +
#   theme_bw(base_size = 14) +
#   theme(axis.text.x  = element_text(angle = 65, vjust = 0.5, size = 16)) +
#   theme(legend.position = "none")

# # Prueba para categorizar primeros proveedores
# datos <- adjudicaciones_colones %>%
#   filter(institucion == "CONSEJO NACIONAL DE CONCESIONES") %>%
#   group_by(proveedor_adjudicado) %>%
#   summarise(
#     total_contratos = n(),
#     total_monto = sum(monto_adjudicado)
#   )
# 
# # hacer mutate por monto mayor igual al ultimo seleccionado
# 
# b <- datos %>%
#   arrange(desc(total_monto)) %>%
#   slice(1:2)
# 
# valor <- min(b$total_monto)
# 
# datos %>%
#   mutate(seleccion = ifelse(total_monto >= valor, "Seleccionados", "Resto")) %>%
#   mutate(unidad = "") %>%
#   ggplot(aes(x = unidad, y = total_monto, fill = seleccion)) +
#   geom_bar(stat = "identity", position = "fill") +
#   scale_fill_manual(values = c("#2B7C8D", "#73CF56" )) +
#   labs(x = "",
#        y = "Porcentaje correspondiente del monto total",
#        fill = "Selección de la cantidad
#        de proveedores") +
#   theme_classic() 
#   theme(legend.position = "none") 
  
