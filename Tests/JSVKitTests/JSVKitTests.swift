import XCTest
@testable import JSVKit

final class JSVKitTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(JSVKit().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
