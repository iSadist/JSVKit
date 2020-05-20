@testable import JSVKit
import XCTest

class ObservableBoolTests: XCTestCase {

    var observable: Observable<Bool>!
    var handlerWasCalled = false
    var handlerWasCalledTimes = 0

    override func setUp() {
        observable = Observable<Bool>(value: false)
    }

    override func tearDown() {
        observable.value = nil
        observable = nil
    }
    
    func testSetOriginalValue() {
        XCTAssertEqual(observable.value, false)
    }
    
    func testListeningToChanges() {
        observable.listen(self) { (_) in
            self.handlerWasCalled = true
            self.handlerWasCalledTimes += 1
        }
        
        observable.value = true

        XCTAssertTrue(handlerWasCalled)
        XCTAssertEqual(handlerWasCalledTimes, 1)
        XCTAssertEqual(observable.value, true)
    }
    
    func testChangeHandler() {
        observable.valueChanged = { [weak self] newValue in
            self?.handlerWasCalled = true
            self?.handlerWasCalledTimes += 1
        }
        
        observable.value = true

        XCTAssertTrue(handlerWasCalled)
        XCTAssertEqual(observable.value, true)
        XCTAssertEqual(handlerWasCalledTimes, 1)
    }
    
    func testStopListening() {
        let handler = { (value: Bool?) in
            self.handlerWasCalled = true
            self.handlerWasCalledTimes += 1
        }
        
        observable.listen(self, handler: handler)
        observable.value = true

        XCTAssertTrue(handlerWasCalled)
        XCTAssertEqual(handlerWasCalledTimes, 1)
        XCTAssertEqual(observable.value, true)
        
        observable.stopListening(self, handler: handler)
        handlerWasCalled = false
        observable.value = false
        
        XCTAssertFalse(handlerWasCalled)
        XCTAssertEqual(handlerWasCalledTimes, 1)
        XCTAssertEqual(observable.value, false)
    }
}
