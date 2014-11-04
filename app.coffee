express = require "express"
path = require "path"
favicon = require "serve-favicon"
logger = require "morgan"
cookieParser = require "cookie-parser"
bodyParser = require "body-parser"
session = require 'express-session'
methodOverride = require 'method-override'
# passport = require 'passport'
# TwitterStrategy = require('passport-twitter').Strategy
multer  = require 'multer'

# routing
routes = require "./routes/index"
mypage = require "./routes/mypage"
live   = require "./routes/lives"


# # Twitter
# # Passport sessionのセットアップ
# passport.serializeUser (user, done) ->
#   # done null, user
#   return
#
# passport.deserializeUser (obj, done) ->
#   # done null, obj
#   return
#
# # POST Twitter login
# TWITTER_CONSUMER_KEY = "9nnVQkAjiic5vh7jOI8qctzHa"
# TWITTER_CONSUMER_SECRET = "gcQs7rzqZ7YgN7NYTvR0DQGaSEDOW9GvKLxjBodESEZwDvj3Xc"
# #twitter
# passport.use new TwitterStrategy(
#   consumerKey: TWITTER_CONSUMER_KEY
#   consumerSecret: TWITTER_CONSUMER_SECRET
#   callbackURL: "http://localhost:3000/auth/twitter/callback"
# , (token, tokenSecret, profile, done) ->
#   console.log token, tokenSecret, profile, done
# )

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
# app.use passport.initialize()
# app.use passport.session()
# app.use passport.authenticate()
# app.use TwitterStrategy
app.use require("node-compass")(mode: "expanded")
app.use express.static(path.join(__dirname, "public"))
app.use "/", routes
app.use "/mypage", mypage
app.use "/live", live


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
