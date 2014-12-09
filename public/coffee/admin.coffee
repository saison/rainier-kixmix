$ ->
  $("aside").hover (->
    $(this).stop().animate
      opacity: "1"
    , 200
    return
  ), ->
    $(this).stop().animate
      opacity: "0"
    , 200
    return


  $("#videoController li:first-child").click ->
    $("#liveVideo").get(0).pause()
    $("#videoController li:first-child").hide 200
    $("#videoController li:last-child").show 200

  $("#videoController li:last-child").click ->
    $("#liveVideo").get(0).play()
    $("#videoController li:last-child").hide 200
    $("#videoController li:first-child").show 200

  $("#volCntl li:first-child").click ->
    $("#liveVideo").get(0).volume = $("#liveVideo").get(0).volume + 0.1
  $("#volCntl li:last-child").click ->
    $("#liveVideo").get(0).volume = $("#liveVideo").get(0).volume - 0.1
