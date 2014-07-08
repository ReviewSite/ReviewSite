jQuery(function () {
    jQuery("#accordion").accordion({
      heightStyle:"content",
      active: 4,
      collapsible: true
    });

    $("#accordion").on("accordionactivate", function (event, ui) {
      if (ui.newPanel.length) {
        $.scrollTo(ui.newHeader, {offset:{top:-100}});
      }
    });

});

