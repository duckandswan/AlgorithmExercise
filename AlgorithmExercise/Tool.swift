//
//  Tool.swift
//  TestAlgorithm
//
//  Created by bob song on 16/6/21.
//  Copyright © 2016年 finding. All rights reserved.
//

import Foundation

func swap<T:Comparable>(_ arr: inout [T],_ i:Int,_ j:Int){
    let x = arr[i]
    arr[i] = arr[j]
    arr[j] = x
}

func randIntArr(_ count:Int) -> [Int]{
    var arr:[Int] = []
    for _ in 0..<count {
        arr.append(Int(arc4random_uniform(100)))
    }
    return arr
}

func assertOrder<T:Comparable>(arr:[T]){
    for i in 0..<arr.count - 1 {
        assert(arr[i] <= arr[i + 1], "\(i) and \(i + 1) elements \(arr[i]) and \(arr[i + 1]) have errors")
    }
    print("\norder is right")
}
