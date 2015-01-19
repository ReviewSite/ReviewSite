ReviewSite = ReviewSite || {};
ReviewSite.components = ReviewSite.components || {};

var setupReviewingGroupInput = function() {
  $("#reviewing_group_user_tokens").tokenInput("/users/get_users.json", {
    crossDomain: false,
    prePopulate: $("#reviewing_group_user_tokens").data("pre"),
    preventDuplicates: true
  });
};

var setupAssociateConsultantInput = function() {
  $("#review_associate_consultant_id").tokenInput("/associate_consultants.json", {
    crossDomain: false,
    prePopulate: $("#review_associate_consultant_id").data("pre"),
    tokenLimit: 1
  });
};

var setupCoachInput = function() {
  $("#user_associate_consultant_attributes_coach_id").tokenInput("/users/get_users.json", {
    crossDomain: false,
    prePopulate: $("#user_associate_consultant_attributes_coach_id").data("pre"),
    tokenLimit: 1
  });
};


ReviewSite.components.tokenInput = function() {
  setupReviewingGroupInput();
  setupAssociateConsultantInput();
  setupCoachInput();
};
