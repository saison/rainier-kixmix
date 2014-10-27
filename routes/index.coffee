express = require("express")
router = express.Router()

# GET home page.
router.get "/", (req, res) ->
  res.render "index",
    title: "KIXMIX"
  return

module.exports = router
