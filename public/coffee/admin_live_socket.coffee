$ ->
  count = 0

  $("#toserver .toServer").text count.toString()

  # bgFlash
  bgColor = (count) ->
    $("#data10 span.num").text(count)

    if count < 10
      $("#heatLevel").addClass "level1"
      return
    else if count < 20
      $("#heatLevel").removeClass "level1"
      $("#heatLevel").addClass "level2"
      return
    else if count < 30
      $("#heatLevel").removeClass "level2"
      $("#heatLevel").addClass "level3"
      return
    else if count < 40
      $("#heatLevel").removeClass "level3"
      $("#heatLevel").addClass "level4"
      return
    else if count < 50
      $("#heatLevel").removeClass "level4"
      $("#heatLevel").addClass "level5"
      return
    else if count >= 60
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

  s.on "toAll", (data) ->
    $("#data13 span.socketLog").text "socket.io toAll"
    $("#data14 span.toServer").text data.value
    return
