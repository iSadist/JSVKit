@testable import JSVKit
import XCTest

class ObservableIntTests: XCTestCase {

    var observable: Observable<Int>!
    var handlerWasCalled = false
    var handlerWasCalledTimes = 0

    override func setUp() {
        observable = Observable<Int>(value: 0)
    }

    override func tearDown() {
        observable.value = nil
        observable = nil
    }
    
    func testSetOriginalValue() {
        XCTAssertEqual(observable.value, 0)
    }
    
    func testListeningToChanges() {
        observable.listen(self) { (_) in
            self.handlerWasCalled = true
            self.handlerWasCalledTimes += 1
        }
        
        observable.value = 9

        XCTAssertTrue(handlerWasCalled)
        XCTAssertEqual(handlerWasCalledTimes, 1)
        XCTAssertEqual(observable.value, 9)
    }
    
    func testChangeHandler() {
        observable.valueChanged = { [weak self] newValue in
            self?.handlerWasCalled = true
            self?.handlerWasCalledTimes += 1
        }
        
        observable.value = 99

        XCTAssertTrue(handlerWasCalled)
        XCTAssertEqual(observable.value, 99)
        XCTAssertEqual(handlerWasCalledTimes, 1)
    }
    
    func testStopListening() {
        let handler = { (value: Int?) in
            self.handlerWasCalled = true
            self.handlerWasCalledTimes += 1
        }
        
        observable.listen(self, handler: handler)
        observable.value = -50

        XCTAssertTrue(handlerWasCalled)
        XCTAssertEqual(handlerWasCalledTimes, 1)
        XCTAssertEqual(observable.value, -50)
        
        observable.stopListening(self, handler: handler)
        handlerWasCalled = false
        observable.value = -50
        
        XCTAssertFalse(handlerWasCalled)
        XCTAssertEqual(handlerWasCalledTimes, 1)
        XCTAssertEqual(observable.value, -50)
    }
}
