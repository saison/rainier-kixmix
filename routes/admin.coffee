express = require "express"
mysqlLib = require './model/mysqlLib'
dateUtils = require 'date-utils'
router = express.Router()

# GET home page.
router.get "/", (req, res) ->
  res.render "admin/index",
    title: "KIX MIX"
  return

router.post "/login", (req, res) ->
  if req.param("user_id") and req.param("password")
    # kixmix Login
    user_id = req.param("user_id")
    password = req.param("password")

    adminLoginSql = "select * from users WHERE user_id = ? AND password = ? AND is_admin = 1"
    adminLoginData = [user_id, password]

    mysqlLib.getConnection (err, mclient) ->
      mclient.query adminLoginSql, adminLoginData, (err, rows) ->
        if err == null
          req.session.admin =
            user_id: user_id
            username: rows[0].username
          res.redirect "/admin/mypage"
        else
          res.redirect "/admin"
  else
    res.redirect "/admin"
  return

router.get "/mypage", (req, res) ->
  sess = req.session.admin
  mysqlLib.getConnection (err, mclient) ->
    adminLivesSql = "SELECT * FROM lives"
    mclient.query adminLivesSql, sess.user_id, (err, adminLivesRows) ->
      console.log adminLivesRows
      res.render "admin/mypage",
        title: "Kix Mix"
        user: sess
        lives: adminLivesRows
  return

router.get "/live/:live_id([0-9]+)", (req, res) ->
  res.render "admin/live"

router.get "/addLive", (req,res) ->
  sess = req.session.user
  res.render "admin/addLive",
    title: "Kix Mix"
    user: sess

router.post "/add", (req,res) ->
  # if req.param "title" and req.param "cast" and req.param "place" and req.param "address" and req.param "date"
  title   = req.param "title"
  cast    = req.param "cast"
  place   = req.param "place"
  address = req.param "address"
  date    = req.param "date"

  liveInsertData = {title:title,cast:cast,date:date,address:address,place:place}
  liveInsertSql  = "INSERT INTO lives SET ?"
  mysqlLib.getConnection (err, mclient) ->
    mclient.query liveInsertSql, liveInsertData, (err, result) ->
      console.log err,result
      sess = req.session.user
      res.redirect "/admin/mypage"
  return


module.exports = router
