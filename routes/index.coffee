express = require "express"
mysqlLib = require './model/mysqlLib'
dateUtils = require 'date-utils'
passport = require 'passport'
crypto = require "crypto"
TwitterStrategy = require('passport-twitter').Strategy
FacebookStrategy = require('passport-facebook').Strategy
router = express.Router()

# GET home page.
router.get "/", (req, res) ->
  if req.session.user
    res.redirect "mypage"
  else
    res.render "index",
      title: "KIX MIX"
  return

router.get "/landing", (req, res) ->
  res.render "landing",
    title: "KixMix | キミの想いがライブを変える【KixMix】"
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

    # Hash
    sha1 = crypto.createHash('sha1')
    sha1.update(password)
    password = sha1.digest('hex')
    # console.log password

    userLoginSql = "select * from users WHERE user_id = ? AND password = ?"
    userLoginData = [user_id, password]

    mysqlLib.getConnection (err, mclient) ->
      mclient.query userLoginSql, userLoginData, (err, rows) ->
        if typeof(rows[0]) isnt "undefined"
          req.session.user =
            user_id: user_id
            username: rows[0].username
          res.redirect "mypage"
        else
          res.redirect "/"
  else
    res.redirect "/"

############################
# Twitter
############################

# Twitterの認証
router.get "/auth/twitter", passport.authenticate("twitter")

# Twitterからのcallback
router.get "/auth/twitter/callback", passport.authenticate("twitter",
  failureRedirect: "/"
), (req, res) ->
  req.session.social =
    user_id: req.user.id
    username: req.user.displayName
    token: req.user.twitter_token
    secret: req.user.twitter_token_secret
    sns: "twitter"

  loginSql = "SELECT * FROM users WHERE user_id = ?"
  user_id  = req.user.id
  # console.log loginSql
  # console.log user_id
  mysqlLib.getConnection (err, mclient) ->
    mclient.query loginSql, user_id, (err, result) ->
      # console.log result
      if typeof(result[0]) isnt "undefined"
        req.session.user =
          user_id: result[0].user_id
          username: result[0].username
        res.redirect "/mypage"
      else
        res.redirect "/sns_new"
      return


############################
# Facebook
############################

passport.use new FacebookStrategy(
  clientID: "1498672527074135"
  clientSecret: "05453f6a0278a01fb8992e7fd2248352"
  callbackURL: "http://localhost:3000/auth/facebook/callback"
, (accessToken, refreshToken, profile, done) ->
  profile.facebook_accessToken = accessToken
  profile.facebook_refreshToken = refreshToken
  # console.log accessToken,refreshToken
  done null, profile
  return
)

# facebookの認証
router.get "/auth/facebook", passport.authenticate("facebook")

# facebookからのcallback
router.get "/auth/facebook/callback", passport.authenticate("facebook",
  failureRedirect: "/"
), (req, res) ->
  req.session.social =
    user_id: req.user.id
    username: req.user.displayName
    token: req.user.facebook_accessToken
    secret: null
    sns: "facebook"
  res.redirect "/sns_new"
  return


# ###################
# sns is access
# ###################

router.get "/sns_new", (req, res) ->
  social = req.session.social

  loginSql  = ""
  loginData = ""
  if social.sns is "twitter"
    loginSql  = "SELECT * FROM users WHERE user_id = ?"
    loginData = [social.user_id]
  else if social.sns is "facebook"
    loginSql  = "SELECT * FROM users WHERE user_id = ? AND fb_accessToken = ?"
    loginData = [social.user_id]

  mysqlLib.getConnection (err, mclient) ->
    mclient.query loginSql, loginData, (err, result) ->

      if typeof(result[0]) isnt "undefined"
        req.session.user =
          user_id: result[0].user_id
          username: result[0].username
        res.redirect "/mypage"
      else
        res.render "createUserSns",
          title: "Kix Mix"
          social: req.session.social


# GET New Account for Social
router.post "/createsns", (req, res) ->
  if req.param("user_id") and req.param("username") and req.param("mail") and req.param("password") and req.param("passwordRetry") and req.param("gender") and req.param("birthday") and req.param("token") and req.param("secret") and req.param("witchSNS")
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

      # SNS data
      token         = req.param("token")
      secret      = req.param("secret")
      sns           = req.param("witchSNS")

      # Hash
      sha1 = crypto.createHash('sha1')
      sha1.update(password)
      password = sha1.digest('hex')

      if sns is "twitter"
        userInsertData = {user_id: user_id, mail: mail, password: password, username: username, gender: gender, birthday: birthday, signup: signup, tw_customer: token, tw_secret: secret}
      else if sns is "facebook"
        userInsertData = {user_id: user_id,mail: mail, password: password, username: username, gender: gender, birthday: birthday, signup: signup, fb_accesstoken: token}
      userInsertSql  = "INSERT INTO users SET ?"

      mysqlLib.getConnection (err, mclient) ->
        # Insert Users
        mclient.query userInsertSql, userInsertData, (err, result) ->
          # console.log err,result

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

      # Hash
      sha1 = crypto.createHash('sha1')
      sha1.update(password)
      password = sha1.digest('hex')

      userInsertData = {user_id: user_id, mail: mail, password: password, username: username, gender: gender, birthday: birthday, signup: signup}
      userInsertSql  = "INSERT INTO users SET ?"

      mysqlLib.getConnection (err, mclient) ->
        # Insert Users
        mclient.query userInsertSql, userInsertData, (err, result) ->
          # console.log err,result

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

# GET New KixMix account
router.get "/new", (req,res) ->
  res.render "createUser",
    title: "KIX MIX"
  return

# ゲストアカウントでログイン
router.post "/guestlogin", (req, res) ->
  if req.param("guestName")
    usrename = req.param "guestName"
    req.session.user =
      user_id: "guest"
      username: usrename
    # KixMixアカウント
    req.session.social =
      sns: "twitter"
      token: "2930520114-eWfkZ0BOVYV3cGZwxJDcgH6DRLFbQpdJNskoK6P"
      secret: "75MSNfEJiqQf85MXJbHi9PLpykpzY1pYh1usv0XjFpdsU"
    # ゲスト用マイページへ
    res.redirect "/guest"
  else
    res.redirect "/"

  return

module.exports = router
