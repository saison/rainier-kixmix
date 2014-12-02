express = require("express")
mysqlLib = require './model/mysqlLib'
router = express.Router()

router.get "/", (req, res) ->
  console.log req.session.user

  mysqlLib.getConnection (err, mclient) ->
    allLivesSql = "SELECT * FROM lives"

    mclient.query allLivesSql, "", (err, allLivesRows) ->
      console.log allLivesRows

      res.render "guest/index",
        title: "Kix Mix"
        lives: allLivesRows

router.get "/guestjoinlive/:live_id([0-9]+)", (req, res) ->
  if req.session.user
    # get session & param live_id
    sess = req.session.user
    live_id = Number req.params.live_id
    # isSet live_id
    if req.params.live_id
      mysqlLib.getConnection (err, mclient) ->
        liveInfoSql = "SELECT * FROM lives WHERE live_id = ?"
        mclient.query liveInfoSql, live_id, (err, liveInfo) ->
          res.render "lives/index",
            title: "Kix Mix"
            user: sess
            liveInfo: liveInfo

    else
      console.log "isSet false"
      res.redirect "/guest"
  else
    res.redirect "/"

module.exports = router
