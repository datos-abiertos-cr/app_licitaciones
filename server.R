# server

server <- function(input, output) {
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
}