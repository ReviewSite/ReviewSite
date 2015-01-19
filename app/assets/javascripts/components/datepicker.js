ReviewSite = ReviewSite || {};
ReviewSite.components = ReviewSite.components || {};

var setupDefaultDatepicker = function() {
  $(".datepicker").datepicker({
    todayBtn: "linked",
    daysOfWeekDisabled: "0,6",
    autoclose: true,
    todayHighlight: true,
    format: "yyyy-mm-dd"
  });

  $(".datepicker.future").datepicker("setStartDate", "today");
};


ReviewSite.components.datepicker = function() {
  setupDefaultDatepicker();
};
