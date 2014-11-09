$ ->

  #seeThru.create('#liveVideo');
  $("#colorBt").click ->
    red = Math.floor(Math.random() * (9 - 0) + 0)
    green = Math.floor(Math.random() * (9 - 0) + 0)
    blue = Math.floor(Math.random() * (9 - 0) + 0)
    color = "#" + red + green + blue
    $("#liveBc").css "background", color
    return

  return

$(window).load ->
  seeThru.create "#liveVideo" #window読み込み後再生
  return


#ここから先はseeThruの設定
#基本いじる必要はないです
testvideo = undefined
$testvideo = $("#liveVideo")
