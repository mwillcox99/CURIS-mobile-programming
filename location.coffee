###
Must divide logic among blocks
Divide so I can get location with anything

Notes: my location will always go first, no matter what
###

###
triggers is a JS object broken up like the following:
first: the first condition given
operator: the type of operator
second: second condition given

actions is an array of the action indicators
###
IS_IN = 0
IS_NOT_IN = 1

MY_AREA = 0
MY_LOCATION = 1
WEATHER = 2
###
operators: and operator ID
is in: 
is not in:

###
#Any potential globals that need to be passed
polygonArea = null
myLat = null
myLng = null

###
This will run with given parameters
###
doIFTTT = (triggers, actions) ->
	firstBlock = triggers.firstBlock
	operator = triggers.operator
	secondBlock = triggers.secondBlock
	action = actions

	if (firstBlock is MY_LOCATION and secondBlock is MY_AREA) or 
	(firstBlock is MY_AREA and secondBlock is MY_LOCATION)
		#return checkIfContains() if operator is IS_IN
		#return not checkIfContains()
		checkIfContains()
		interval = setInterval checkIfContains,7000

	else if firstBlock is secondBlock
		#return true if operator is IS_IN
		#return false
		audio.play()
	else if (firstBlock is MY_LOCATION and secondBlock is WEATHER) or
	(firstBlock is WEATHER and secondBlock is MY_LOCATION)
		#CALL ON WEATHER WITH MY LOCATION
		promise = myLocation()
		promise.done ->
			loadWeather "#{myLat},#{myLng}"
	else console.log "An error ocurred unfortunately"
	


myLocation = ->
	defObject = $.Deferred()
	navigator.geolocation.getCurrentPosition (position) ->
		myLat = position.coords.latitude
		myLng = position.coords.longitude
		console.log "Latitude: #{position.coords.latitude}"
		console.log "Longitude: #{position.coords.longitude}"
		defObject.resolve()
		return
	defObject.promise()


getRectangleCoords = (bounds) ->
	northEast = bounds.getNorthEast()
	southWest = bounds.getSouthWest()
	southWestLat = southWest.lat()
	southWestLng = southWest.lng()
	northEastLat = northEast.lat()
	northEastLng = northEast.lng()
	southEastLat = northEast.lat()
	southEastLng = southWest.lng()
	northWestLng = northEast.lng()
	northWestLat = southWest.lat()
	[
		new google.maps.LatLng(southWestLat, southWestLng)
		new google.maps.LatLng(northWestLat, northWestLng)
		new google.maps.LatLng(northEastLat, northEastLng)
		new google.maps.LatLng(southEastLat, southEastLng)
	]

audio = null
#TODO only put one marker at a time
google.maps.event.addDomListener window,'load',->
	promise = myLocation()
	promise.done ->

		mapProp =
			center: new google.maps.LatLng(myLat,myLng)
			zoom: 17
			mapTypeId: google.maps.MapTypeId.ROADMAP
			disableDefaultUI: true
			minZoom: 17
			maxZoom: 17
		map = new google.maps.Map document.getElementById("googleMap"),mapProp

		google.maps.event.addListener map,'click',(event)->
			obj = 
				position: event.latLng
				map: map
			marker = new google.maps.Marker obj
			console.log map.getBounds().getSouthWest().lat()
			console.log event.latLng.lat()
			bounds = map.getBounds()
			rectangle = getRectangleCoords(bounds)
			polygonArea = new google.maps.Polygon
				paths: rectangle
				strokeColor: '#FF0000'
				strokeOpacity: 0.8
				strokeWeight: 3
				fillColor: '#FF0000'
				fillOpacity: 0.35
			polygonArea.setMap map


count = 0

checkIfContains = ->
	count++
	if polygonArea is null 
		$("#message").text "You didn't enter anything ding dong"
		return 
	myLoc = myLocation()
	myLoc.done -> 
		myLatLng = new google.maps.LatLng(myLat, myLng)
		if google.maps.geometry.poly.containsLocation(myLatLng, polygonArea) is true
			$("#message").text "You re in #{count}!"
			audio.play()
			return true
		else
			$("#message").text "You are not in #{count}"
			return false

#Loads the weather
loadWeather = (location)->
	$.simpleWeather
		location: location 
		unit: 'f'
		success: (weather) ->
			$("#message").text "Weather: #{weather.title}"
			$("#temperature").text "Temperature: #{weather.temp} #{weather.units.temp}"
			$("#raining").text "#{weather.humidity}"
			return
		error: (error) ->
			$("#message").text "Error"
			return

#This is when the user runs
$("#run").click ->
	audio = new Audio "Ding.mp3"
	audio.play()
	audio.pause()

	result = doIFTTT
		firstBlock: MY_LOCATION
		operator: IS_IN
		secondBlock: MY_WEATHER
	 #put in parameters

	#if result then audio.play()
