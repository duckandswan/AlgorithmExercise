//
//  RBTree.swift
//  AlgorithmExercise
//
//  Created by Song Bo on 30/03/2017.
//  Copyright © 2017 Song Bo. All rights reserved.
//

import Foundation

class RBNode<T:Comparable>{
    let element:T
    init(element e:T,isBlack b:Bool = true) {
        element = e
        isBlack = b
    }
    var isBlack = true
    
    var left:RBNode<T>?
    var right:RBNode<T>?
    weak var parent:RBNode<T>?
    
}

class RBTree<T:Comparable>{
    var root:RBNode<T>?
    
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
                        adjust(n: n)
                        break
                    }else{
                        p = p.left!
                    }
                }else if e > p.element {
                    if p.right == nil {
                        let n = RBNode<T>(element: e,isBlack: false)
                        p.right = n
                        n.parent = p
                        adjust(n: n)
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
    
    func delete(e:T){
        if root == nil {
            let n = RBNode<T>(element: e)
            root = n
        }else{
            var p = root!
            while true {
                if e < p.element {
                    if p.left == nil{
                        break
                    }else{
                        p = p.left!
                    }
                }else if e > p.element {
                    if p.right == nil {
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
        var current = n
        var parent = n.parent!
        if !parent.isBlack {
            var grandparent = n.parent!.parent!
            while true {
                if parent === grandparent.left{//1 parent is left child
                    if grandparent.right == nil || grandparent.right!.isBlack { //1.1 grandparent n's right is nil or black
                        if current === parent.right{ // 1.1.1 current is parent's right child
                            rotateToLeft(n: current)
                            parent = current
                        }
                        rotateToRight(n: parent) // 1.1.2 current is parent's left child
                        parent.isBlack = true
                        parent.right!.isBlack = false
                        break
                        //
                    }else { //1.2 grandparent's right is red
                        reverseColor(n: grandparent) // 1.2.1reverse color
                        if grandparent === root!{
                            grandparent.isBlack = true
                            break
                        }else if !grandparent.parent!.isBlack{ //1.2.2 grandparent's parent is red after reverse
                            current = grandparent
                            parent = grandparent.parent!
                            grandparent = parent.parent!
                        }else{ //1.2.3 grandparent's parent is black after reverse
                            break
                        }
                    }
                }else{ //2 parent is right child
                    if grandparent.left == nil || grandparent.left!.isBlack { //1.1 grandparent n's left is nil or black
                        if current === parent.left{
                            rotateToRight(n: current)
                            parent = current
                        }
                        rotateToLeft(n: parent)
                        parent.isBlack = true
                        parent.left!.isBlack = false
                        break
                        //
                    }else { //1.2 grandparent's left is red
                        reverseColor(n: grandparent) // 1.2.1reverse color
                        if grandparent === root!{
                            grandparent.isBlack = true
                            break
                        }else if !grandparent.parent!.isBlack{ //1.2.2 grandparent's parent is red after reverse
                            current = grandparent
                            parent = grandparent.parent!
                            grandparent = parent.parent!
                        }else{ //1.2.3 grandparent's parent is black after reverse
                            break
                        }
                    }

                }
            }
        }

    }
    
    func reverseColor(n:RBNode<T>){
        n.isBlack = false
        n.left!.isBlack = true
        n.right!.isBlack = true
    }
    
    //assume n's right is nil
    func rotateToRight(n:RBNode<T>){
        let parent = n.parent!
        parent.left = n.right
        n.right?.parent = parent
        n.right = parent
        if parent === root!{
            root = n
            n.parent = nil
        }else{
            let grandparent = parent.parent! // grandparent is black
            if n.parent! === grandparent.left{
                grandparent.left = n
            }else{
                grandparent.right = n
            }
            n.parent = grandparent
        }
        parent.parent = n
    }
    
    func rotateToLeft(n:RBNode<T>){
        let parent = n.parent!
        parent.right = n.left
        n.left?.parent = parent
        n.left = parent
        if parent === root!{
            root = n
            n.parent = nil
        }else{
            let grandparent = parent.parent! // grandparent is black
            if n.parent! === grandparent.left{
                grandparent.left = n
            }else{
                grandparent.right = n
            }
            n.parent = grandparent
        }
        parent.parent = n
    }
}
