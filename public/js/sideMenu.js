$(function(){
  var menuFlg = false;
  $("#open").click(function(){
    if (menuFlg) {
      $("#sideMenu").stop().animate({"left":"-250px"},500,"easeOutSine");
      menuFlg = false;
      $("#open").removeClass('active');
    } else {
      $("#sideMenu").stop().animate({"left":"0px"},500,"easeOutSine");
      menuFlg = true;
      $("#open").addClass('active');
    }
  });
});
