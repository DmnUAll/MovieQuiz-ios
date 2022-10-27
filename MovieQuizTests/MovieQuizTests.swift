//
//  MovieQuizTests.swift
//  MovieQuizTests
//
//  Created by Илья Валито on 27.10.2022.
//

import XCTest

struct ArithmeticOperations {
    // Synchronous
    func addition(num1: Int, num2: Int) -> Int {
        return num1 + num2
    }
    
    // Asynchronous
    func subtraction(num1: Int, num2: Int, handler: @escaping (Int) -> Void) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                handler(num1 - num2)
            }
        }
    
    func multiplication(num1: Int, num2: Int) -> Int {
        return num1 * num2
    }
}

final class MovieQuizTests: XCTestCase {
    
    // Synchronous
    func testAddition() throws {
        
        // Given
        let arithmeticOperations = ArithmeticOperations()
        let num1 = 1
        let num2 = 2
        
        // When
        let result = arithmeticOperations.addition(num1: num1, num2: num2)
        
        // Then
        XCTAssertEqual(result, 3)
    }
    
    // Asynchronous
    func testSubtraction() throws {
        
        // Given
        let arithmeticOperations = ArithmeticOperations()
        let num1 = 2
        let num2 = 1
        
        // When
        let expectation = expectation(description: "Addition function expectation")
       
       arithmeticOperations.subtraction(num1: num1, num2: num2) { result in
            // Then
            XCTAssertEqual(result, 1)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2)
    }
}
