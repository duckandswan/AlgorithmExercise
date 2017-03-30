//
//  QuickSort.swift
//  TestAlgorithm
//
//  Created by Song Bo on 02/01/2017.
//  Copyright © 2017 finding. All rights reserved.
//

import Foundation

func partition<T:Comparable>(_ arr:inout [T],p:Int,r:Int)->Int{
    let x = arr[r]
    var i:Int = p - 1
    for j in p..<r+1{
        if arr[j] <= x {
            i += 1
            swap(&arr, i, j)
        }
    }
    return i
}


func randomPartition<T:Comparable>(_ arr:inout [T],p:Int,r:Int)->Int{
    let i = Int(arc4random_uniform(UInt32(r - p + 1))) + p
    swap(&arr, i, r)
    return partition(&arr, p: p, r: r)
}

func betterRandomPartition<T:Comparable>(_ arr:inout [T],p:Int,r:Int)->Int{
    //    let i = Int(arc4random_uniform(UInt32(r - p + 1))) + p
    //    print("in partition arr: \(arr) and p: \(p) r: \(r)")
    let i = p
    swap(&arr, i, r)
    
    let x = arr[r]
    var j = p - 1
    var k = r
    
    while true {
        repeat{
            j += 1
        }while j <= r - 1 && arr[j] < x
        
        repeat{
            k -= 1
        }while k >= p && arr[k] > x
        
        if j <= r - 1 && k >= p && j < k {
            swap(&arr, j, k)
        }else{
            if j == r {
                return r
            }
            if k == p - 1 {
                swap(&arr, p, r)
                return p
            }
            break
        }
    }
    
    swap(&arr, j, r)
    
    return j
}

func betterPartition<T:Comparable>(_ arr:inout [T],p:Int,r:Int)->Int{
    let i = (p + r - 1)/2
    if arr[p] > arr[i]{
        swap(&arr, p, i)
    }
    if arr[i] > arr[r - 1]{
        swap(&arr, i, r - 1)
        if arr[p] > arr[i]{
            swap(&arr, p, i)
        }
    }
    
    swap(&arr, i, r)
    
    let x = arr[r]
    var j = p
    var k = r - 1
    
    while true {
        repeat{
            j += 1
        }while j < r - 1 && arr[j] < x
        
        repeat{
            k -= 1
        }while k > p && arr[k] > x
        
        if j < r - 1 && k > p && j < k {
            swap(&arr, j, k)
        }else{
            break
        }
    }
    
    swap(&arr, j, r)
    
    return j
}

func insertSort<T:Comparable>(_ arr:inout [T],p:Int,r:Int){
    for i in p+1...r {
        let x = arr[i]
        var j = i - 1
        while j >= 0 && arr[j] > x{
            arr[j + 1] = arr[j]
            j -= 1
        }
        arr[j + 1] = x
    }
}

func quickSort<T:Comparable>(_ arr:inout [T],p:Int,r:Int){
    
    if r - p <= 2 {
        return
    }
    //    let q = partition(&arr, p: p, r: r)
    //    let q = randomPartition(&arr, p: p, r: r)
    //    let q = betterRandomPartition(&arr, p: p, r: r)
    //    print("q: \(q)")
    let q = betterPartition(&arr, p: p, r: r)
    quickSort(&arr, p: p, r: q - 1)
    quickSort(&arr, p: q + 1, r: r)
}
