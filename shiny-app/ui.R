## Geo-scripting WUR
## January 2016
## Joris Wever, Erwin van den Berg
## Group: MGI 22

## User Interface Shiny Application

# Construct User Interface
ui <- bootstrapPage(
	# Add titles
	titlePanel(h1("GitHub top 1000 contributors in 2014-2015")),
	titlePanel(h3("Geo-scripting WUR")),
	titlePanel(h5("Erwin van den Berg, Joris Wever")),
	tags$style(type = "text/css", "html, body {width:100%;height:100%}"),
	# Add map
	leafletOutput("map", width = "100%", height = "100%"),
	# Add panel where users..
	absolutePanel(top = 10, right = 10,
								# .. selects locations by specifying certain number of users
								sliderInput("range", "GitHub users", min(user_data$users), max(user_data$users),
														value = range(user_data$users), step = 1
								),
								# .. checks or unchecks the legend
								checkboxInput("legend", "Show legend", TRUE
								),
								br(
								),
								br(
								),
								# Add histogram to sidepanel
								plotOutput("histUsers", height = 600, width = 400)
	)
)
