//
//  RBTree.swift
//  AlgorithmExercise
//
//  Created by Song Bo on 30/03/2017.
//  Copyright © 2017 Song Bo. All rights reserved.
//

import Foundation

class RBNode<T:Comparable>{
//    let element:T!
    let element:T
    var isBlack = true
    
    var left:RBNode<T>?
    var right:RBNode<T>?
    weak var parent:RBNode<T>?
    
    init(element e:T,isBlack b:Bool = true) {
        element = e
        isBlack = b
    }
    
//    fileprivate init() {
//        element = nil
//    }
    
}

class RBTree<T:Comparable>{
    var root:RBNode<T>?
    
//    private var RBNodeNil:RBNode<T>
//
//    init() {
//        RBNodeNil = RBNode<T>()
//    }
    
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
    
    func minChild(n:RBNode<T>) -> RBNode<T>{
        var x = n
        while x.left != nil {
            x = x.left!
        }
        return x
    }
    
    private var sentinel:RBNode<T>?
    func delete(e:T){
        if root == nil {
            return
        }else{
            var n = root!
            while true {
                if e < n.element {
                    if n.left == nil{
                        break
                    }else{
                        n = n.left!
                    }
                }else if e > n.element {
                    if n.right == nil {
                        break
                    }else{
                        n = n.right!
                    }
                }else { // e == n.element
                    if n === root!{
                        root = nil
                        return
                    }
//                    var originalColor = n.isBlack
//                    var needToFixNode:RBNode<T>
//                    sentinel = RBNode<T>(element: e,isBlack: true)
//
//                    if n.left == nil {
//                        if n.right == nil{
//                            n.right = sentinel
//                        }
//                        needToFixNode = n.right!
//                        trans(for: n, substitute: n.right)
//                    }else if n.right == nil {
//                        needToFixNode = n.left!
//                        trans(for: n, substitute: n.left)
//                    }else{
//                        let y = minChild(n: n.right!)
//                        originalColor = y.isBlack
//                        if y.right == nil{
//                            y.right = sentinel
//                        }
//                        needToFixNode = y.right!
//                        if y.parent === n{
//                            needToFixNode.parent = y // may be sentinel
//                        }else{
//                            trans(for: y, substitute: y.right)
//                            y.right = n.right
//                            y.right!.parent = y
//                        }
//                        trans(for: n, substitute: y)
//                        y.left = n.left
//                        y.isBlack = n.isBlack
//                    }
//                    if originalColor{
//
////                        deleteFix(n: needToFixNode)
//                    }else{
//
//                    }
//                    if sentinel != nil {
//                        trans(for: sentinel!, substitute: nil)
//                        sentinel = nil
//                    }
//                    break

                    

                    if n.left == nil{
                        if n.right != nil {// n is black,n's left is nil, n's right is red
                            n.right!.isBlack = true
                            trans(for: n, substitute: n.right)
                        }else{// n is a leaf
                            if !n.isBlack{// n is red leaf
                                trans(for: n, substitute: nil)
                            }else{// n is black leaf, brother is black
                                let parent = n.parent!
                                trans(for: n, substitute: nil)
                                deleteLeafFix(n: parent)
                            }
                        }
                    }else if n.right == nil { // red left child，right is nil
                        n.left!.isBlack = true
                        trans(for: n, substitute: n.left)
                    }else{ // n has two children
                        let y = minChild(n: n.right!)
                        var p = y.parent!
                        let x = y.right
                        if y.parent === n{
                            trans(for: n, substitute: y)
                            p = y
                        }else{
                            trans(for: y, substitute: y.right)
                            trans(for: n, substitute: y)
                            y.right = n.right
                            n.right!.parent = y
                        }
                        y.left = n.left
                        y.isBlack = n.isBlack
                        if x != nil {
                            x!.isBlack = true
                        }else{
                            deleteLeafFix(n: p)
                        }
                    }
                    break
                }
            }
        }
    }

    
    func deleteLeafFix(n:RBNode<T>){
        var p = n
        var x:RBNode<T>? = nil
        while true {
            if p.right !== x {
                var r  = p.right!
                if !r.isBlack { // r is red
                    r.isBlack = true
                    p.isBlack = false
                    rotateToLeft(n: r)
                }else if (r.left == nil && r.right == nil) ||
                    ((r.left != nil && r.right != nil)&&(r.left!.isBlack && r.right!.isBlack)){
                    r.isBlack = false
                    if p === root! || !p.isBlack {
                        p.isBlack = true
                        break
                    }else{
                        p = p.parent!
                        x = p
                    }
                }else{// r.left is red
                    if (r.right == nil) || (r.right != nil && r.right!.isBlack) {
                        r.isBlack = false
                        let rl = r.left!
                        rl.isBlack = true
                        rotateToRight(n: rl)
                        r = rl
                    }
                    r.isBlack = n.isBlack
                    n.isBlack = true
                    r.right!.isBlack = true
                    rotateToLeft(n: r)
                    break
                }
            }else{
                var l  = p.left!
                if !l.isBlack { // r is red
                    l.isBlack = true
                    p.isBlack = false
                    rotateToRight(n: l)
                }else if (l.left == nil && l.right == nil) ||
                    ((l.left != nil && l.right != nil)&&(l.left!.isBlack && l.right!.isBlack)){
                    l.isBlack = false
                    if p === root! || !p.isBlack {
                        p.isBlack = true
                        break
                    }else{
                        p = p.parent!
                        x = p
                    }
                }else{// r.left is red
                    if (l.left == nil) || (l.left != nil && l.left!.isBlack) {
                        l.isBlack = false
                        let lr = l.right!
                        lr.isBlack = true
                        rotateToLeft(n: lr)
                        l = lr
                    }
                    l.isBlack = n.isBlack
                    n.isBlack = true
                    l.left!.isBlack = true
                    rotateToRight(n: l)
                    break
                }

            }
        }

//        if !n.isBlack { // n is red, n has a black child, a nil child
//            if n.left != nil {//left child is black
//                let leftChild = n.left!
//                if leftChild.right != nil {
//                    let rightGrandChild = leftChild.right! // grand is red
//                    rotateToLeft(n: rightGrandChild)
//                    rotateToRight(n: rightGrandChild)
//                    rightGrandChild.right!.isBlack = true
//                }else {
//                    rotateToRight(n: leftChild)
//                }
//            }else{// right child is black
//                let rightChild = n.right!
//                if rightChild.left != nil {
//                    let leftGrandChild = rightChild.left!
//                    rotateToRight(n: leftGrandChild)
//                    rotateToLeft(n: leftGrandChild)
//                    leftGrandChild.left!.isBlack = true
//                }else {
//                    rotateToLeft(n: rightChild)
//                }
//            }
//        }else{// n is black
//            if n.left != nil {//left child is black
//                let leftChild = n.left!
//                if !leftChild.isBlack{// if left child is red
//                    if leftChild.right != nil {
//                        let rightGrandChild = leftChild.right! // grand is black
//                        rotateToLeft(n: rightGrandChild)
//                        rotateToRight(n: rightGrandChild)
//                    }else {
//                        rotateToRight(n: leftChild)
//                        leftChild.isBlack = true
//                    }
//                }else{// if left child is black
//                    
//                }
//            }else{// right child is black
//                            }
        
//            if n.left != nil {
//                let leftChild = n.left!
//                if leftChild.isBlack { // left child is black
//                    if leftChild.right != nil {
//                        let rightGrandChild = leftChild.right!
//                        rotateToLeft(n: rightGrandChild)
//                        rotateToRight(n: rightGrandChild)
//                        rightGrandChild.right!.isBlack = true
//                    }else {
//                        rotateToRight(n: leftChild)
//                    }
//                }
//            }else{
//                //                let rightChild = n.right!
//            }
//        }
//        var x = n
//        if !x.isBlack {
//            
//        }
//        while x !== root && x.isBlack {
//            let parent = x.parent!
//            
//            if x === parent.left{
//                let rightBrother = parent.right!
//                if rightBrother.isBlack && rightBrother.isBlack{
//                    
//                }
//            }
//            
//        }
//        x.isBlack = true
    }
    
    func trans(for n1:RBNode<T> ,substitute n2:RBNode<T>?){
        n2?.parent = n1.parent
        if n1.parent == nil {
            root = n2
        }else{
            let parent = n1.parent!
            if n1 === parent.left{
                parent.left = n2
            }else{
                parent.right = n2
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
        n.right?.parent = parent //n.roght may be nil
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
