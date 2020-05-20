@testable import JSVKit
import XCTest

class ObservableTupleTests: XCTestCase {

    var observable: Observable<(Int, String)>!
    var handlerWasCalled = false
    var handlerWasCalledTimes = 0

    override func setUp() {
        observable = Observable<(Int, String)>(value: (0, "test"))
    }

    override func tearDown() {
        observable.value = nil
        observable = nil
    }
    
    func testSetOriginalValueInt() {
        XCTAssertEqual(observable.value?.0, 0)
        XCTAssertEqual(observable.value?.1, "test")
    }
    
    func testListeningToChanges() {
        observable.listen(self) { (_) in
            self.handlerWasCalled = true
            self.handlerWasCalledTimes += 1
        }
        
        observable.value = (1, "test-1")

        XCTAssertTrue(handlerWasCalled)
        XCTAssertEqual(handlerWasCalledTimes, 1)
        XCTAssertEqual(observable.value?.0, 1)
        XCTAssertEqual(observable.value?.1, "test-1")
    }
    
    func testChangeHandler() {
        observable.valueChanged = { [weak self] newValue in
            self?.handlerWasCalled = true
            self?.handlerWasCalledTimes += 1
        }
        
        observable.value = (2, "testing")

        XCTAssertTrue(handlerWasCalled)
        XCTAssertEqual(handlerWasCalledTimes, 1)
        XCTAssertEqual(observable.value?.0, 2)
        XCTAssertEqual(observable.value?.1, "testing")
    }
    
    func testStopListening() {
        let handler = { (value: (Int, String)?) in
            self.handlerWasCalled = true
            self.handlerWasCalledTimes += 1
        }
        
        observable.listen(self, handler: handler)
        observable.value = (3, "testtest")

        XCTAssertTrue(handlerWasCalled)
        XCTAssertEqual(handlerWasCalledTimes, 1)
        XCTAssertEqual(observable.value?.0, 3)
        XCTAssertEqual(observable.value?.1, "testtest")
        
        observable.stopListening(self, handler: handler)
        handlerWasCalled = false
        observable.value = (4, "t-e-s-t")
        
        XCTAssertFalse(handlerWasCalled)
        XCTAssertEqual(handlerWasCalledTimes, 1)
        XCTAssertEqual(observable.value?.0, 4)
        XCTAssertEqual(observable.value?.1, "t-e-s-t")
    }
}
