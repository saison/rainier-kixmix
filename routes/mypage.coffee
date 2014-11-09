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

router.get "/joinLives", (req, res) ->
  mysqlLib.getConnection (err, mclient) ->

    noJoinLivesSQL = "SELECT * FROM lives WHERE live_id NOT IN (SELECT live_id FROM live_users WHERE user_id = ?)"
    sess = req.session.user

    mclient.query noJoinLivesSQL, sess.user_id, (err, noJoinLivesRows) ->
      if noJoinLivesRows[0] is undefined
        res.render "mypage/noLives",
          title: "Kix Mix"
          user: sess
          display: "none"
      else
        res.render "mypage/joinLives",
          title: "Kix Mix"
          user: sess
          lives: noJoinLivesRows

router.get "/joinLives/join/:live_id([0-9]+)", (req, res) ->

  mysqlLib.getConnection (err, mclient) ->

    live_id = Number req.params.live_id
    sess = req.session.user
    insertData = {user_id: sess.user_id, live_id: live_id}
    joinLivesSQL = "INSERT INTO live_users SET ?"

    mclient.query joinLivesSQL, insertData, (err, result) ->
      res.redirect "/mypage"

module.exports = router
