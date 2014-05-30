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

  $('.jc_with_autocomplete').autocomplete({
    minLength: 2,
    source: function(request, response) {
      $.ajax({
          url: $('.jc_with_autocomplete').data('autocompleteurl'),
          dataType: "json",
          data: {
            name: request.term
          },
          success: function(data) {
            response(data)
            }});
          }
      });

  $('.coach_with_autocomplete').autocomplete({
    minLength: 2,
    source: function(request, response) {
      $.ajax({
        url: $('.coach_with_autocomplete').data('autocompleteurl'),
        dataType: "json",
        data: {
          name: request.term
        },
        success: function(data) {
          response(data)
        }});
    }
  });
});
