app = require("../../app")
http = require("http").Server(app)
io = require("socket.io")(http)

loginCount = 0

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
      console.log data
      io.sockets.emit "toClient",
        level: data.level
      return

    # ブロードキャスト（送信者以外の全員に送信）
    socket.on "toServerBroad", (data) ->
      console.log "toServerBroad"
      console.log data
      socket.broadcast.emit "toClient",
        value: data.value,
        device: data.device
      return

    # ヒートレベルの送信
    socket.on "toLevel", (data) ->
      console.log "toLevel"
      console.log data
      socket.broadcast.emit "toLevel",
        level: data.level
      return

    # ログイン時
    socket.on "toLogin", (data) ->
      console.log "toLogin"
      console.log data.user
      loginCount = loginCount + 1
      socket.broadcast.emit "toLoginUser",
        user: data.user
      io.sockets.emit "toLogin",
        audience: loginCount





module.exports = skio
