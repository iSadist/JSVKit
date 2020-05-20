@testable import JSVKit
import XCTest

class Boundable: XCTestCase {
    func testNumberWithinBounds() {
        let number: CGFloat = 5
        let boundedNumber = number.interval(1, 10)
        
        XCTAssertEqual(boundedNumber, 5)
    }
    
    func testNumberAboveBounds() {
        let number: CGFloat = 55
        let boundedNumber = number.interval(1, 10)
        
        XCTAssertEqual(boundedNumber, 10)
    }
    
    func testNumberBelowBounds() {
        let number: CGFloat = 3
        let boundedNumber = number.interval(5, 10)
        
        XCTAssertEqual(boundedNumber, 5)
    }
    
    func testNumberSlightlyAboveBounds() {
        let number: CGFloat = 10.1
        let boundedNumber = number.interval(1, 10)
        
        XCTAssertEqual(boundedNumber, 10)
    }
    
    func testNumberSlightlyBelowBounds() {
        let number: CGFloat = 0.9999
        let boundedNumber = number.interval(1, 10)
        
        XCTAssertEqual(boundedNumber, 1)
    }
    
    func testNumberCloseToLowerBound() {
        let number: CGFloat = 1.001
        let boundedNumber = number.interval(1, 10)
        
        XCTAssertEqual(boundedNumber, 1.001)
    }
    
    func testNumberCloseToUpperBound() {
        let number: CGFloat = 99.99
        let boundedNumber = number.interval(1, 100)
        
        XCTAssertEqual(boundedNumber, 99.99)
    }
    
    func testNumberWithinNegativeBounds() {
        let number: CGFloat = -5
        let boundedNumber = number.interval(-10, -1)
        
        XCTAssertEqual(boundedNumber, -5)
    }
    
    func testBoundsAcrossZero_NumberPositive() {
        let number: CGFloat = 5
        let boundedNumber = number.interval(-100, 100)
        
        XCTAssertEqual(boundedNumber, 5)
    }
    
    func testBoundsAcrossZero_NumberNegative() {
        let number: CGFloat = -7
        let boundedNumber = number.interval(-100, 100)
        
        XCTAssertEqual(boundedNumber, -7)
    }
}
