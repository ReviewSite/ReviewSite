ReviewSite = ReviewSite || {};
ReviewSite.components = ReviewSite.components || {};

var enableGraduatedCheckbox = function() {
  $("#user_associate_consultant_attributes_graduated").removeAttr("disabled");

  $("[name='user[associate_consultant_attributes][graduated]'][type='hidden']").removeAttr("disabled");
};

var disableGraduatedCheckbox = function() {
  $("#user_associate_consultant_attributes_graduated")
      .attr("disabled", "disabled");

  $("[name='user[associate_consultant_attributes][graduated]'][type='hidden']").attr("disabled", "disabled");
};

var showNestedFormOnPageLoad = function() {
  if ($("#isac").length && $("#isac")[0].checked) {
    $(".nested-form-container").show();
    enableGraduatedCheckbox();
  } else {
    $(".nested-form-container").hide();
  }
};

var showNestedFormOnChange = function() {
  $("#isac").on("change", function() {
    $(".nested-form-container").toggle();

    if ($("#isac").length && $("#isac")[0].checked) {
      enableGraduatedCheckbox();
    } else {
      disableGraduatedCheckbox();
    }
  });
};


ReviewSite.components.ac = function() {
  showNestedFormOnPageLoad();
  showNestedFormOnChange();
};
