express = require "express"
mysqlLib = require './model/mysqlLib'
# passport = require 'passport'
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


# Twitter login
# router.get "/auth/twitter", passport.authenticate('twitter')
#
# # Twitterからのcallback
# router.get "/auth/twitter/callback", passport.authenticate("twitter",
#   successRedirect: "/mypage"
#   failureRedirect: "/"
# )


# router.post "/auth/twitter/callback", (req, res) ->
#   #twitter
#   passport.use new TwitterStrategy(
#     consumerKey: TWITTER_CONSUMER_KEY
#     consumerSecret: TWITTER_CONSUMER_SECRET
#     callbackURL: "http://localhost:3000/auth/twitter/callback"
#   , (token, tokenSecret, profile, done) ->
#     profile.twitter_token = token
#     profile.twitter_token_secret = tokenSecret
#     process.nextTick ->
#       done null, profile
#     return
#   )
#   return

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


  if req.param("user_id") and req.param("username") and req.param("mail") and req.param("password") and req.param("passwordRetry") and req.param("gender") and req.param("birthday")
    if req.param("password") is req.param("passwordRetry")
      # PostData
      user_id      = req.param("user_id")
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
