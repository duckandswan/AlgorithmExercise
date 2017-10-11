//
//  AlgorithmExerciseTests.swift
//  AlgorithmExerciseTests
//
//  Created by Song Bo on 13/09/2017.
//  Copyright © 2017 Song Bo. All rights reserved.
//

import XCTest
@testable import AlgorithmExercise

class AlgorithmExerciseTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testBTree() {
        let btree = BTree<Int>()
        var arr:[Int] = []
        ALGUtils.randomArrWithNewSeed(n: 150).forEach{i in
            arr.append(i)
            btree.insert(k: i)
//            print(i)
        }
        arr.sort()
        for i in arr {
            print(i, terminator:" ")
        }
        btree.traverse()
        
        (0..<150).forEach({btree.delete(k: arr[$0])})
        
        btree.traverse()
    }

    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
