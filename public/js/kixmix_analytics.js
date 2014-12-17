(function() {
  $(function() {
    var attendance, domain, firstPosition, liveCall, map, options, s, shake, total;
    firstPosition = new google.maps.LatLng(35.689635516196695, 139.692098200317);
    options = {
      zoom: 12,
      center: firstPosition,
      mapTypeId: google.maps.MapTypeId.ROADMAP,
      draggable: true
    };
    map = new google.maps.Map($("#map").get(0), options);
    domain = location.hostname;
    s = io.connect('http://' + domain + ':3000');
    s.on("connect", function() {
      return console.log("test");
    });
    s.on("disconnect", function(client) {});
    attendance = 0;
    s.on("toAnalytics", function(data) {
      var Circle, geocoder, latlng, userLocation;
      console.log(data.location);
      attendance++;
      $("#attendance").text(attendance + " 人");
      userLocation = new google.maps.LatLng(data.location.lat, data.location.lon);
      Circle = new google.maps.Circle({
        center: userLocation,
        fillColor: "#ffac64",
        fillOpacity: 0.35,
        map: map,
        radius: 1000,
        strokeColor: "#ff7300",
        strokeOpacity: 0.8,
        strokeWeight: 2
      });
      geocoder = new google.maps.Geocoder();
      latlng = new google.maps.LatLng(data.location.lat, data.location.lon);
      return geocoder.geocode({
        'latLng': latlng
      }, function(results, status) {
        if (status === google.maps.GeocoderStatus.OK) {
          return console.log(results[0].address_components[5].long_name);
        } else {
          return alert("Geocoder failed due to: " + status);
        }
      });
    });
    s.on("toClient", function(data) {
      return console.log(data);
    });
    s.on("isLogout", function(data) {
      attendance--;
      return $("#attendance").text(attendance + " 人");
    });
    liveCall = 0;
    total = 0;
    shake = 0;
    s.on("toCallLive", function(data) {
      liveCall++;
      total++;
      $("#total").text(total + " 回");
      return $("#liveCall").text(liveCall + " 回");
    });
    s.on("toClient", function(data) {
      total++;
      shake++;
      $("#total").text(total + " 回");
      return $("#shake").text(shake + " 回");
    });
    return s.on("toLevel", function(data) {
      return $("#liveHeatLevel").text("レベル " + data.level);
    });
  });

}).call(this);
