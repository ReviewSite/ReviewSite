ReviewSite = ReviewSite || {};
ReviewSite.components = ReviewSite.components || {};

var highlightCurrentLocation = function() {
  $(".sidenav a[href^='" + location.pathname + "']").first().addClass("active");
};


ReviewSite.components.sidenav = function() {
  highlightCurrentLocation();
};
