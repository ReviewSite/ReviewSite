// sample jasmine test
describe("Foo", function() {
  it("does something", function() {
    expect(1 + 1).toBe(2);
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
