(function() {
  $(function() {
    var bgColor, count, decrementCount, domain, s;
    count = 0;
    bgColor = function(count) {
      if (count < 10) {
        if ($("#heatLevel").hasClass("level1")) {
          $("#heatLevel").removeClass("level2");
        }
        $("#heatLevel").addClass("level1");
      } else if (count < 20) {
        if ($("#heatLevel").hasClass("level1")) {
          $("#heatLevel").removeClass("level1");
        }
        if ($("#heatLevel").hasClass("level3")) {
          $("#heatLevel").removeClass("level3");
        }
        $("#heatLevel").addClass("level2");
      } else if (count < 30) {
        if ($("#heatLevel").hasClass("level2")) {
          $("#heatLevel").removeClass("level2");
        }
        if ($("#heatLevel").hasClass("level4")) {
          $("#heatLevel").removeClass("level4");
        }
        $("#heatLevel").addClass("level3");
      } else if (count < 40) {
        if ($("#heatLevel").hasClass("level3")) {
          $("#heatLevel").removeClass("level3");
        }
        if ($("#heatLevel").hasClass("level5")) {
          $("#heatLevel").removeClass("level5");
        }
        $("#heatLevel").addClass("level4");
      } else if (count < 50) {
        if ($("#heatLevel").hasClass("level4")) {
          $("#heatLevel").removeClass("level4");
        }
        if ($("#heatLevel").hasClass("levelMax")) {
          $("#heatLevel").removeClass("levelMax");
        }
        $("#heatLevel").addClass("level5");
        $("#livePeople #leftPeople,#livePeople #rightPeople").css({
          display: "none"
        });
        $("#bonus").css({
          display: "none"
        });
      } else if (count >= 60) {
        if ($("#heatLevel").hasClass("level5")) {
          $("#heatLevel").removeClass("level5");
        }
        $("#heatLevel").addClass("levelMax");
        $("#bonus").css({
          display: "block"
        });
        $("#livePeople #leftPeople,#livePeople #rightPeople").css({
          display: "block"
        });
      }
    };
    decrementCount = function() {
      $("#heatLevel").animate({
        opacity: ".3"
      }, 250).animate({
        opacity: "1"
      }, 250).animate({
        opacity: ".3"
      }, 250).animate({
        opacity: "1"
      }, 250);
      $("#livePeople").animate({
        "margin-bottom": "0"
      }, 250).animate({
        "margin-bottom": "-15px"
      }, 250).animate({
        "margin-bottom": "0"
      }, 250).animate({
        "margin-bottom": "-15px"
      }, 250);
      if (count > 0) {
        count--;
      }
      bgColor(count);
    };
    domain = location.hostname;
    s = io.connect('http://' + domain + ':3000');
    s.on("connect", function() {});
    s.on("disconnect", function(client) {});
    s.on("toClient", function(data) {
      count = count + data.value;
      bgColor(count);
    });
    return setInterval(decrementCount, 1000);
  });

}).call(this);
