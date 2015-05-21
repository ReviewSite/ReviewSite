ReviewSite = ReviewSite || {};
ReviewSite.components = ReviewSite.components || {};

var users = function() {
  $("table#users").DataTable({
    pagingType: "full",
    lengthChange: false,
    language: {
      infoFiltered: "",
      search: "",
      searchPlaceholder: "Search for a user by name or email"
    },
    columnDefs: [
      { orderable: false, targets: [ 2 ] },
      { className: "nowrap button-col", targets: [2] }
    ],
    createdRow: function(row, data, dataIndex){
      var email = data[1];
      $(row).attr("id", email.substr(0, email.indexOf("@")));
    }
  });
};

var feedbackRequests = function() {
  $("#feedback-requests").DataTable({
    paging: false,
    info: false,
    searching: false,
    lengthChange: false,
    columnDefs: [
      { orderable: false, targets: [4] }
    ]
  });
};

var feedbackSeenByAC = function() {
  $("#feedback-received").DataTable({
    columnDefs: [
      { orderable: false, targets: [5] }
    ],
    paging: false,
    lengthChange: false,
    searching: false,
    info: false
  });
};

var completedFeedback = function() {
  $("#completeds").DataTable({
    paging: false,
    info: false,
    searching: false,
    lengthChange: false,
    columnDefs: [
      { orderable: false, targets: [4] }
    ]
  });
};

var reviewsSeenByAC = function() {
  $("#my-reviews").DataTable({
    lengthChange: false,
    searching: false,
    columnDefs: [
      { orderData: [ 1 ], targets: [ 0 ] },
      { orderable: false, targets: [ 2 ] },
      { className: "nowrap", targets: [ 0 ] },
      { className: "nowrap button-col", targets: [ 2 ] }
    ]
  });
};

var reviewsSeenByWatchers = function() {
  $("#reviews").DataTable({
    pagingType: "full",
    lengthChange: false,
    language: {
      infoFiltered: "",
      search: "",
      searchPlaceholder: "Search for a review by AC or date"
    },
    columnDefs: [
      { orderable: false, targets: [ 3 ] },
      { className: "nowrap", targets: [ 0 ] },
      { className: "nowrap button-col", targets: [ 3 ] }
    ]
  });
};

var reviewingGroups = function() {
  $("#reviewing-groups").DataTable({
    info: false,
    paging: false,
    columnDefs: [
      { orderable: false, targets: [2] }
    ],
    lengthChange: false,
    searching: false
  });
};

ReviewSite.components.datatables = function() {
  users();
  feedbackRequests();
  feedbackSeenByAC();
  completedFeedback();
  reviewsSeenByAC();
  reviewsSeenByWatchers();
  reviewingGroups();
}
