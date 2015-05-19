ReviewSite = ReviewSite || {};
ReviewSite.components = ReviewSite.components || {};

var viewToSideNavMap = {
  "welcome-index" : "track-feedback",
  "reviews-show" : "track-feedback",
  "reviews-summary" : "feedback-summary",
  "invitations-new" : "ask-for-feedback",
  "self_assessments-new" : "submit-self-assessment",
  "feedbacks-new" : "record-external",
  "reviews-edit" : "review-edit"
};

var highlightCurrentLocation = function() {
  var controller = document.body.getAttribute("data-controller"),
      action = document.body.getAttribute("data-action"),
      view = controller + "-" + action;

  var navItemToHighlight = "#" + viewToSideNavMap[view];

  $(navItemToHighlight).addClass("active");
};

ReviewSite.components.sidenav = function() {
  highlightCurrentLocation();
};
