# 
# (C) Keisuke Kondo
# Release Date: 2020-06-26
# Update Date: 2023-11-10
# 
# - global.R
# - ui.R
# - server.R
# 


server <- function(input, output, session) {
  
  #==============================================
  #日付1の変更を日付2へ反映
  observeEvent(input$dateMap1, {
    dateMap <- input$dateMap1
    updateDateInput(
      session,
      inputId = "dateMap2",
      value = dateMap,
    )
  })
  
  #==============================================
  #日付2の変更を日付1へ反映
  observeEvent(input$dateMap2, {
    dateMap <- input$dateMap2
    updateDateInput(
      session,
      inputId = "dateMap1",
      value = dateMap,
    )
  })
  
  #==============================================
  #日付1/2の変更があれば地図更新
  observeEvent(input$dateMap1, {
    #データ日
    strDate <- input$dateMap1
    strPublishedDate <- paste0(format(strDate, "%Y年%m月%d日"), "時点")
    
    #データフレームを加工
    dfCovid <- df %>%
      dplyr::filter(!is.na(cityCode)) %>%
      dplyr::filter(date == strDate) %>%
      dplyr::select(date, cityCode, cityName, cumCovidPositive)
    
    #最終データフレームを作成
    sf <- sf %>%
      dplyr::left_join(dfCovid, by = "cityCode") %>%
      dplyr::mutate(cumCovidPositivePerPop = cumCovidPositive / JINKO * 100000)
    
    #Leaflet Basemap
    lf <- leaflet() %>%
      addMapboxGL(
        accessToken = accessToken,
        style = styleUrl,
        setView = FALSE
      )
      
    #++++++++++++++++++++++++++++++++++++++
    #covid19map1
    output$covid19map1 <- renderLeaflet({

      #Color
      pal1 <- colorBin("Blues", domain = sf$cumCovidPositive, bins = 7)

      #Make Map
      lf %>%
        #Polygon Layer
        addPolygons(
          data = sf,
          fillColor = ~ pal1(cumCovidPositive),
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
          ),
          popup = paste(
            "<b>市区町村コード: </b>",
            sf$cityCode,
            "<br>",
            "<b>市区町村名: </b>",
            sf$cityName,
            "<br>",
            "<b>陽性患者数（累計）: </b>",
            round(sf$cumCovidPositivePerPop),
            "<br>"
          )
        ) %>%
        #Legend
        addLegend(
          pal = pal1,
          values = sf$cumCovidPositive,
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
    
    #++++++++++++++++++++++++++++++++++++++
    #covid19map2
    output$covid19map2 <- renderLeaflet({
      
      #Color
      pal2 <- colorBin("Blues", domain = sf$cumCovidPositivePerPop, bins = 7)
      
      #Make Map
      lf %>%
        #Polygon Layer
        addPolygons(
          data = sf,
          fillColor = ~ pal2(cumCovidPositivePerPop),
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
          ),
          popup = paste(
            "<b>市区町村コード: </b>",
            sf$cityCode,
            "<br>",
            "<b>市区町村名: </b>",
            sf$cityName,
            "<br>",
            "<b>居住者人口10万人あたりの陽性患者数（累計）:</b> ",
            round(sf$cumCovidPositivePerPop),
            "<br>"
          ),
        ) %>%
        #Legend
        addLegend(
          pal = pal2,
          values = sf$cumCovidPositivePerPop,
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
  }, ignoreNULL = FALSE)
}
