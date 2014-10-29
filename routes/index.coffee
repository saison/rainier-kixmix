express = require "express"
mysqlLib = require './model/mysqlLib'
dateUtils = require 'date-utils'
router = express.Router()

# GET home page.
router.get "/", (req, res) ->
  mysqlLib.getConnection (err, mclient) ->
    mclient.query "select * from users", (err, rows) ->
      res.render "index",
        title: "KIX MIX"
        users: rows
      return

  # connection.query "select * from users", (err, rows) ->
  #   res.render "index",
  #     title: "KIX MIX"
  #     users: rows
  #   return

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
  # Validation
  # そのうち実装する！


  if req.param("username") and req.param("mail") and req.param("password") and req.param("passwordRetry") and req.param("gender") and req.param("birthday")
    if req.param("password") is req.param("passwordRetry")
      # PostData
      username      = req.param("username")
      mail          = req.param("mail")
      password      = req.param("password")
      passwordRetry = req.param("passwordRetry")
      gender        = req.param("gender")
      birthday      = req.param("birthday")
      dt            = new Date()
      signup        = dt.toFormat("YYYY-MM-DD")

      userInsertData = {mail: mail, password: password, username: username, gender: gender, birthday: birthday, signup: signup}
      userInsertSql  = "INSERT INTO users SET ?"

      mysqlLib.getConnection (err, mclient) ->
        # Insert Users
        mclient.query userInsertSql, userInsertData, (err, result) ->
          console.log err,result

          # getUserId

          # SetSession
          req.session.username = username

          res.redirect "/mypage"
    else
      res.redirect "new"
  else
    res.redirect "new"

  return

module.exports = router
