ReviewSite = ReviewSite || {};
ReviewSite.components = ReviewSite.components || {};

var viewToSideNavMap = {
  "welcome-index" : "track-feedback",
  "reviews-show" : "track-feedback",
  "reviews-summary" : "feedback-summary",
  "invitations-create" : "ask-for-feedback",
  "invitations-new" : "ask-for-feedback",
  "self_assessments-create" : "submit-self-assessment",
  "self_assessments-new" : "submit-self-assessment",
  "self_assessments-update" : "submit-self-assessment",
  "self_assessments-edit" : "submit-self-assessment",
  "feedbacks-new" : "record-external",
  "reviews-update" : "review-edit",
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
