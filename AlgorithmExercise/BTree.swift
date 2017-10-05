//
//  BTree.swift
//  AlgorithmExercise
//
//  Created by Song Bo on 09/09/2017.
//  Copyright © 2017 Song Bo. All rights reserved.
//

import UIKit

class BNode<T:Comparable>{
    let element:T
    var b = UIButton()
    var lines:[CAShapeLayer] = []
    init(element e:T,isBlack bool:Bool = true) {
        element = e
    }
    
    var children:[BNode<T>] = []
    weak var parent:BNode<T>?
    
    deinit {
        print("a node is deleted!")
    }
}

class BTree<T:Comparable>{
    var root:BNode<T>?
    
    func insert(e:T,delayAdjust:Bool = false){
        if root == nil {
            let n = BNode<T>(element: e)
            root = n
        }else{
            let n = BNode<T>(element: e)
            root!.children.append(n)
        }
    }
}






