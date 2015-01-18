jQuery(function() {
  $('.sidenav a[href^="' + location.pathname + '"]').first().addClass("active");
});
