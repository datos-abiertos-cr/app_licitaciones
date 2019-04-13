# server

server <- function(input, output) {
  # Agrupaciones de datos necesarias para visualizaciones/resumenes
  
  output$instituciones_adjudicacion <- function(){
    adjudicaciones_colones %>% 
      group_by(institucion) %>% 
      summarise(
        total = n(),
        monto = sum(monto_adjudicado, na.rm = TRUE)
      ) %>% 
      arrange(desc(total)) %>% 
      mutate(monto = moneda(monto)) %>%
      slice(1:30) %>% 
      knitr::kable("html") %>%
      kable_styling(bootstrap_options = c("striped", "hover"))
  }
  output$adjudicaciones_colones <- renderPlot({
    ggplot(adjudicaciones_colones, aes(x = ano, y = monto_adjudicado, fill = tipo_tramite)) +
      geom_bar(stat = "identity") + 
      scale_fill_viridis_d() +
      xlab("Año") + ylab("Monto adjudicado") + 
      theme_bw(base_size = 16)
  })
  
  output$proveedores_slider <- renderUI({
    datos <- adjudicaciones_colones %>% 
      filter(institucion == input$institucion) %>% 
      group_by(proveedor_adjudicado) %>% 
      summarise(
        total_contratos = n()
      )
    sliderInput("proveedores_slider", "Cantidad de proveedores",
                min = 1,
                max = nrow(datos),
                value = 10)
  })
  
  output$instituciones <- renderPlot({
    datos <- adjudicaciones_colones %>% 
      filter(institucion == input$institucion) %>% 
      group_by(proveedor_adjudicado) %>% 
      summarise(
        total_contratos = n(),
        total_monto = sum(monto_adjudicado)
      )
    
    datos %>% 
      arrange(desc(total_monto)) %>% 
      slice(1:input$proveedores_slider) %>% 
      ggplot(aes(x = proveedor_adjudicado, y = total_monto, fill = proveedor_adjudicado)) + 
      geom_bar(stat = "identity") +
      scale_fill_viridis_d() +
      coord_flip() + 
      labs(y = "Total monto adjudicado",
           x = "Proveedores adjudicados") +
      theme(axis.text.y = element_text(angle = 90, vjust = 0.5, size = 16)) +
      theme_bw(base_size = 14) +
      theme(legend.position = "none")
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



 













