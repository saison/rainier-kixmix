$ ->
  count = 0

  $("#toserver .toServer").text count.toString()

  # bgFlash
  bgColor = (count) ->
    console.log "bgColor => " + count

    $("#toserver .toServer").text count.toString()

    if count < 10
      if $("#heatLevel").hasClass "level1"
        $("#heatLevel").removeClass "level2"
      $("#heatLevel").addClass "level1"
      return
    else if count < 20
      if $("#heatLevel").hasClass "level1"
        $("#heatLevel").removeClass "level1"
      if $("#heatLevel").hasClass "level3"
        $("#heatLevel").removeClass "level3"
      $("#heatLevel").addClass "level2"
      return
    else if count < 30
      if $("#heatLevel").hasClass "level2"
        $("#heatLevel").removeClass "level2"
      if $("#heatLevel").hasClass "level4"
        $("#heatLevel").removeClass "level4"
      $("#heatLevel").addClass "level3"
      return
    else if count < 40
      if $("#heatLevel").hasClass "level3"
        $("#heatLevel").removeClass "level3"
      if $("#heatLevel").hasClass "level5"
        $("#heatLevel").removeClass "level5"
      $("#heatLevel").addClass "level4"
      return
    else if count < 50
      if $("#heatLevel").hasClass "level4"
        $("#heatLevel").removeClass "level4"
      if $("#heatLevel").hasClass "levelMax"
        $("#heatLevel").removeClass "levelMax"
      $("#heatLevel").addClass "level5"
      return
    else if count >= 60
      if $("#heatLevel").hasClass "level5"
        $("#heatLevel").removeClass "level5"
      $("#heatLevel").addClass "levelMax"

      return

  # node socket.io
  domain = location.hostname

  s = io.connect 'http://' + domain + ':3000'

  s.on "connect", -> # 接続時
    $("#data .socketLog").text "socket.io Connect"

  s.on "disconnect", (client) -> # 切断時
    $("#data .socketLog").text "socket.io Disconnect"

  s.on "toClient", (data) ->
    $("#data .socketLog").text "socket.io toClient"
    count = count + data.value
    bgColor count
    $("#toserver .toServer").text count.toString()
    return

  decrementCount = ->
    if count > 0
      count--
    bgColor count

  setInterval decrementCount, 2000
