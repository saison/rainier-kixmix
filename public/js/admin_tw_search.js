(function() {
  $(function() {
    var getSearch;
    getSearch = function() {
      return $.get("/admin/search", function(data) {
        var n, name, text;
        n = Math.floor(Math.random() * 10);
        name = data.statuses[n].user.name;
        text = data.statuses[n].text;
        $("#name").fadeOut(200, function() {
          $(this).text("");
          return $(this).delay(300).fadeIn(200, function() {
            return $(this).text(name);
          });
        });
        $("#tweet").fadeOut(200, function() {
          $(this).text("");
          return $(this).delay(300).fadeIn(200, function() {
            return $(this).text(text);
          });
        });
      });
    };
    return setInterval(getSearch, 8000);
  });

}).call(this);
