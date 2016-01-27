ui <- bootstrapPage(
	titlePanel(h1("GitHub top 1000")),
	titlePanel(h3("Geo-scripting WUR: end project")),
	titlePanel(h5("Erwin van den Berg, Joris Wever")),
	tags$style(type = "text/css", "html, body {width:100%;height:100%}"),
	leafletOutput("map", width = "100%", height = "100%"),
	absolutePanel(top = 10, right = 10,
								sliderInput("range", "GitHub users", min(user_data$users), max(user_data$users),
														value = range(user_data$users), step = 1
								),
								selectInput("colors", "Color Scheme",
														rownames(subset(brewer.pal.info, category %in% c("seq", "div")))
								),
								checkboxInput("legend", "Show legend", TRUE),
								plotOutput("histUsers", height = 200)
	)
)


# get data frame like the following example:
# head(quakes)



# sidebarLayout(position = "right",
# 							sidebarPanel(( "sidebar panel"),
# 													 h1("info about languages?")),
# 							mainPanel("")
# ),