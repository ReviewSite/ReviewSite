// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require dataTables/jquery.dataTables
//= require bootstrap
//= require_tree .
//= require bootstrap-datepicker/core
//= require jquery.tokeninput
//= require scrollspy
//


jQuery (function () {
  $("#reviewing_group_user_tokens").tokenInput("/users/get_users.json", {
    crossDomain: false,
    prePopulate: $("#reviewing_group_user_tokens").data("pre"),
    preventDuplicates: true
  });

  $("#review_associate_consultant_id").tokenInput("/associate_consultants.json", {
    crossDomain: false,
    prePopulate: $("#review_associate_consultant_id").data("pre"),
    tokenLimit: 1
  });

  $("#user_associate_consultant_attributes_coach_id").tokenInput("/users/get_users.json", {
    crossDomain: false,
    prePopulate: $("#user_associate_consultant_attributes_coach_id").data("pre"),
    tokenLimit: 1
  });

  if ($("#isac").length && $("#isac")[0].checked) {
    $(".fields").show();
  } else {
    $(".fields").hide();
  }

  $("#isac").on('change', function() {
    $(".fields").toggle();
  });

  $("#por-why").on('click', function() {
    $("#which-reviews").toggle();
  });


});
