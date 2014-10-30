express = require("express")
mysqlLib = require './model/mysqlLib'
router = express.Router()

# GET users listing.
router.get "/", (req, res) ->
  mysqlLib.getConnection (err, mclient) ->
    userInfoSql = "select * from users WHERE user_id = ?"
    sess = req.session.user
    mclient.query userInfoSql, sess.user_id, (err, userInfoRows) ->

      joinLivesSql = "SELECT * FROM lives INNER JOIN live_users ON lives.live_id = live_users.live_id WHERE live_users.user_id = ?"

      mclient.query joinLivesSql, sess.user_id, (err, joinLivesRows) ->
        console.log joinLivesRows
        res.render "mypage/index",
          title: "Kix Mix"
          user: sess
          rows: userInfoRows
          lives: joinLivesRows
  return

module.exports = router
