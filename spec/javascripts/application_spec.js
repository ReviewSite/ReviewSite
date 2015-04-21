// sample jasmine test
describe("Foo", function() {
  it("does something", function() {
    expect(2 + 2).toBe(4);
  });
});

// sample jasmine-jquery test
describe("Bar",  function() {
  it("does a thing", function() {
    // you can keep fixtures in a separate file and use the
    // loadFixtures() function instead
    setFixtures('<button id="derp"></button>');

    var spyEvent = spyOnEvent("#derp", "click");

    $("#derp").click();

    expect("click").toHaveBeenTriggeredOn("#derp");
    expect(spyEvent).toHaveBeenTriggered();
  });
});

describe("calculateAWeekBefore", function() {
  it("calculates a date a week prior to a given date", function() {
    var calculatedDate = ReviewSite.calculateWeekBefore(new Date("2015-07-29"));

    expect(calculatedDate).toEqual(new Date("2015-07-22"));

  });
});

describe("dateFormatter", function() {
  it("formats dates", function() {
    var formattedDate = ReviewSite.formatDate(new Date("2015-07-22"));

    expect(formattedDate).toBe("2015-7-22");
  });
});





