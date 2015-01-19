ReviewSite = ReviewSite || {};
ReviewSite.components = ReviewSite.components || {};

var setupTooltips = function() {
  $( document ).tooltip({
    position: {
      my: "middle top",
      at: "middle bottom+15"
    },

    show: {
      duration: 100
    },

    hide: {
      duration: 100
    },

    open: function(event, ui) {
      ui.tooltip.prepend("<div class='tooltip-arrow'></div>");
    }
  });
};


ReviewSite.components.tooltips = function() {
  setupTooltips();
};
