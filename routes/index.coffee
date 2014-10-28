express = require("express")
router = express.Router()

# GET home page.
router.get "/", (req, res) ->

  connection.query "select * from users", (err, rows) ->
    res.render "index",
      title: "KIX MIX"
      users: rows
    return

# POST login
router.post "/login", (req, res) ->
  # kixmix Login
  name = req.param("name")
  pass = req.param("pass")
  res.send("userName =>" + name + " pass->" + pass)
  return

# POST Twitter login
router.post "/twitterlogin", (req, res) ->
  #twitter
  res.send("twitter login")
  return

# POST Facebook login
router.post "/facebooklogin", (req, res) ->
  #facebook
  res.send("facebook login")
  return

# GET New KixMix account
router.get "/new", (req,res) ->
  res.render "createUser"
  return

# GET New KixMix account
router.post "/new", (req, res) ->
  # PostData
  username      = req.param("username")
  mail          = req.param("mail")
  password      = req.param("password")
  passwordRetry = req.param("passwordRetry")
  gender        = req.param("gender")
  birthday      = req.param("birthday")

  # getUserId

  # SetSession
  req.session.username = username

  res.redirect "/mypage"

  return

module.exports = router
