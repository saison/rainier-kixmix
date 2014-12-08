(function() {
  $(function() {
    $("aside").hover((function() {
      $(this).stop().animate({
        opacity: "1"
      }, 200);
    }), function() {
      $(this).stop().animate({
        opacity: "0"
      }, 200);
    });
    $("#videoController li:first-child").click(function() {
      $("#liveVideo").get(0).pause();
      $("#videoController li:first-child").hide(200);
      return $("#videoController li:last-child").show(200);
    });
    $("#videoController li:last-child").click(function() {
      $("#liveVideo").get(0).play();
      $("#videoController li:last-child").hide(200);
      return $("#videoController li:first-child").show(200);
    });
    $("#volCntl li:first-child").click(function() {
      return $("#liveVideo").get(0).volume = $("#liveVideo").get(0).volume + 0.1;
    });
    return $("#volCntl li:last-child").click(function() {
      return $("#liveVideo").get(0).volume = $("#liveVideo").get(0).volume - 0.1;
    });
  });

}).call(this);
