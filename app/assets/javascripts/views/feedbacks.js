ReviewSite = ReviewSite || {};

var activateAccordion = function() {
  $("#accordion").accordion({
    heightStyle:"content",
    active: 0,
    collapsible: false,
    create: function(event, ui) {
      _toggleFields({ commentsHeader: ui.header });
    }
  });

  $("#accordion").on("accordionactivate", function (event, ui) {
    _toggleFields({ oldHeader: ui.oldHeader, newHeader: ui.newHeader });

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

var openNextAccordionPanel = function() {
  var $accordion = $("#accordion").accordion();
  var current = $accordion.accordion("option", "active"),
      maximum = $accordion.find("h3").length,
      next = current+1 === maximum ? 0 : current+1;
  $accordion.accordion("option", "active", next);
};

var validateRequiredFields = function() {
  var projectField = $('#feedback_project_worked_on').val();
  var roleField = $('#feedback_role_description').val();
  if(!projectField || !roleField) {
    $('#accordion').accordion('activate', 0);
    _addRequiredFieldClass(['#feedback_project_worked_on', '#feedback_role_description']);
  }
};

var _addRequiredFieldClass = function(fields) {
  for(var i in fields) {
    if(!$(fields[i]).val()) {
      $(fields[i]).addClass("required-field");
    }
  }
};

var _toggleFields = function(headers) {
  for(var key in headers) {
    var headerTitle = headers[key].attr('data-heading-title');
    var headerID = "#" + headerTitle;
    $(headerID).toggleClass("hidden");

    if(headerTitle === "contributions") {
      $("a#continue-button").toggleClass("disabled");
    }
  }
};

ReviewSite.feedbacks = {
  init: function() {
    activateAccordion();
    warnIfUnsavedChanges();
    previewAndSubmit();
  }
};
