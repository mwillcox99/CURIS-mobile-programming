// Generated by CoffeeScript 1.9.3

/*
Must divide logic among blocks
Divide so I can get location with anything

Notes: my location will always go first, no matter what
 */

/*
triggers is a JS object broken up like the following:
first: the first condition given
operator: the type of operator
second: second condition given

actions is an array of the action indicators
 */
var IS_IN, IS_NOT_IN, MY_AREA, MY_LOCATION, WEATHER, audio, checkIfContains, count, doIFTTT, getRectangleCoords, loadWeather, myLat, myLng, myLocation, polygonArea;

IS_IN = 0;

IS_NOT_IN = 1;

MY_AREA = 0;

MY_LOCATION = 1;

WEATHER = 2;


/*
operators: and operator ID
is in: 
is not in:
 */

polygonArea = null;

myLat = null;

myLng = null;


/*
This will run with given parameters
 */

doIFTTT = function(triggers, actions) {
  var action, firstBlock, interval, operator, promise, secondBlock;
  firstBlock = triggers.firstBlock;
  operator = triggers.operator;
  secondBlock = triggers.secondBlock;
  action = actions;
  if ((firstBlock === MY_LOCATION && secondBlock === MY_AREA) || (firstBlock === MY_AREA && secondBlock === MY_LOCATION)) {
    checkIfContains();
    return interval = setInterval(checkIfContains, 7000);
  } else if (firstBlock === secondBlock) {
    return audio.play();
  } else if ((firstBlock === MY_LOCATION && secondBlock === WEATHER) || (firstBlock === WEATHER && secondBlock === MY_LOCATION)) {
    promise = myLocation();
    return promise.done(function() {
      return loadWeather(myLat + "," + myLng);
    });
  } else {
    return console.log("An error ocurred unfortunately");
  }
};

myLocation = function() {
  var defObject;
  defObject = $.Deferred();
  navigator.geolocation.getCurrentPosition(function(position) {
    myLat = position.coords.latitude;
    myLng = position.coords.longitude;
    console.log("Latitude: " + position.coords.latitude);
    console.log("Longitude: " + position.coords.longitude);
    defObject.resolve();
  });
  return defObject.promise();
};

getRectangleCoords = function(bounds) {
  var northEast, northEastLat, northEastLng, northWestLat, northWestLng, southEastLat, southEastLng, southWest, southWestLat, southWestLng;
  northEast = bounds.getNorthEast();
  southWest = bounds.getSouthWest();
  southWestLat = southWest.lat();
  southWestLng = southWest.lng();
  northEastLat = northEast.lat();
  northEastLng = northEast.lng();
  southEastLat = northEast.lat();
  southEastLng = southWest.lng();
  northWestLng = northEast.lng();
  northWestLat = southWest.lat();
  return [new google.maps.LatLng(southWestLat, southWestLng), new google.maps.LatLng(northWestLat, northWestLng), new google.maps.LatLng(northEastLat, northEastLng), new google.maps.LatLng(southEastLat, southEastLng)];
};

audio = null;

google.maps.event.addDomListener(window, 'load', function() {
  var promise;
  promise = myLocation();
  return promise.done(function() {
    var map, mapProp;
    mapProp = {
      center: new google.maps.LatLng(myLat, myLng),
      zoom: 17,
      mapTypeId: google.maps.MapTypeId.ROADMAP,
      disableDefaultUI: true,
      minZoom: 17,
      maxZoom: 17
    };
    map = new google.maps.Map(document.getElementById("googleMap"), mapProp);
    return google.maps.event.addListener(map, 'click', function(event) {
      var bounds, marker, obj, rectangle;
      obj = {
        position: event.latLng,
        map: map
      };
      marker = new google.maps.Marker(obj);
      console.log(map.getBounds().getSouthWest().lat());
      console.log(event.latLng.lat());
      bounds = map.getBounds();
      rectangle = getRectangleCoords(bounds);
      polygonArea = new google.maps.Polygon({
        paths: rectangle,
        strokeColor: '#FF0000',
        strokeOpacity: 0.8,
        strokeWeight: 3,
        fillColor: '#FF0000',
        fillOpacity: 0.35
      });
      return polygonArea.setMap(map);
    });
  });
});

count = 0;

checkIfContains = function() {
  var myLoc;
  count++;
  if (polygonArea === null) {
    $("#message").text("You didn't enter anything ding dong");
    return;
  }
  myLoc = myLocation();
  return myLoc.done(function() {
    var myLatLng;
    myLatLng = new google.maps.LatLng(myLat, myLng);
    if (google.maps.geometry.poly.containsLocation(myLatLng, polygonArea) === true) {
      $("#message").text("You re in " + count + "!");
      audio.play();
      return true;
    } else {
      $("#message").text("You are not in " + count);
      return false;
    }
  });
};

loadWeather = function(location) {
  return $.simpleWeather({
    location: location,
    unit: 'f',
    success: function(weather) {
      $("#message").text("Weather: " + weather.title);
      $("#temperature").text("Temperature: " + weather.temp + " " + weather.units.temp);
      $("#raining").text("" + weather.humidity);
    },
    error: function(error) {
      $("#message").text("Error");
    }
  });
};

$("#run").click(function() {
  var result;
  audio = new Audio("Ding.mp3");
  audio.play();
  audio.pause();
  return result = doIFTTT({
    firstBlock: MY_LOCATION,
    operator: IS_IN,
    secondBlock: WEATHER
  });
});
