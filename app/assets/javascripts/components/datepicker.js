jQuery(function() {

  $('.datepicker').datepicker({
    todayBtn: "linked",
    daysOfWeekDisabled: "0,6",
    autoclose: true,
    todayHighlight: true,
    format: "yyyy-mm-dd"
  });

  $('.datepicker.future').datepicker("setStartDate", "today");

});
