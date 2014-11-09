(function() {
  var $testvideo, testvideo;

  $(function() {
    $("#colorBt").click(function() {
      var blue, color, green, red;
      red = Math.floor(Math.random() * (9 - 0) + 0);
      green = Math.floor(Math.random() * (9 - 0) + 0);
      blue = Math.floor(Math.random() * (9 - 0) + 0);
      color = "#" + red + green + blue;
      $("#liveBc").css("background", color);
    });
  });

  $(window).load(function() {
    seeThru.create("#liveVideo");
  });

  testvideo = void 0;

  $testvideo = $("#liveVideo");

}).call(this);
