express = require "express"
mysqlLib = require './model/mysqlLib'
dateUtils = require 'date-utils'
router = express.Router()

# GET home page.
router.get "/", (req, res) ->
  if req.session.user
    res.redirect "mypage"
  else
    res.render "index",
      title: "KIX MIX"
  return

# GET logout
router.get "/logout", (req,res) ->
  delete req.session.user
  res.redirect "/"

# POST login
router.post "/login", (req, res) ->
  if req.param("user_id") and req.param("password")
    # kixmix Login
    user_id = req.param("user_id")
    password = req.param("password")

    userLoginSql = "select * from users WHERE user_id = ? AND password = ?"
    userLoginData = [user_id, password]

    mysqlLib.getConnection (err, mclient) ->
      mclient.query userLoginSql, userLoginData, (err, rows) ->
        if err == null
          req.session.user =
            user_id: user_id
            username: rows[0].username
          res.redirect "mypage"
        else
          res.redirect "/"
  else
    res.redirect "/"




# GET New KixMix account
router.get "/new", (req,res) ->
  res.render "createUser",
    title: "KIX MIX"
  return

# GET New KixMix account
router.post "/new", (req, res) ->
  # Validation
  # そのうち実装する！


  if req.param("user_id") and req.param("username") and req.param("mail") and req.param("password") and req.param("passwordRetry") and req.param("gender") and req.param("birthday")
    if req.param("password") is req.param("passwordRetry")
      # PostData
      user_id       = req.param("user_id")
      username      = req.param("username")
      mail          = req.param("mail")
      password      = req.param("password")
      passwordRetry = req.param("passwordRetry")
      gender        = req.param("gender")
      birthday      = req.param("birthday")
      dt            = new Date()
      signup        = dt.toFormat("YYYY-MM-DD")

      userInsertData = {user_id: user_id,mail: mail, password: password, username: username, gender: gender, birthday: birthday, signup: signup}
      userInsertSql  = "INSERT INTO users SET ?"

      mysqlLib.getConnection (err, mclient) ->
        # Insert Users
        mclient.query userInsertSql, userInsertData, (err, result) ->
          console.log err,result

          # SetSession
          req.session.user =
            user_id: user_id
            username: username

          res.redirect "/mypage"
    else
      res.redirect "new"
  else
    res.redirect "new"

  return

module.exports = router
