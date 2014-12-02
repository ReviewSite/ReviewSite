var ler;
jQuery(function () {
  jQuery("#accordion").accordion({
    heightStyle:"content",
    active: 4,
    collapsible: true
  });

    $('.feedback-form-container').find('input, select, textarea').on("keyup", function() {
    window.onbeforeunload = function() {
      return "You have not saved your changes.";
    };
    $('.feedback-form-container').find('input, select, textarea').off('keyup');
  });

  $('.feedback-form-container').find('#save-feedback-button, #submit-final-button').on('click', function() {
    window.onbeforeunload = null;
  });

  $("#accordion").on("accordionactivate", function (event, ui) {
    if (ui.newPanel.length) {
      $.scrollTo(ui.newHeader, {offset:{top:-100}});
    }
  });
});
