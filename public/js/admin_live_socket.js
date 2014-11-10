(function() {
  $(function() {
    var bgColor, count, domain, s;
    count = 0;
    $("#toserver .toServer").text(count.toString());
    bgColor = function(count) {
      $("#data10 span.num").text(count);
      if (count < 10) {
        $("#heatLevel").addClass("level1");
      } else if (count < 20) {
        $("#heatLevel").removeClass("level1");
        $("#heatLevel").addClass("level2");
      } else if (count < 30) {
        $("#heatLevel").removeClass("level2");
        $("#heatLevel").addClass("level3");
      } else if (count < 40) {
        $("#heatLevel").removeClass("level3");
        $("#heatLevel").addClass("level4");
      } else if (count < 50) {
        $("#heatLevel").removeClass("level4");
        $("#heatLevel").addClass("level5");
      } else if (count >= 60) {
        $("#heatLevel").removeClass("level5");
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
    return s.on("toAll", function(data) {
      $("#data13 span.socketLog").text("socket.io toAll");
      $("#data14 span.toServer").text(data.value);
    });
  });

}).call(this);
