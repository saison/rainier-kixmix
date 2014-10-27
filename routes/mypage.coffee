express = require("express")
router = express.Router()

# GET users listing.
router.get "/", (req, res) ->
  res.render "mypage/index",
    title: "POST Users"
  return

module.exports = router
