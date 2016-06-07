ReviewSite = ReviewSite || {};

var activateAccordion = function () {
    $("#accordion").accordion({
        heightStyle: "content",
        active: 0,
        collapsible: false,
        create: function (event, ui) {
            _toggleFields({commentsHeader: ui.header});
        }
    });

    $("#accordion").on("accordionactivate", function (event, ui) {
        _toggleFields({oldHeader: ui.oldHeader, newHeader: ui.newHeader});
    });
};

var warnIfUnsavedChanges = function () {
    $(".feedback-form-container").find("input, select, textarea").on("keyup", function () {
        window.onbeforeunload = function () {
            return "You have not saved your changes.";
        };

        $(".feedback-form-container").find("input, select, textarea").off("keyup");
    });
};

var previewAndSubmit = function () {
    $(".feedback-form-container").find("#save-feedback-button, #preview-and-submit-button").on("click", function () {
        window.onbeforeunload = null;
    });
};

var openNextAccordionPanel = function () {
    var $accordion = $("#accordion").accordion();
    var current = $accordion.accordion("option", "active"),
        maximum = $accordion.find("h3").length,
        next = current + 1 === maximum ? 0 : current + 1;
    $accordion.accordion("option", "active", next);
};

var validateAllRequired = function(showErrors) {
    var valid = validateRequiredFields(showErrors) && validateOneOfManyRequiredFields(showErrors);
    if (valid) {
        $("#preview-and-submit-button").removeClass('diet').addClass('success');
    } else {
        $("#preview-and-submit-button").removeClass('success').addClass('diet');
    }
    return valid;
};

var validateRequiredFields = function(showErrors) {
    var valid = true;

    $('.required').each(function() {
        var value = $(this).val().trim();
        if (!value && value.length <= 0) {
            valid = false;
            if (showErrors) {
                $(this).addClass('required-error');
            }
        }
    });

    return valid;
};

var validateOneOfManyRequiredFields = function(showErrors) {
    var valid = false;

    var oneOfManyRequired = $('.one-of-many-required');

    oneOfManyRequired.each(function () {
        var value = $(this).val().trim();
        if (value && value.length > 0) {
            valid = true;
        }
    });

    if (!valid && showErrors) {
        oneOfManyRequired.each(function() {
            $(this).addClass('required-error');
        });
    }

    return valid;
};

var setupRequiredErrorHandler = function() {
    $('.required').bind('change keyup input', function() {
        $(this).removeClass('required-error');
        validateAllRequired(false);
    });

    $('.one-of-many-required').bind('change keyup input', function() {
        $('.one-of-many-required').removeClass('required-error');
        validateAllRequired(false);
    });
};

var _addRequiredFieldClass = function (fields) {
    for (var i in fields) {
        if (!$(fields[i]).val()) {
            $(fields[i]).addClass("required-field");
        }
    }
};

var _toggleFields = function (headers) {
    for (var key in headers) {
        var headerTitle = headers[key].attr('data-heading-title');
        var headerID = "#" + headerTitle;
        $(headerID).toggleClass("hidden");

        if (headerTitle === "contributions") {
            $("a#continue-button").toggleClass("disabled");
        }
    }
};

ReviewSite.feedbacks = {
    init: function () {
        activateAccordion();
        warnIfUnsavedChanges();
        previewAndSubmit();
        setupRequiredErrorHandler();
    }
};
