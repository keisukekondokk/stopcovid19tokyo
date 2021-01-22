# 
# (C) Keisuke Kondo
# Release Date: 2020-06-26
# Update Date: 2021-01-22
# 
# - global.R
# - ui.R
# - server.R
# 


server <- function(input, output) {
  #covid19map
  output$covid19map1 <- renderLeaflet({
    #Color
    pal <-
      colorBin("Blues",
               domain = sf$cumCovidPositive,
               bins = 7)
    
    #Make Map
    leaflet(sf) %>%
      #Tile Layer
      addMapboxGL(accessToken = accessToken,
                  style = styleUrl,
                  setView = FALSE) %>%
      #Polygon Layer
      addPolygons(
        fillColor = ~ pal(cumCovidPositive),
        fillOpacity = 0.7,
        stroke = TRUE,
        weight = 0.8,
        color = "black",
        layerId = ~ cityCode,
        label = ~ cityName,
        labelOptions = labelOptions(
          style = list("font-weight" = "normal", padding = "3px 8px"),
          textsize = "15px",
          direction = "auto"
        )
      ) %>%
      #Legend
      addLegend(
        pal = pal,
        values = ~ cumCovidPositive,
        opacity = 0.8,
        title = paste("陽性患者数（累計）", strPublishedDate, sep = "<br>"),
        position = "topright"
      ) %>%
      #Minicharts Layer
      addMinicharts(
        lng = sf$lon,
        lat = sf$lat,
        chartdata = round(sf$cumCovidPositive),
        showLabels = TRUE,
        labelMinSize = 4,
        labelMaxSize = 32,
        width = 36,
        popup = popupArgs(labels = paste("陽性患者数（累計）"))
      )
  })
  #covid19map
  output$covid19map2 <- renderLeaflet({
    #Color
    pal <-
      colorBin("Blues",
               domain = sf$cumCovidPositivePerPop,
               bins = 7)
    
    #Make Map
    leaflet(sf) %>%
      #Tile Layer
      addMapboxGL(accessToken = accessToken,
                  style = styleUrl,
                  setView = FALSE) %>%
      #Polygon Layer
      addPolygons(
        fillColor = ~ pal(cumCovidPositivePerPop),
        fillOpacity = 0.7,
        stroke = TRUE,
        weight = 0.8,
        color = "black",
        layerId = ~ cityCode,
        label = ~ cityName,
        labelOptions = labelOptions(
          style = list("font-weight" = "normal", padding = "3px 8px"),
          textsize = "15px",
          direction = "auto"
        )
      ) %>%
      #Legend
      addLegend(
        pal = pal,
        values = ~ cumCovidPositivePerPop,
        opacity = 0.8,
        title = paste("居住者人口10万人あたりの", "陽性患者数（累計）", strPublishedDate, sep = "<br>"),
        position = "topright"
      ) %>%
      #Minicharts Layer
      addMinicharts(
        lng = sf$lon,
        lat = sf$lat,
        chartdata = round(sf$cumCovidPositivePerPop),
        showLabels = TRUE,
        labelMinSize = 4,
        labelMaxSize = 32,
        width = 36,
        popup = popupArgs(labels = paste("居住者人口10万人あたりの", "　陽性患者数（累計）　", sep = "<br>"))
      )
  })
}
