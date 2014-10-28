express = require("express")
router = express.Router()

# GET users listing.
router.get "/", (req, res) ->
  username = req.session.username
  res.render "mypage/index",
    title: "POST Users",
    username: username
  return

module.exports = router
