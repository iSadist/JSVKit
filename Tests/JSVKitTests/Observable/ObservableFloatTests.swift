@testable import JSVKit
import XCTest

class ObservableFloatTests: XCTestCase {

    var observable: Observable<Float>!
    var handlerWasCalled = false
    var handlerWasCalledTimes = 0

    override func setUp() {
        observable = Observable<Float>(value: 0.0)
    }

    override func tearDown() {
        observable.value = nil
        observable = nil
    }
    
    func testSetOriginalValue() {
        XCTAssertEqual(observable.value, 0.0)
    }
    
    func testListeningToChanges() {
        observable.listen(self) { (_) in
            self.handlerWasCalled = true
            self.handlerWasCalledTimes += 1
        }
        
        observable.value = 10.5

        XCTAssertTrue(handlerWasCalled)
        XCTAssertEqual(handlerWasCalledTimes, 1)
        XCTAssertEqual(observable.value, 10.5)
    }
    
    func testChangeHandler() {
        observable.valueChanged = { [weak self] newValue in
            self?.handlerWasCalled = true
            self?.handlerWasCalledTimes += 1
        }
        
        observable.value = 151.0

        XCTAssertTrue(handlerWasCalled)
        XCTAssertEqual(observable.value, 151.0)
        XCTAssertEqual(handlerWasCalledTimes, 1)
    }
    
    func testStopListening() {
        let handler = { (value: Float?) in
            self.handlerWasCalled = true
            self.handlerWasCalledTimes += 1
        }
        
        observable.listen(self, handler: handler)
        observable.value = -10.1

        XCTAssertTrue(handlerWasCalled)
        XCTAssertEqual(handlerWasCalledTimes, 1)
        XCTAssertEqual(observable.value, -10.1)
        
        observable.stopListening(self, handler: handler)
        handlerWasCalled = false
        observable.value = -10.5
        
        XCTAssertFalse(handlerWasCalled)
        XCTAssertEqual(handlerWasCalledTimes, 1)
        XCTAssertEqual(observable.value, -10.5)
    }
}
