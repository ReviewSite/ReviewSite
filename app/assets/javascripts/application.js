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
//= require_tree .
//= require bootstrap-datepicker/core
//= require jquery.tokeninput
//= require scrollspy
//


jQuery (function () {
  $('.datepicker').datepicker({
    todayBtn: "linked",
    daysOfWeekDisabled: "0,6",
    autoclose: true,
    todayHighlight: true,
    format: "yyyy-mm-dd"
  });

  $('.datepicker.future').datepicker("setStartDate", "today");

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

  var enableGraduatedCheckbox = function() {
    $("#user_associate_consultant_attributes_graduated").removeAttr("disabled");
    $('[name="user[associate_consultant_attributes][graduated]"][type="hidden"]').removeAttr("disabled");
  }

  var disableGraduatedCheckbox = function() {
    $("#user_associate_consultant_attributes_graduated").attr("disabled", "disabled");
    $('[name="user[associate_consultant_attributes][graduated]"][type="hidden"]').attr("disabled", "disabled");
  }

  if ($("#isac").length && $("#isac")[0].checked) {
    $(".nested-form-container").show();
    enableGraduatedCheckbox();
  } else {
    $(".nested-form-container").hide();
  }

  $("#isac").on('change', function() {
    $(".nested-form-container").toggle();
    if ($("#isac").length && $("#isac")[0].checked) {
      enableGraduatedCheckbox();
    } else {
      disableGraduatedCheckbox();
    }
  });

  $("#por-why").on('click', function() {
    $("#which-reviews").toggle();
  });

  $('.sidenav a[href^="' + location.pathname + '"]').first().parent().addClass("active");

  $("#add-email").on("click", function(){
    $.ajax({
      complete:function(request){},
      data:'additional_email='+ $('#new-email').val(),
      dataType:'script',
      type:'get',
      url: 'add_email'
    });

    $("#new-email").val('');
  });

  $(document).on("click", ".remove-additional-email", function(){
    $.ajax({
      complete:function(request){},
      data:'additional_email_id='+ $(this).attr('id'),
      dataType:'script',
      type:'get',
      url: 'remove_email'
    });

    var email_id = $(this).attr('id');

    $(".email-address-column#"+email_id).closest('tr').remove();
  });

  $(".edit-additional-email").on("click", function() {
    $(this).closest('td').html();
  });
});
