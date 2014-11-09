app = require("../../app")
http = require("http").Server(app)
io = require("socket.io")(http)

skio = ->

  # Socket.IO
  http.listen app.get("port"), ->
    console.log "Socket Server On!"
    console.log "Server Port -> " + app.get("port")
    return

  io.sockets.on "connection", (socket) ->
    console.log "Connection to SocketServer"

    # メッセージ送信（送信者にも送られる）
    socket.on "toAll", (data) ->
      console.log "toAll"
      io.sockets.emit "toClient",
        value: data.value
      return

    # ブロードキャスト（送信者以外の全員に送信）
    socket.on "toServerBroad", (data) ->
      console.log "toServerBroad"
      console.log data
      socket.broadcast.emit "toClient",
        value: data.value,
        device: data.device
      return




module.exports = skio
