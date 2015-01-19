ReviewSite = ReviewSite || {};
ReviewSite.components = ReviewSite.components || {};

var addAdditionalEmail = function() {
  $("#add-email").on("click", function(){
    $.ajax({
      complete: function(request){},
      data: "additional_email="+ $("#new-email").val(),
      dataType: "script",
      type: "get",
      url: "add_email"
    });

    $("#new-email").val("");
  });
};

var removeAdditionalEmail = function() {
  $(document).on("click", ".remove-additional-email", function(){
    $.ajax({
      complete: function(request){},
      data: "additional_email_id="+ $(this).attr("id"),
      dataType: "script",
      type: "get",
      url: "remove_email"
    });

    var email_id = $(this).attr("id");

    $(".email-address-column#" + email_id).closest("tr").remove();
  });
};

var addEmailOnPressEnter = function() {
  $("#new-email").keypress(function (e) {
    var key = e.which;
    if(key == 13) {
        $("#add-email").click();
        return false;
    }
  });
};


ReviewSite.components.addEmail = function() {
  addAdditionalEmail();
  removeAdditionalEmail();
  addEmailOnPressEnter();
};
