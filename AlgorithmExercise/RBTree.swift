//
//  RBTree.swift
//  AlgorithmExercise
//
//  Created by Song Bo on 30/03/2017.
//  Copyright © 2017 Song Bo. All rights reserved.
//

import Foundation

class RBNode<T:Comparable>{
    fileprivate let element:T
    init(element e:T,isBlack b:Bool = true) {
        element = e
        isBlack = b
    }
    var isBlack = true
    
    var left:RBNode<T>?
    var right:RBNode<T>?
    var parent:RBNode<T>?
    
}

protocol Queue {
    /// The type of elements held in `self`.
    associatedtype Element
    /// Enqueue `element` to `self`.
    mutating func enqueue(_ newElement: Element)
    /// Dequeue an element from `self`.
    mutating func dequeue() -> Element?
}
//#-end-hidden-code

//#-editable-code
/// An efficient variable-size FIFO queue of elements of type `Element`
struct FIFOQueue<Element>: Queue {
    fileprivate var left: [Element] = []
    fileprivate var right: [Element] = []
    
    /// Add an element to the back of the queue.
    /// - Complexity: O(1).
    mutating func enqueue(_ newElement: Element) {
        right.append(newElement)
    }
    
    /// Removes front of the queue.
    /// Returns `nil` in case of an empty queue.
    /// - Complexity: Amortized O(1).
    mutating func dequeue() -> Element? {
        if left.isEmpty {
            left = right.reversed()
            right.removeAll()
        }
        return left.popLast()
    }
}

class RBTree<T:Comparable>{
    private var root:RBNode<T>?
    
    func insert(e:T){
        if root == nil {
            let n = RBNode<T>(element: e)
            root = n
        }else{
            var p = root!
            while true {
                if e < p.element {
                    if p.left == nil{
                        let n = RBNode<T>(element: e,isBlack: false)
                        p.left = n
                        n.parent = p
                        break
                    }else{
                        p = p.left!
                    }
                }else if e > p.element {
                    if p.right == nil {
                        let n = RBNode<T>(element: e,isBlack: false)
                        p.right = n
                        n.parent = p
                        break
                    }else{
                        p = p.right!
                    }
                }else {
                    break
                }
            }
        }
    }
    
    //assume n is red
    func adjust(n:RBNode<T>){
        //it's parent are red
        if !n.parent!.isBlack {
            let grandparent = n.parent!.parent!
            if n.parent === grandparent.left{
                if grandparent.right == nil{
                    rotateToRight(n: n.parent!)
                }
            }else{
                if grandparent.left == nil{
                    rotateToLeft(n: n.parent!)
                }
            }
        }
    }
    
    //assume n's right is nil
    func rotateToRight(n:RBNode<T>){
        if n.parent! === root!{
            root = n
            n.right = n.parent
            n.parent!.parent = n
            n.parent = nil
        }else{
            let grandparent = n.parent!.parent!
            if n.parent! === grandparent.left{
                grandparent.left = n
            }else{
                grandparent.right = n
            }
            n.right = n.parent
            n.parent!.parent = n
            n.parent = grandparent
        }
    }
    
    func rotateToLeft(n:RBNode<T>){
        if n.parent! === root!{
            root = n
            n.left = n.parent
            n.parent!.parent = n
            n.parent = nil
        }else{
            let grandparent = n.parent!.parent!
            if n.parent! === grandparent.left{
                grandparent.left = n
            }else{
                grandparent.right = n
            }
            n.left = n.parent
            n.parent!.parent = n
            n.parent = grandparent
        }
    }
}
