# server shiny app

# import data
user_data <- readRDS("data/user_data.rds")

# initialize server
server <- function(input, output) {
	
	# Reactive expression for the data subsetted to what the user selected
	filteredData <- reactive({
		user_data[user_data$users >= input$range[1] & user_data$users <= input$range[2],]
	})

	# make color function	
	pal <- colorNumeric(
		palette = "RdGy",
		domain = user_data$users
		)

	output$map <- renderLeaflet({
		# Use leaflet() here, and only include aspects of the map that
		# won't need to change dynamically (at least, not unless the
		# entire map is being torn down and recreated).
		leaflet(user_data) %>% 
			# add basic map
			addTiles() %>%
			# set bounding box
			fitBounds(~min(longitude), ~min(latitude), ~max(longitude), ~max(latitude))
	})
	
	
	UsersInBounds <- reactive({
		if (is.null(input$map_bounds))
			return(user_data[FALSE,])
		bounds <- input$map_bounds
		latRng <- range(bounds$north, bounds$south)
		lngRng <- range(bounds$east, bounds$west)
		
		
		subset(user_data,
			latitude >= latRng[1] & latitude <= latRng[2] &
				longitude >= lngRng[1] & longitude <= lngRng[2])
	})
	
	# Precalculate the breaks we'll need for the two histograms
	#userBreaks <- hist(plot = FALSE, user_data$users, breaks = 20)$breaks
	
	output$histUsers <- renderPlot({
		# If no users are in view, don't plot
		if (nrow(UsersInBounds()) == 0)
			return(NULL)
		#if (nrow(UsersInBounds()) >= 1)
			#return(user_data$users)
		
		hist(UsersInBounds()$users,
				 breaks = 100,
				 main = "Number of locations with 
N amount of users",
				 xlab = "N",
				 xlim = range(UsersInBounds()$users),
				 col = 'grey',
				 border = 'black')
	})

?hist
	# Incremental changes to the map (in this case, replacing the
	# circles when a new color is chosen) should be performed in
	# an observer. Each independent set of things that can change
	# should be managed in its own observer.


	


	observe({
		
		
		leafletProxy("map", data = filteredData()) %>%
			clearShapes() %>%
			addCircles(radius = ~100000*(users/5), weight = 1, color = "#777777",
								 fillColor = ~pal(users), fillOpacity = 0.7, popup = ~paste("<b>Frequency: ",users,"</b></br>",
								 																													 "<i>",location,"</i></br></br>",
								 																													 ifelse(C!=0,sprintf("C: %s</br>",C),''),
								 																													 ifelse(Csharp!=0,sprintf("C#: %s</br>",Csharp),''),
								 																													 ifelse(Cplusplus!=0,sprintf("C++: %s</br>",Cplusplus),''),
								 																													 ifelse(Clojure!=0,sprintf("Clojure: %s</br>",Clojure),''),
								 																													 ifelse(CoffeeScript!=0,sprintf("CoffeeScript: %s</br>",CoffeeScript),''),
								 																													 ifelse(CSS!=0,sprintf("CSS: %s</br>",CSS),''),
								 																													 ifelse(D!=0,sprintf("D: %s</br>",D),''),
								 																													 ifelse(Dart!=0,sprintf("Dart: %s</br>",Dart),''),
								 																													 ifelse(Elixir!=0,sprintf("Elixir: %s</br>",Elixir),''),
								 																													 ifelse(EmacsLisp!=0,sprintf("Emacs Lisp: %s</br>",EmacsLisp),''),
								 																													 ifelse(Erlang!=0,sprintf("Erlang: %s</br>",Erlang),''),
								 																													 ifelse(Go!=0,sprintf("Go: %s</br>",Go),''),
								 																													 ifelse(Groovy!=0,sprintf("Groovy: %s</br>",Groovy),''),
								 																													 ifelse(Haskell!=0,sprintf("Haskell: %s</br>",Haskell),''),
								 																													 ifelse(HTML!=0,sprintf("HTML: %s</br>",HTML),''),
								 																													 ifelse(Java!=0,sprintf("Java: %s</br>",Java),''),
								 																													 ifelse(JavaScript!=0,sprintf("JavaScript: %s</br>",JavaScript),''),
								 																													 ifelse(Julia!=0,sprintf("Julia: %s</br>",Julia),''),
								 																													 ifelse(Lua!=0,sprintf("Lua: %s</br>",Lua),''),
								 																													 ifelse(Makefile!=0,sprintf("Makefile: %s</br>",Makefile),''),
								 																													 ifelse(MoonScript!=0,sprintf("MoonScript: %s</br>",MoonScript),''),
								 																													 ifelse(nan!=0,sprintf("nan: %s</br>",nan),''),
								 																													 ifelse(ObjectiveC!=0,sprintf("Objective-C: %s</br>",ObjectiveC),''),
								 																													 ifelse(ObjectiveCandRuby!=0,sprintf("Objective-C and Ruby: %s</br>",ObjectiveCandRuby),''),
								 																													 ifelse(Perl!=0,sprintf("Perl: %s</br>",Perl),''),
								 																													 ifelse(PHP!=0,sprintf("PHP: %s</br>",PHP),''),
								 																													 ifelse(PHPandHTML!=0,sprintf("PHP and HTML: %s</br>",PHPandHTML),''),
								 																													 ifelse(PowerShell!=0,sprintf("PowerShell: %s</br>",PowerShell),''),
								 																													 ifelse(Python!=0,sprintf("Python: %s</br>",Python),''),
								 																													 ifelse(PythonAndJavascript!=0,sprintf("Python and JavaScript: %s</br>",PythonAndJavascript),''),
								 																													 ifelse(R!=0,sprintf("R: %s</br>",R),''),
								 																													 ifelse(Ruby!=0,sprintf("Ruby: %s</br>",Ruby),''),
								 																													 ifelse(Rust!=0,sprintf("Rust: %s</br>",Rust),''),
								 																													 ifelse(Scala!=0,sprintf("Scala: %s</br>",Scala),''),
								 																													 ifelse(Shell!=0,sprintf("Shell: %s</br>",Shell),''),
								 																													 ifelse(TeX!=0,sprintf("TeX: %s</br>",TeX),''),
								 																													 ifelse(VimL!=0,sprintf("VimL: %s</br>",VimL),'')
								 ))
	})

	# Use a separate observer to recreate the legend as needed.
	observe({
		# ?leafletProxy: Creates a map-like object that can be used to customize and control a map that has already been rendered. For use in Shiny apps and Shiny docs only.
		proxy <- leafletProxy("map", data = user_data)
		# Remove any existing legend, and only if the legend is
		# enabled, create a new one.
		proxy %>% clearControls()
		if (input$legend) {
			proxy %>% addLegend(position = "topleft",
													pal = pal, values = ~users
			)
		}
	})
}