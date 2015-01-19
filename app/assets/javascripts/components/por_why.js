ReviewSite = ReviewSite || {};
ReviewSite.components = ReviewSite.components || {};

ReviewSite.components.whichReviews = function() {
  $("#por-why").on("click", function() {
    $("#which-reviews").toggle();
  });
}
