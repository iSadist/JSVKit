@testable import JSVKit
import XCTest

class ObservableStringTests: XCTestCase {
    
    var observable: Observable<String>!
    var handlerWasCalled = false
    var handlerWasCalledTimes = 0

    override func setUp() {
        observable = Observable<String>(value: "test-string")
    }

    override func tearDown() {
        observable.value = nil
        observable = nil
        handlerWasCalled = false
        handlerWasCalledTimes = 0
    }

    func testSetOriginalValue() {
        XCTAssertEqual(observable.value, "test-string")
    }
    
    func testSetNewValue() {
        observable?.value = "new-value"
        XCTAssertEqual(observable?.value, "new-value")
    }
    
    func testListeningToChanges() {
        observable.listen(self) { (_) in
            self.handlerWasCalled = true
            self.handlerWasCalledTimes += 1
        }
        
        observable.value = "new-test-value"

        XCTAssertTrue(handlerWasCalled)
        XCTAssertEqual(handlerWasCalledTimes, 1)
        XCTAssertEqual(observable.value, "new-test-value")
    }
    
    func testChangeHandler() {
        observable.valueChanged = { [weak self] newValue in
            self?.handlerWasCalled = true
            self?.handlerWasCalledTimes += 1
        }
        
        observable.value = "new-test-value"

        XCTAssertTrue(handlerWasCalled)
        XCTAssertEqual(observable.value, "new-test-value")
        XCTAssertEqual(handlerWasCalledTimes, 1)
    }
    
    func testStopListening() {
        let handler = { (value: String?) in
            self.handlerWasCalled = true
            self.handlerWasCalledTimes += 1
        }
        
        observable.listen(self, handler: handler)
        observable.value = "new-test-value"

        XCTAssertTrue(handlerWasCalled)
        XCTAssertEqual(handlerWasCalledTimes, 1)
        XCTAssertEqual(observable.value, "new-test-value")
        
        observable.stopListening(self, handler: handler)
        handlerWasCalled = false
        observable.value = "final-test-value"
        
        XCTAssertFalse(handlerWasCalled)
        XCTAssertEqual(handlerWasCalledTimes, 1)
        XCTAssertEqual(observable.value, "final-test-value")
    }
}
