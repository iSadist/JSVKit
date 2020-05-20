@testable import JSVKit
import XCTest

class JSVCallStackTests: XCTestCase {
    
    var callstack: JSVCallStack!

    override func setUp() {
        callstack = JSVCallStack()
    }

    override func tearDown() {
        
    }

    func testSingleCall() {
        var variableToBeChanged = 0
        callstack.maximumCalls = 1
        let exp = expectation(description: "Finish the call")
        
        callstack.addToStack(method: {
            variableToBeChanged = 1
            self.callstack.jobWasFinished()
            exp.fulfill()
        }, queue: .main)
        
        XCTAssertEqual(variableToBeChanged, 0)
        
        let res = XCTWaiter.wait(for: [exp], timeout: 1)
        
        XCTAssertEqual(res, .completed)
        XCTAssertEqual(variableToBeChanged, 1)
    }
    
    func testMultipleCallsSync() {
        var variableToBeChanged = 0
        callstack.maximumCalls = 1
        let firstCallExp = expectation(description: "Finish the first call")
        let secondCallExp = expectation(description: "Finish the second call")
        
        callstack.addToStack(method: {
            variableToBeChanged += 1
            self.callstack.jobWasFinished()
            firstCallExp.fulfill()
        }, queue: .main)
        
        callstack.addToStack(method: {
            variableToBeChanged += 1
            self.callstack.jobWasFinished()
            secondCallExp.fulfill()
        }, queue: .main)
        
        XCTAssertEqual(variableToBeChanged, 0)
        
        let firstRes = XCTWaiter.wait(for: [firstCallExp], timeout: 1)
        
        XCTAssertEqual(firstRes, .completed)
        XCTAssertEqual(variableToBeChanged, 1)
        
        let secondRes = XCTWaiter.wait(for: [secondCallExp], timeout: 1)
        
        XCTAssertEqual(secondRes, .completed)
        XCTAssertEqual(variableToBeChanged, 2)
    }
    
    func testMultipleCallsAsync() {
        self.measure {
            var variableToBeChanged = 0
            callstack.maximumCalls = 2
            let firstCallExp = expectation(description: "Finish the first call")
            let secondCallExp = expectation(description: "Finish the second call")
            
            callstack.addToStack(method: {
                variableToBeChanged += 1
                self.callstack.jobWasFinished()
                firstCallExp.fulfill()
            }, queue: .main)
            
            callstack.addToStack(method: {
                variableToBeChanged += 1
                self.callstack.jobWasFinished()
                secondCallExp.fulfill()
            }, queue: .main)
            
            XCTAssertEqual(variableToBeChanged, 0)
            
            let firstRes = XCTWaiter.wait(for: [firstCallExp], timeout: 1)
            
            XCTAssertEqual(firstRes, .completed)
            XCTAssertEqual(variableToBeChanged, 2)
            
            let secondRes = XCTWaiter.wait(for: [secondCallExp], timeout: 1)
            
            XCTAssertEqual(secondRes, .completed)
            XCTAssertEqual(variableToBeChanged, 2)
        }
    }

    func testPerformanceExample() {
        self.measure {
            var variableToBeChanged = 0
            callstack.maximumCalls = 1
            let firstCallExp = expectation(description: "Finish the first call")
            let secondCallExp = expectation(description: "Finish the second call")
            
            callstack.addToStack(method: {
                variableToBeChanged += 1
                self.callstack.jobWasFinished()
                firstCallExp.fulfill()
            }, queue: .main)
            
            callstack.addToStack(method: {
                variableToBeChanged += 1
                self.callstack.jobWasFinished()
                secondCallExp.fulfill()
            }, queue: .main)
            
            XCTAssertEqual(variableToBeChanged, 0)
            
            let firstRes = XCTWaiter.wait(for: [firstCallExp], timeout: 1)
            
            XCTAssertEqual(firstRes, .completed)
            XCTAssertEqual(variableToBeChanged, 1)
            
            let secondRes = XCTWaiter.wait(for: [secondCallExp], timeout: 1)
            
            XCTAssertEqual(secondRes, .completed)
            XCTAssertEqual(variableToBeChanged, 2)
        }
    }

}
