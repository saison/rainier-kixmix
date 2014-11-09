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
  mysqlLib.getConnection (err, mclient) ->
    userInfoSql = "select * from users WHERE user_id = ?"
    sess = req.session.admin
    adminLivesSql = "SELECT * FROM lives INNER JOIN live_users ON lives.live_id = live_users.live_id WHERE live_users.user_id = ?"

    mclient.query userInfoSql, sess.user_id, (err, adminInfoRows) ->
      mclient.query adminLivesSql, sess.user_id, (err, adminLivesRows) ->

        console.log adminLivesRows
        res.render "admin/mypage",
          title: "Kix Mix"
          user: sess
          rows: adminInfoRows
          lives: adminLivesRows
  return

router.get "/live/:live_id([0-9]+)", (req, res) ->
  res.render "admin/live"


module.exports = router
