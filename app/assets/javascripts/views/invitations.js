ReviewSite = ReviewSite || {};

var slideEmailBody = function () {
    $("#no_email").click(function () {
        $("#email_contents").slideToggle();

        if ($("#no_email").is(":checked")) {
            $("#copy_sender").prop("checked", false);
        }
    });
};

var tokenizeEmailsToField = function () {
    $("#emails").tokenize({
        autosize: true,
        searchMinLength: Number.MAX_SAFE_INTEGER-1,
        searchMaxLength: Number.MAX_SAFE_INTEGER
    });
};

ReviewSite.invitations = {
    init: function () {
        slideEmailBody();
        tokenizeEmailsToField();
    }
};

