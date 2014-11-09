$ ->
  # Device Motion
  window.addEventListener "devicemotion", ((evt) ->

    #加速度
    x = evt.acceleration.x
    y = evt.acceleration.y
    z = evt.acceleration.z

    #傾き
    xg = evt.accelerationIncludingGravity.x
    yg = evt.accelerationIncludingGravity.y
    zg = evt.accelerationIncludingGravity.z

    #回転値
    # z方向
    a = evt.rotationRate.alpha
    # x方向
    b = evt.rotationRate.beta
    # y方向
    g = evt.rotationRate.gamma


    $("#data1 span.num").text(g.toFixed(3))
    $("#data2 span.num").text(b.toFixed(3))
    $("#data3 span.num").text(a.toFixed(3))
    $("#data4 span.num").text(zg.toFixed(3))
    $("#data5 span.num").text(yg.toFixed(3))
    $("#data6 span.num").text(xg.toFixed(3))
    $("#data7 span.num").text(z.toFixed(3))
    $("#data8 span.num").text(y.toFixed(3))
    $("#data9 span.num").text(x.toFixed(3))


    bgColor = $("#wrapper").data("color")
    $("#data11 span.color").text(bgColor)

    # Flash Function
    if Math.abs(xg) >= 8 or Math.abs(yg) <= 5
      $("#data12 span.flash").text("start")
      $("#wrapper").fadeOut 100, ->
        $(this).fadeIn 100
        return
      return
    else
      $("#data12 span.flash").text("end")
      $("#wrapper").stop().fadeIn 100

    return

  ), true

  # Shake Motion
  count = 0
  $("#data10 span.num").text(count)
  $(@).gShake ->
    count++
    bgColor count
    # sendBroadcast()

  # bgFlash
  bgColor = (value) ->
    $("#data10 span.num").text(count)
    color = value % 4
    if color == 0
      $("#wrapper").css
        background : "#ff64af"
      $("#wrapper").data("color","#ff64af")
    else if color == 1
      $("#wrapper").css
        background : "#40c8fe"
      $("#wrapper").data("color","#40c8fe")
    else if color == 2
      $("#wrapper").css
        background : "#ff8d41"
      $("#wrapper").data("color","#ff8d41")
    else if color == 3
      $("#wrapper").css
        background : "#ffffff"
      $("#wrapper").data("color","#ffffff")

  # device select
  device = "no device"
  if navigator.userAgent.indexOf("iPhone") > 0 or navigator.userAgent.indexOf("Android") > 0
    device = "sp"
  else if navigator.userAgent.indexOf('iPhone') == -1 and device.indexOf('Android') == -1
    device = "pc"

  # device locat
  if navigator.geolocation
    navigator.geolocation.getCurrentPosition( (position) ->
      lat = position.coords.latitude
      lon = position.coords.longitude
      $("#data15 span.location").text lat
      $("#data16 span.location").text lon
      return
    )
  else
    $("#data15 span.location").text "false location"

  # node socket.io
  domain = location.hostname
  s = io.connect 'http://rainier.saison-lab.com:3000'

  s.on "connect", -> # 接続時
    $("#data13 span.socketLog").text "socket.io Connect"

  s.on "disconnect", (client) -> # 切断時
    $("#data13 span.socketLog").text "socket.io Disconnect"

  s.on "toClient", (data) ->
    $("#data13 span.socketLog").text "socket.io toClient"
    $("#data14 span.toServer").text data.value + "/" + data.device
    count = count + data.value
    bgColor count
    return

  s.on "toAll", (data) ->
    $("#data13 span.socketLog").text "socket.io toAll"
    $("#data14 span.toServer").text data.value
    return

  sendBroadcast = ->
    $ ->
      $("#data13 span.socketLog").text "Broadcast call"
    s.emit "toServerBroad", #サーバへ送信
      value: 1,
      device: device,
      lat: lat,
      lon: lon
    return

  # socket function
  $("a#voiceTest").click ->
    $("#data13 span.socketLog").text "Button Push"
    sendBroadcast();

  # # Voice Audio
  # $("#voiceTest").click ->
  #   navigator.getUserMedia = (navigator.getUserMedia or navigator.webkitGetUserMedia or navigator.mozGetUserMedia or navigator.msGetUserMedia)
  #   if navigator.getUserMedia
  #     navigator.getUserMedia
  #       video: true
  #       audio: true
  #
  #     , ((localMediaStream) ->
  #       # successCallback
  #       video = document.querySelector("video")
  #       video.src = window.URL.createObjectURL(localMediaStream)
  #       return
  #
  #     ), (err) ->
  #       # errorCallback
  #       alert "The following error occured: " + err
  #       return
  #
  #   else
  #     alert "getUserMedia not supported"
