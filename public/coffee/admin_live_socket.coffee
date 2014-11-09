$ ->
  count = 0

  # bgFlash
  bgColor = (value) ->
    $("#data10 span.num").text(count)
    color = value % 4
    if color == 0
      $("#liveBg").css
        background : "#ff64af"
    else if color == 1
      $("#liveBg").css
        background : "#40c8fe"
    else if color == 2
      $("#liveBg").css
        background : "#ff8d41"
    else if color == 3
      $("#liveBg").css
        background : "#ffffff"

  # node socket.io
  domain = location.hostname

  s = io.connect 'http://' + domain + ':3000'

  s.on "connect", -> # 接続時
    $("#data .socketLog").text "socket.io Connect"

  s.on "disconnect", (client) -> # 切断時
    $("#data .socketLog").text "socket.io Disconnect"

  s.on "toClient", (data) ->
    $("#data .socketLog").text "socket.io toClient"
    $("#toserver .toServer").text data.value
    count = count + data.value
    bgColor count
    return

  s.on "toAll", (data) ->
    $("#data13 span.socketLog").text "socket.io toAll"
    $("#data14 span.toServer").text data.value
    return
