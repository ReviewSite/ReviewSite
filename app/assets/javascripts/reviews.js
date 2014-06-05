jQuery(function () {
  $('.datepicker').datepicker({
    startDate: "today",
    todayBtn: "linked",
    daysOfWeekDisabled: "0,6",
    autoclose: true,
    todayHighlight: true,
    format: "yyyy-mm-dd"
  });

  $('.send_email_link').click(function() {
    $(this).text("Sent").addClass('improvement_text');
  });


});
