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

#シェープファイル
sf <- sf::read_sf("data/shp/h27ka13_city.shp")
sf <- sf::st_transform(sf, crs = 4326)

#東京都新型コロナウイルス感染症対策サイト
df <- readr::read_csv("data/csv/130001_tokyo_covid19_positive_cases_by_municipality.csv")
df <- df %>%
  dplyr::rename(cityCode = '全国地方公共団体コード') %>%
  dplyr::mutate(cityCode = floor(cityCode/10)) %>%
  dplyr::rename(prefName = '都道府県名') %>%
  dplyr::rename(muniName = '市区町村名') %>%
  dplyr::mutate(cityName = paste0(prefName, muniName)) %>%
  dplyr::rename(date = '公表_年月日') %>%
  dplyr::rename(classification = '集計区分') %>%
  dplyr::rename(cumCovidPositive = '陽性者数')

## SET MAPBOX API
#Mapbox API--------------------------------------------
#Variables are defined on .Renviron``
styleUrl <- Sys.getenv("MAPBOX_STYLE")
accessToken <- Sys.getenv("MAPBOX_ACCESS_TOKEN")
#Mapbox API--------------------------------------------
