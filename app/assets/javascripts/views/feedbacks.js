ReviewSite = ReviewSite || {};

var activateAccordion = function() {
  $("#accordion").accordion({
    heightStyle:"content",
    active: 0,
    collapsible: true
  });

  $("#accordion").on("accordionactivate", function (event, ui) {
    if (ui.newPanel.length) {
      $.scrollTo(ui.newHeader, {offset:{top:-100}});
    }
  });

};

var warnIfUnsavedChanges = function() {
  $(".feedback-form-container").find("input, select, textarea").on("keyup", function() {
    window.onbeforeunload = function() {
      return "You have not saved your changes.";
    };

    $(".feedback-form-container").find("input, select, textarea").off("keyup");
  });
};

var previewAndSubmit = function() {
  $(".feedback-form-container").find("#save-feedback-button, #preview-and-submit-button").on("click", function() {
    window.onbeforeunload = null;
  });
};


ReviewSite.feedbacks = {
  init: function() {
    activateAccordion();
    warnIfUnsavedChanges();
    previewAndSubmit();
  }
};
