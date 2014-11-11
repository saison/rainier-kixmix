$ ->
  count = 0


  # bgFlash
  bgColor = (count) ->

    if count < 10
      if $("#heatLevel").hasClass "level1"
        $("#heatLevel").removeClass "level2"
      $("#heatLevel").addClass "level1"
      return
    else if count < 20
      if $("#heatLevel").hasClass "level1"
        $("#heatLevel").removeClass "level1"
      if $("#heatLevel").hasClass "level3"
        $("#heatLevel").removeClass "level3"
      $("#heatLevel").addClass "level2"
      return
    else if count < 30
      if $("#heatLevel").hasClass "level2"
        $("#heatLevel").removeClass "level2"
      if $("#heatLevel").hasClass "level4"
        $("#heatLevel").removeClass "level4"
      $("#heatLevel").addClass "level3"
      return
    else if count < 40
      if $("#heatLevel").hasClass "level3"
        $("#heatLevel").removeClass "level3"
      if $("#heatLevel").hasClass "level5"
        $("#heatLevel").removeClass "level5"
      $("#heatLevel").addClass "level4"
      return
    else if count < 50
      if $("#heatLevel").hasClass "level4"
        $("#heatLevel").removeClass "level4"
      if $("#heatLevel").hasClass "levelMax"
        $("#heatLevel").removeClass "levelMax"
      $("#heatLevel").addClass "level5"
      $("#livePeople #leftPeople,#livePeople #rightPeople").css
        display: "none"
      $("#bonus").css
        display: "none"
      return
    else if count >= 60
      if $("#heatLevel").hasClass "level5"
        $("#heatLevel").removeClass "level5"
      $("#heatLevel").addClass "levelMax"
      $("#livePeople #leftPeople,#livePeople #rightPeople").css
        display: "block"

      return

  decrementCount = ->
    $("#heatLevel").animate(
      opacity: ".3"
    , 250).animate(
      opacity: "1"
    , 250).animate(
      opacity: ".3"
    , 250).animate
      opacity: "1"
    , 250

    $("#livePeople").animate(
      "margin-bottom": "0"
    , 250).animate(
      "margin-bottom": "-15px"
    , 250).animate(
      "margin-bottom": "0"
    , 250).animate
      "margin-bottom": "-15px"
    , 250

    if count > 0
      count--

    bgColor count
    return

  # node socket.io
  domain = location.hostname

  s = io.connect 'http://' + domain + ':3000'

  s.on "connect", -> # 接続時

  s.on "disconnect", (client) -> # 切断時

  s.on "toClient", (data) ->
    count = count + data.value
    bgColor count
    return


  # # down heat level
  setInterval decrementCount, 1000
