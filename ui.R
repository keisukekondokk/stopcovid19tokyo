# 
# (C) Keisuke Kondo
# Release Date: 2020-06-26
# Update Date: 2021-01-22
# 
# - global.R
# - ui.R
# - server.R
# 



dashboardPage(
  #++++++++++++++++++++++++++++++++++++++
  dashboardHeader(
    title = "東京都新型コロナウイルスマップ",
    titleWidth = 380,
    tags$li(
      actionLink(
        "github",
        label = "",
        icon = icon("github"),
        href = "https://github.com/keisukekondokk/stopcovid19tokyo",
        onclick = "window.open('https://github.com/keisukekondokk/stopcovid19tokyo', '_blank')"
      ),
      class = "dropdown"
    )
  ),
  #++++++++++++++++++++++++++++++++++++++
  #Sidebar
  dashboardSidebar(width = 380,
                   sidebarMenu(
                     menuItem("陽性患者数（累計）",
                              tabName = "tab_covid19map1",
                              icon = icon("map")),
                     menuItem(
                       "居住者人口10万人あたりの陽性患者数（累計）",
                       tabName = "tab_covid19map2",
                       icon = icon("map")
                     ),
                     menuItem(
                       "はじめに読んでください",
                       tabName = "info",
                       icon = icon("info-circle")
                     )
                   )
  ),
  #++++++++++++++++++++++++++++++++++++++
  #Body
  dashboardBody(
    tags$style(type = "text/css", "html, body {margin: 0; width: 100%; height: 100%;}"),
    tags$style(type = "text/css", "h2 {margin-top: 20px;}"),
    tags$style(type = "text/css", "h3 {margin-top: 20px; border-bottom: solid 1px black;}"),
    tags$style(type = "text/css", "h4 {margin-top: 20px;}"),
    tags$style(
      type = "text/css",
      "#panel_map {padding: 5px; background-color: #FFFFFF; opacity: 0.9;}"
    ),
    tags$style(
      type = "text/css",
      "#covid19map1, #covid19map2 {margin: 0; height: calc(100vh - 50px) !important;}"
    ),
    tabItems(
      #++++++++++++++++++++++++++++++++++++++
      tabItem(tabName = "tab_covid19map1",
              fluidRow(
                style = "margin-top: -20px; margin-bottom: -20px;",
                absolutePanel(
                  id = "panel_map",
                  class = "panel panel-default",
                  top = "auto",
                  bottom = "20",
                  left = "auto",
                  right = "auto",
                  width = 160,
                  height = "auto",
                  style = "z-index:10;",
                  dateInput(
                    inputId = "dateMap1",
                    label = h4(span(icon("calendar"), "Select Date:")),
                    value = "2022-09-26",
                    min = "2020-03-31",
                    max = "2022-09-26",
                  )
                ),
                leafletOutput("covid19map1") %>%
                  withSpinner(color = getOption("spinner.color", default = "#3C8EBC"))
              )
      ),
      #++++++++++++++++++++++++++++++++++++++
      tabItem(tabName = "tab_covid19map2",
              fluidRow(
                style = "margin-top: -20px; margin-bottom: -20px;",
                absolutePanel(
                  id = "panel_map",
                  class = "panel panel-default",
                  top = "auto",
                  bottom = "20",
                  left = "auto",
                  right = "auto",
                  width = 160,
                  height = "auto",
                  style = "z-index:10;",
                  dateInput(
                    inputId = "dateMap2",
                    label = h4(span(icon("calendar"), "Select Date:")),
                    value = "2022-09-26",
                    min = "2020-03-31",
                    max = "2022-09-26",
                  )
                ),
                leafletOutput("covid19map2") %>%
                  withSpinner(color = getOption("spinner.color", default = "#3C8EBC"))
              )
      ),
      #++++++++++++++++++++++++++++++++++++++
      tabItem(tabName = "info",
          fluidRow(
            column(
              width = 12,
              box(
                width = NULL,
                title = h2(span(icon("info-circle"), "はじめに読んでください")),
                solidHeader = TRUE,
                p("2021年1月22日改定", align = "right"),
                p("2020年6月27日公開", align = "right"),
                h3(span(icon("pencil-square"), "本サイトの説明")),
                p(
                  "東京都区市町村別の新型コロナウイルス陽性患者数（累計）および居住者人口10万人あたりの新型コロナウイルス陽性患者数（累計）の最新のデータを取得し地図上に可視化しています。なお区市町村別の居住者人口は2015年国勢調査（総務省）のデータに基づいています。"
                ),
                h3(span(icon("user-circle"), "作成者")),
                p("独立行政法人経済産業研究所、上席研究員、近藤恵介"),
                h3(span(icon("envelope-open"), "連絡先")),
                p("Email: kondo-keisuke@rieti.go.jp"),
                h3(span(icon("file-text"), "利用規約")),
                p(
                  "当サイトで公開している情報（以下「コンテンツ」）は、どなたでも自由に利用できます。コンテンツ利用に当たっては、本利用規約に同意したものとみなします。本利用規約の内容は、必要に応じて事前の予告なしに変更されることがありますので、必ず最新の利用規約の内容をご確認ください。"
                ),
                h4("著作権"),
                p("本コンテンツの著作権は、近藤恵介に帰属します。"),
                h4("第三者の権利"),
                p(
                  "本コンテンツは、「東京都新型コロナウイルス感染症対策サイト」および、「e-Stat 政府統計の総合窓口」の情報に基づいて作成しています。本コンテンツを利用する際は、第三者の権利を侵害しないようにしてください。"
                ),
                h4("免責事項"),
                p(
                  "(a) 作成にあたり細心の注意を払っていますが、本サイトの内容の完全性・正確性・有用性等についていかなる保証を行うものでありません。"
                ),
                p(
                  "(b) 本サイトを利用したことによるすべての障害・損害・不具合等、作成者および作成者の所属するいかなる団体・組織とも、一切の責任を負いません。"
                ),
                p("(c) 本サイトは、事前の予告なく変更、移転、削除等が行われることがあります。"),
                h3(span(icon("database"), "データ出所")),
                h4("東京都新型コロナウイルス感染症対策サイト"),
                p(
                  "URL: ",
                  a(
                    href = "https://stopcovid19.metro.tokyo.lg.jp/",
                    "https://stopcovid19.metro.tokyo.lg.jp/",
                    .noWS = "outside"
                  ),
                  .noWS = c("after-begin", "before-end")
                ),
                p("上記サイトの「その他参考指標」より、「陽性患者数（区市町村別）」のデータを使用。"),
                h4("e-Stat 政府統計の総合窓口"),
                p(
                  "URL: ",
                  a(
                    href = "https://www.e-stat.go.jp/",
                    "https://www.e-stat.go.jp/",
                    .noWS = "outside"
                  ),
                  .noWS = c("after-begin", "before-end")
                ),
                p(
                  "上記サイトより、2015年国勢調査の小地域の境界データより、東京都全域のシェープファイルを使用。作成者によって区市町村別に境界データを加工。"
                )
              )
            )
          )
      )
    )
  )
)
