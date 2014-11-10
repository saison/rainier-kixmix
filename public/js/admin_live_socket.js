(function() {
  $(function() {
    var bgColor, count, decrementCount, domain, s;
    count = 0;
    $("#toserver .toServer").text(count.toString());
    bgColor = function(count) {
      console.log("bgColor => " + count);
      $("#toserver .toServer").text(count.toString());
      if (count < 10) {
        console.log("if 1");
        if ($("#heatLevel").hasClass("level1")) {
          $("#heatLevel").removeClass("level2");
        }
        $("#heatLevel").addClass("level1");
      } else if (count < 20) {
        console.log("if 2");
        if ($("#heatLevel").hasClass("level1")) {
          $("#heatLevel").removeClass("level1");
        }
        if ($("#heatLevel").hasClass("level3")) {
          $("#heatLevel").removeClass("level3");
        }
        $("#heatLevel").addClass("level2");
      } else if (count < 30) {
        console.log("if 3");
        if ($("#heatLevel").hasClass("level2")) {
          $("#heatLevel").removeClass("level2");
        }
        if ($("#heatLevel").hasClass("level4")) {
          $("#heatLevel").removeClass("level4");
        }
        $("#heatLevel").addClass("level3");
      } else if (count < 40) {
        console.log("if 4");
        if ($("#heatLevel").hasClass("level3")) {
          $("#heatLevel").removeClass("level3");
        }
        if ($("#heatLevel").hasClass("level5")) {
          $("#heatLevel").removeClass("level5");
        }
        $("#heatLevel").addClass("level4");
      } else if (count < 50) {
        console.log("if 5");
        if ($("#heatLevel").hasClass("level4")) {
          $("#heatLevel").removeClass("level4");
        }
        if ($("#heatLevel").hasClass("levelMax")) {
          $("#heatLevel").removeClass("levelMax");
        }
        $("#heatLevel").addClass("level5");
      } else if (count >= 60) {
        console.log("if 6");
        if ($("#heatLevel").hasClass("level5")) {
          $("#heatLevel").removeClass("level5");
        }
        $("#heatLevel").addClass("levelMax");
      }
    };
    domain = location.hostname;
    s = io.connect('http://' + domain + ':3000');
    s.on("connect", function() {
      return $("#data .socketLog").text("socket.io Connect");
    });
    s.on("disconnect", function(client) {
      return $("#data .socketLog").text("socket.io Disconnect");
    });
    s.on("toClient", function(data) {
      $("#data .socketLog").text("socket.io toClient");
      count = count + data.value;
      bgColor(count);
      $("#toserver .toServer").text(count.toString());
    });
    decrementCount = function() {
      console.log("interval 2000");
      if (count > 0) {
        count--;
      }
      console.log(count);
      return bgColor(count);
    };
    return setInterval(decrementCount, 2000);
  });

}).call(this);
