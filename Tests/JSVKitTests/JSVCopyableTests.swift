//
//  JSVCopyableTests.swift
//
//  Created by Jan Svensson on 2020-05-04.
//  Copyright © 2020 Jan Svensson. All rights reserved.
//

@testable import JSVKit
import XCTest

class Person {
    var name: String
    var age: Int
    
    init(name: String, age: Int) {
        self.name = name
        self.age = age
    }
}

extension Person: Copyable {
    typealias CopyType = Person
    func copy() -> Person {
        return Person(name: self.name, age: self.age)
    }
}

class JSVCopyableTests: XCTestCase {
    func testCopyClass() {
        
        let original = Person(name: "foo", age: 10)
        let copy = original.copy()
        
        XCTAssertEqual(original.name, copy.name)
        XCTAssertEqual(original.age, copy.age)
        
        copy.name = "bar"
        copy.age = 15
        
        XCTAssertNotEqual(original.name, copy.name)
        XCTAssertNotEqual(original.age, copy.age)
    }
}
