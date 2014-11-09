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
          req.session.user =
            user_id: user_id
            username: rows[0].username
          res.redirect "/admin/mypage"
        else
          res.redirect "/admin"
  else
    res.redirect "/admin"


module.exports = router
