$ ->

  firstPosition = new google.maps.LatLng(35.689635516196695, 139.692098200317)

  options =
    # ズームを表示
    zoom:12
    # 地図の中心地の設定
    center:firstPosition
    # マップの表示方法の設定
    mapTypeId:google.maps.MapTypeId.ROADMAP
    # ドラッグできるようにする
    draggable:true

  map = new google.maps.Map($("#map").get(0), options);

  # node socket.io
  domain = location.hostname

  s = io.connect 'http://' + domain + ':3000'

  s.on "connect", -> # 接続時

  s.on "disconnect", (client) -> # 切断時


  attendance = 0
  s.on "toAnalytics", (data) ->
    console.log data.location
    attendance++
    $("#attendance").text(attendance+" 人")
    userLocation = new google.maps.LatLng(data.location.lat,data.location.lon)
    Circle = new google.maps.Circle(
      center: userLocation    #中心座標
      fillColor: "#ffac64"    #塗りつぶしの色
      fillOpacity: 0.35       #塗りつぶしの不透明度
      map: map                #円を表示する地図
      radius: 1000            #地表面上の半径（メートル単位）
      strokeColor: "#ff7300"  #外周線の色
      strokeOpacity: 0.8      #外周線の不透明度
      strokeWeight: 2         #外周線幅（ピクセル単位）
    )

    geocoder = new google.maps.Geocoder()
    latlng = new google.maps.LatLng(data.location.lat, data.location.lon)
    geocoder.geocode
      'latLng': latlng,
      (results, status) ->
        if status is google.maps.GeocoderStatus.OK
          console.log results[0].address_components[5].long_name
        else
          alert("Geocoder failed due to: " + status);

  s.on "toClient", (data) ->
    console.log data

  s.on "isLogout", (data) ->
    attendance--
    $("#attendance").text(attendance+" 人")

  liveCall = 0
  total = 0
  shake = 0
  s.on "toCallLive", (data) ->
    liveCall++
    total++
    $("#total").text(total + " 回")
    $("#liveCall").text(liveCall + " 回")

  s.on "toClient", (data) ->
    total++
    shake++
    $("#total").text(total + " 回")
    $("#shake").text(shake + " 回")

  s.on "toLevel", (data) ->
    $("#liveHeatLevel").text("レベル " + data.level)
