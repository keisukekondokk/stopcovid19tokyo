# 
# (C) Keisuke Kondo
# Release Date: 2020-06-26
# Update Date: 2021-01-22
# 
# - global.R
# - ui.R
# - server.R
# 


#==============================================================================
#Global Environment

#Packages
library(shiny)
library(shinydashboard)
library(shinycssloaders)
library(leaflet)
library(leaflet.minicharts)
library(leaflet.mapboxgl)
library(sf)
library(tidyverse)
library(jsonlite)

#シェープファイル
sf <- sf::read_sf("data/shp/h27ka13_city.shp")
sf <- sf::st_transform(sf, crs = 4326)

#東京都新型コロナウイルス感染症対策サイト
urlCoivd <- "https://raw.githubusercontent.com/tokyo-metropolitan-gov/covid19/development/data/patient.json"
listTableCovid <- jsonlite::fromJSON(urlCoivd)
dfTemp <- listTableCovid$datasets$data

#データ更新日を取得
strTemp <- lubridate::ymd(listTableCovid$datasets$date)
strPublishedDate <- paste0(format(strTemp, "%Y年%m月%d日"), "時点")

#データフレームを加工
dfCovid <- dfTemp %>%
  dplyr::filter(!is.na(code)) %>%
  dplyr::rename(cityCode = code) %>%
  dplyr::mutate(cityCode = floor(cityCode/10)) %>%
  dplyr::rename(cityName = label) %>%
  dplyr::rename(cumCovidPositive = count) %>%
  dplyr::mutate(date = strPublishedDate) %>%
  dplyr::select(date, cityCode, cityName, cumCovidPositive)

#最終データフレームを作成
sf <- sf %>%
  dplyr::left_join(dfCovid, by = "cityCode") %>%
  dplyr::mutate(cumCovidPositivePerPop = cumCovidPositive / JINKO * 100000)

## SET MAPBOX API
#Mapbox API--------------------------------------------
#Variables are defined on .Renviron``
styleUrl <- Sys.getenv("MAPBOX_STYLE")
accessToken <- Sys.getenv("MAPBOX_ACCESS_TOKEN")
#Mapbox API--------------------------------------------
