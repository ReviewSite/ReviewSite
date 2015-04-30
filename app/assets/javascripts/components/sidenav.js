ReviewSite = ReviewSite || {};
ReviewSite.components = ReviewSite.components || {};

var highlightCurrentLocation = function() {
  var titleId = $('h1').attr('id');
  var selector = '#' + titleId;
  $(".sidenav " + selector).addClass("active");
};

ReviewSite.components.sidenav = function() {
  highlightCurrentLocation();
};
