(function() {
  $(function() {
    var bgColor, callN, count, decrementCount, domain, level, s, sendLevel;
    count = 0;
    level = 1;
    $("#liveVideo2").css({
      "opacity": "0"
    });
    bgColor = function(count) {
      if (count < 10) {
        if ($("#heatLevel").hasClass("level1")) {
          $("#heatLevel").removeClass("level2");
        }
        $("#heatLevel").addClass("level1");
        $("#liveVideo2").get(0).pause();
        $("#liveVideo").get(0).play();
        return $("#liveVideo2").animate({
          "opacity": "0"
        }, 1000, function() {
          return $("#liveVideo").animate({
            "opacity": "1"
          }, 1000, function() {
            level = 1;
            sendLevel();
          });
        });
      } else if (count < 20) {
        if ($("#heatLevel").hasClass("level1")) {
          $("#heatLevel").removeClass("level1");
        }
        if ($("#heatLevel").hasClass("level3")) {
          $("#heatLevel").removeClass("level3");
        }
        $("#heatLevel").addClass("level2");
        level = 2;
        sendLevel();
      } else if (count < 30) {
        if ($("#heatLevel").hasClass("level2")) {
          $("#heatLevel").removeClass("level2");
        }
        if ($("#heatLevel").hasClass("level4")) {
          $("#heatLevel").removeClass("level4");
        }
        $("#heatLevel").addClass("level3");
        level = 3;
        sendLevel();
      } else if (count < 40) {
        if ($("#heatLevel").hasClass("level3")) {
          $("#heatLevel").removeClass("level3");
        }
        if ($("#heatLevel").hasClass("level5")) {
          $("#heatLevel").removeClass("level5");
        }
        $("#heatLevel").addClass("level4");
        level = 4;
        sendLevel();
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
        $("#liveVideo").src("/media/hal.mp4");
        level = 5;
        sendLevel();
      } else if (count >= 70) {
        if ($("#heatLevel").hasClass("level5")) {
          $("#heatLevel").removeClass("level5");
        }
        $("#heatLevel").addClass("levelMax");
        $("#livePeople #leftPeople,#livePeople #rightPeople").css({
          display: "block"
        });
        $("#liveVideo").get(0).pause();
        $("#liveVideo2").get(0).play();
        return $("#liveVideo").animate({
          "opacity": "0"
        }, 1000, function() {
          return $("#liveVideo2").animate({
            "opacity": "1"
          }, 1000, function() {
            level = 6;
            sendLevel();
          });
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
      count = count + 5;
      bgColor(count);
    });
    callN = 0;
    s.on("toCallLive", function(data) {
      var fsize, left, top;
      console.log("toServerBroadLiveCall");
      left = Math.floor(Math.random() * 100);
      top = Math.floor(Math.random() * 100);
      fsize = Math.floor(Math.random() * 80);
      callN++;
      $("#liveCall").append("<div class='callText call" + callN + "' style='left:" + left + "%;top:" + top + "%;font-size:" + fsize + "px;color:" + data.call[1] + ";'>" + data.call[0] + "@" + data.username + "</div>");
      return $(".call" + callN).fadeOut(1500);
    });
    sendLevel = function() {
      s.emit("toLevel", {
        level: level
      });
    };
    return setInterval(decrementCount, 1000);
  });

}).call(this);
