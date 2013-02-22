jQuery(function () {
    jQuery("#accordion").accordion({
        heightStyle:"content"
    });

    $("#accordion").on("accordionactivate", function (event, ui) {
        $.scrollTo(ui.newHeader, {offset:{top:-100}});
    });

});

