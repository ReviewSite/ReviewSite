ReviewSite = ReviewSite || {};

var updateFeedbackDeadline = function() {
  $("#new_review #review_review_date").change(function() {
    var date = new Date( $("#review_review_date").val() );
    var weekAgoDate = ReviewSite.calculateWeekBefore(date);
    var weekAgoDateString = ReviewSite.formatDate(weekAgoDate);
    $("#review_feedback_deadline").val( weekAgoDateString );
  });
};

ReviewSite.reviews = {
  init: function () {
    updateFeedbackDeadline();
  }
};

ReviewSite.calculateWeekBefore = function(date) {
  var dayInMs = 24 * 60 * 60 * 1000;
  return new Date( date - 7 * dayInMs);
};

ReviewSite.formatDate = function(date) {
  return date.getUTCFullYear() + "-" + 
        (date.getUTCMonth() + 1) + "-" + // JS months are 0-indexed :(
        date.getUTCDate();
};