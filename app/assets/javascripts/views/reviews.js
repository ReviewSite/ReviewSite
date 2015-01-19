ReviewSite = ReviewSite || {};

var updateFeedbackDeadline = function() {
  $("#review_review_date").change(function() {
    var date = new Date( $("#review_review_date").val() );
    var dayInMs = 24 * 60 * 60 * 1000;
    var weekAgo = new Date( date - 7 * dayInMs);
    var weekAgoDateString =
      weekAgo.getUTCFullYear() + "-" +
      (weekAgo.getUTCMonth() + 1) + "-" + // JS months are 0-indexed :(
      weekAgo.getUTCDate();

    $("#review_feedback_deadline").val( weekAgoDateString );
  });
};


ReviewSite.reviews = {
  init: function () {
    updateFeedbackDeadline();
  }
};
