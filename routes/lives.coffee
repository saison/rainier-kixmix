express = require("express")
mysqlLib = require './model/mysqlLib'
# Passport
passport = require 'passport'
TwitterStrategy = require('passport-twitter').Strategy
router = express.Router()

# GET / redirect
router.get "/", (req, res) ->
  res.redirect "mypage"

# GET Live_Id
router.get "/:live_id([0-9]+)", (req, res) ->
  if req.session.user
    # get session & param live_id
    console.log req.session.social
    sess = req.session.user
    live_id = Number req.params.live_id

    # isSet live_id
    if req.params.live_id
      mysqlLib.getConnection (err, mclient) ->
        userJoinLiveSql = "SELECT live_id FROM live_users WHERE user_id = ?"
        mclient.query userJoinLiveSql, sess.user_id, (err, joinLiveResult) ->
          if joinLiveResult[0].live_id == live_id
            liveInfoSql = "SELECT * FROM lives WHERE live_id = ?"
            mclient.query liveInfoSql, live_id, (err, liveInfo) ->
              res.render "lives/index",
                title: "Kix Mix"
                user: sess
                liveInfo: liveInfo
          else
            console.log "isSQL false"
            res.redirect "../mypage"

    else
      console.log "isSet false"
      res.redirect "../mypage"
  else
    res.redirect "/"

router.post "/tweet", (req, res) ->
  sess = req.session.social
  tweet = req.param("tweet")
  tweetText = encodeURIComponent(tweet+" #KixMix")

  console.log tweet

  passport._strategies.twitter._oauth.getProtectedResource "https://api.twitter.com/1.1/statuses/update.json?status=" + tweetText,
  "POST",
  req.session.social.token,
  req.session.social.secret,
  (err, data, response) ->

    res.send "tweet"

    return


module.exports = router
