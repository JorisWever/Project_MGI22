library(shiny)
library(leaflet)
library(RColorBrewer)
user_data <- readRDS("data/user_data.rds")

server <- function(input, output, session) {
	# Reactive expression for the data subsetted to what the user selected
	filteredData <- reactive({
		user_data[user_data$users >= input$range[1] & user_data$users <= input$range[2],]
	})

	# This reactive expression represents the palette function,
	# which changes as the user makes selections in UI.
	
	colorpal <- reactive({
		colorNumeric(input$colors, user_data$users)
	})

	output$map <- renderLeaflet({
		# Use leaflet() here, and only include aspects of the map that
		# won't need to change dynamically (at least, not unless the
		# entire map is being torn down and recreated).
		leaflet(user_data) %>% addTiles() %>%
			fitBounds(~min(lon), ~min(lat), ~max(lon), ~max(lat))
	})
	
	zipsInBounds <- reactive({
		if (is.null(input$map_bounds))
			return(user_data[FALSE,])
		bounds <- input$map_bounds
		latRng <- range(bounds$north, bounds$south)
		lngRng <- range(bounds$east, bounds$west)
		
		
		subset(user_data,
			lat >= latRng[1] & lat <= latRng[2] &
				lon >= lngRng[1] & lon <= lngRng[2])
	})
	
	# Precalculate the breaks we'll need for the two histograms
	userBreaks <- hist(plot = FALSE, user_data$users, breaks = 20)$breaks
	
	output$histUsers <- renderPlot({
		# If no zipcodes are in view, don't plot
		if (nrow(zipsInBounds()) == 0)
			return(NULL)
		
		hist(zipsInBounds()$users,
				 breaks = userBreaks,
				 main = "Number of locations where 
GitHub top 1000 users live",
				 xlab = "Users",
				 xlim = range(user_data$users),
				 col = '#00DD00',
				 border = 'white')
	})

	# Incremental changes to the map (in this case, replacing the
	# circles when a new color is chosen) should be performed in
	# an observer. Each independent set of things that can change
	# should be managed in its own observer.
	
	
	
	observe({
		pal <- colorpal()

		leafletProxy("map", data = filteredData()) %>%
			clearShapes() %>%
			addCircles(radius = ~100000*(users/5), weight = 1, color = "#777777",
								 fillColor = ~pal(users), fillOpacity = 0.7, popup = ~paste("Number of users:", users, "<br>", users))

	})

	# Use a separate observer to recreate the legend as needed.
	observe({
		proxy <- leafletProxy("map", data = user_data)

		# Remove any existing legend, and only if the legend is
		# enabled, create a new one.
		proxy %>% clearControls()
		if (input$legend) {
			pal <- colorpal()
			proxy %>% addLegend(position = "bottomright",
													pal = pal, values = ~users
			)
		}
	})
}