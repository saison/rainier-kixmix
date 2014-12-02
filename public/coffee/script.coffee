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
    sendBroadcast()

  # penlight
  penFlg = true
  $("#penLightMode").click ->
    if penFlg
      $("#liveBg").css
        "display":"none"
      $("#liveBgC").css
        "display":"block"
      penFlg = false
    else
      $("#liveBg").css
        "display":"block"
      $("#liveBgC").css
        "display":"none"
      penFlg = true

  # clap push
  $("#clap").click ->
    sendBroadcast()

  # bgFlash
  bgColor = (value) ->
    switch value
      when 1
        $("#liveBgC").css
          background : "rgba(255, 255, 255, 1)"
      when 2
        $("#liveBgC").css
          background : "rgba(150, 248, 255, 1)"
      when 3
        $("#liveBgC").css
          background : "rgba(72, 169, 255, 1)"
      when 4
        $("#liveBgC").css
          background : "rgba(255, 250, 103, 1)"
      when 5
        $("#liveBgC").css
          background : "rgba(255, 160, 76, 1)"
      when 6
        $("#liveBgC").css
          background : "rgba(255, 65, 65, 1)"

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
    return

  # audience
  s.on "toLogin", (data) ->
    $("#audienceArea .countArea .count").text data.audience

  s.on "toLevel", (data) ->
    console.log "tolevel"
    console.log data
    console.log data.level
    $("#venueLevel .levelArea span").text data.level
    bgColor data.level
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
    $("#liveBgC").animate(
      opacity: ".3"
    , 250).animate(
      opacity: "1"
    , 250).animate(
      opacity: ".3"
    , 250).animate
      opacity: "1"
    , 250
    if count > 0
      count--
      if $("#youerLevel .graph").height() > 0
        $("#youerLevel .graph").animate
          "height": "-=10px"
          ,1000

  setInterval decrementCount, 1000
