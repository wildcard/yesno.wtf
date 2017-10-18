import XCTest
@testable import yesno_wtf

class yesno_wtfTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(yesno_wtf().text, "Hello, World!")
    }


    static var allTests = [
        ("testExample", testExample),
    ]
}
