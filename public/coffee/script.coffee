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

    bgColor = $("#liveHeatLevel").data("color")

    # Flash Function
    if Math.abs(xg) >= 8 or Math.abs(yg) <= 5
      $("#liveHeatLevel").fadeOut 100, ->
        $(this).fadeIn 100
        return
      return
    else
      $("#liveHeatLevel").stop().fadeIn 100

    return

  ), true

  # Shake Motion
  count = 0
  $(@).gShake ->
    count++
    if $("#youerLevel .graph").height() < 300
      $("#youerLevel .graph").animate
        "height": "+=10px"
        ,10
    bgColor count
    sendBroadcast()

  # bgFlash
  bgColor = (value) ->
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

  # # device locat
  # if navigator.geolocation
  #   navigator.geolocation.getCurrentPosition( (position) ->
  #     lat = position.coords.latitude
  #     lon = position.coords.longitude
  #     return
  #   )
  # else

  # node socket.io
  domain = location.hostname

  s = io.connect 'http://' + domain + ':3000'

  s.on "connect", -> # 接続時
    s.emit "toLogin",
      user: $("aside#sideMenu h2").text()


  s.on "disconnect", (client) -> # 切断時

  s.on "toClient", (data) ->
    count = count + data.value
    bgColor count
    return

  # audience
  s.on "toLogin", (data) ->
    $("#audienceArea .countArea .count").text data.audience

  s.on "toLevel", (data) ->
    console.log "tolevel"
    console.log data
    console.log data.level
    $("#venueLevel .levelArea span").text data.level
    switch data.level
      when 1
        $("#allAudienceLevel .graph").css
          "height": "50px"
      when 2
        $("#allAudienceLevel .graph").css
          "height": "100px"
      when 3
        $("#allAudienceLevel .graph").css
          "height": "150px"
      when 4
        $("#allAudienceLevel .graph").css
          "height": "200px"
      when 5
        $("#allAudienceLevel .graph").css
          "height": "250px"
      when 6
        $("#allAudienceLevel .graph").css
          "height": "300px"
    return

  sendBroadcast = ->
    s.emit "toServerBroad", #サーバへ送信
      value: 1,
      device: device
    return


  decrementCount = ->
    if count > 0
      count--
      if $("#youerLevel .graph").height() > 0
        $("#youerLevel .graph").animate
          "height": "-=10px"
          ,1000

  setInterval decrementCount, 1000
