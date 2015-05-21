ReviewSite = ReviewSite || {};

var slideEmailBody = function() {
  $("#no_email").click(function() {
    $("#email_contents").slideToggle();

    if ($("#no_email").is(":checked")) {
      $("#copy_sender").prop("checked", false);
    }
  });
};

ReviewSite.invitations = {
  init: function() {
    slideEmailBody();
  }
};
