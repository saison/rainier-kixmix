mysql = require("mysql")
pool = mysql.createPool(
  host: "localhost"
  user: "root"
  password: ""
  database: "rainier"
)

exports.getConnection = (callback) ->
  pool.getConnection (err, conn) ->
    return callback(err)  if err
    callback err, conn
    return

  return
