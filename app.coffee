express = require "express"
path = require "path"
favicon = require "serve-favicon"
logger = require "morgan"
cookieParser = require "cookie-parser"
bodyParser = require "body-parser"
session = require 'express-session'
methodOverride = require 'method-override'
multer  = require 'multer'
# Passport
passport = require 'passport'
TwitterStrategy = require('passport-twitter').Strategy




# Twitter key
TWITTER_CONSUMER_KEY = "vGiYRHuB0TIIRwwQk5u828zwx"
TWITTER_CONSUMER_SECRET = "y3bkgj5PCbFRJ6UB1JRgdzQZJAmIqilcjU1SLjTJIk1mvQv0o7"

# Passport sessionのセットアップ
passport.serializeUser (user, done) ->
  done null, user.id
  return

passport.deserializeUser (obj, done) ->
  done null, obj
  return

# PassportでTwitterStrategyを使うための設定
twitter = new TwitterStrategy(
  consumerKey: TWITTER_CONSUMER_KEY
  consumerSecret: TWITTER_CONSUMER_SECRET
  callbackURL: "http://localhost:3000/auth/twitter/callback"
, (token, tokenSecret, profile, done) ->
  profile.twitter_token = token
  profile.twitter_token_secret = tokenSecret

  done null, profile
  return
)

passport.use twitter


# Path
routes = require "./routes/index"
mypage = require "./routes/mypage"
live   = require "./routes/lives"
guest  = require "./routes/guest"
admin  = require "./routes/admin"



app = express()

# view engine setup
app.set "views", path.join(__dirname, "views")
app.set "view engine", "jade"

# uncomment after placing your favicon in /public
#app.use(favicon(__dirname + '/public/favicon.ico'));
app.use logger("dev")
app.use bodyParser.json()
app.use bodyParser.urlencoded(extended: false)
app.use cookieParser()
app.use session(
  secret: "keyboard cat"
  resave: true
  saveUninitialized: true
)
app.use passport.initialize()
app.use passport.session()
app.use require("node-compass")(mode: "expanded")
app.use express.static(path.join(__dirname, "public"))

# ルーティング
app.use "/", routes
app.use "/mypage", mypage
app.use "/live", live
app.use "/guest", guest
app.use "/admin", admin


# catch 404 and forward to error handler
app.use (req, res, next) ->
  err = new Error("Not Found")
  err.status = 404
  next err
  return


# error handlers

# development error handler
# will print stacktrace
if app.get("env") is "development"
  app.use (err, req, res, next) ->
    res.status err.status or 500
    res.render "error",
      message: err.message
      error: err

    return


# production error handler
# no stacktraces leaked to user
app.use (err, req, res, next) ->
  res.status err.status or 500
  res.render "error",
    message: err.message
    error: {}

  return

module.exports = app
