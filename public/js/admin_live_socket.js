(function() {
  $(function() {
    var bgColor, count, domain, s;
    count = 0;
    bgColor = function(value) {
      var color;
      $("#data10 span.num").text(count);
      color = value % 4;
      if (color === 0) {
        return $("#liveBg").css({
          background: "#ff64af"
        });
      } else if (color === 1) {
        return $("#liveBg").css({
          background: "#40c8fe"
        });
      } else if (color === 2) {
        return $("#liveBg").css({
          background: "#ff8d41"
        });
      } else if (color === 3) {
        return $("#liveBg").css({
          background: "#ffffff"
        });
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
      $("#toserver .toServer").text(data.value);
      count = count + data.value;
      bgColor(count);
    });
    return s.on("toAll", function(data) {
      $("#data13 span.socketLog").text("socket.io toAll");
      $("#data14 span.toServer").text(data.value);
    });
  });

}).call(this);
