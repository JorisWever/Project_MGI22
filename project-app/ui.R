# User interface shiny

ui <- bootstrapPage(
	titlePanel(h1("GitHub top 1000 contributors in 2014-2015")),
	titlePanel(h3("Geo-scripting WUR")),
	titlePanel(h5("Erwin van den Berg, Joris Wever")),
	tags$style(type = "text/css", "html, body {width:100%;height:100%}"),
	leafletOutput("map", width = "100%", height = "100%"),
	absolutePanel(top = 10, right = 10,
								sliderInput("range", "GitHub users", min(user_data$users), max(user_data$users),
														value = range(user_data$users), step = 1
								),
								checkboxInput("legend", "Show legend", TRUE
								),
								br(
								),				
								plotOutput("histUsers", height = 600, width = 400)
	)
)
