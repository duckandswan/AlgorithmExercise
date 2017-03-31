//
//  RBViewController.swift
//  AlgorithmExercise
//
//  Created by Song Bo on 31/03/2017.
//  Copyright © 2017 Song Bo. All rights reserved.
//

import UIKit

class RBViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = UIColor.white
        navigationController?.navigationBar.isTranslucent = false
        let t = RBTree<Int>()
        t.insert(e: 105)
        t.insert(e: 100)
        drawRBTree(t: t)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func drawRBTree<T:Comparable>(t:RBTree<T>){
        let nodeW:CGFloat = 50
        let rowH = nodeW * 3 / 2
        
        func addLine(p1:CGPoint,p2:CGPoint){
            let line = CAShapeLayer()
            let linePath = UIBezierPath()
            linePath.move(to: p1)
            linePath.addLine(to: p2)
            line.lineWidth = 1.0
            line.path = linePath.cgPath
//            line.fillColor = UIColor.black.cgColor
            line.strokeColor = UIColor.blue.cgColor
            view.layer.addSublayer(line)
        }

        func addRBNode(n:RBNode<T>,center:CGPoint){
            let button = UIButton()
            button.frame.size = CGSize(width: nodeW, height: nodeW)
            button.isEnabled = false
            button.backgroundColor = n.isBlack ? UIColor.black : UIColor.red
            button.setTitleColor(UIColor.white, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
            button.setTitle(String(describing: n.element), for: .normal)
            button.layer.cornerRadius = nodeW / 2
            button.center = center
            view.addSubview(button)
            
            if n.left != nil {
                let p1 = center
                let p2 = CGPoint(x: p1.x - nodeW / 2, y: p1.y + rowH)
                addLine(p1: p1, p2: p2)
            }
        }
        
        guard let n = t.root else{
            return
        }
//            let button = RBNodeButton(n: n)
//            button.center =CGPoint(x: SCREEN_W / 2, y: button.frame.wi dth / 2)
//        var queue = FIFOQueue<RBNode<T>?>()
//        queue.enqueue(n)
        
        var row1:[RBNode<T>?] = [n]
        var rowArr = [row1]
        while true {
            var row2:[RBNode<T>?] = []
            for n in row1 {
                row2.append(n?.left)
                row2.append(n?.right)
                
            }
            if row2.contains(where: { $0 != nil}){
                rowArr.append(row2)
                row1 = row2
            }else{
                break
            }
        }
        
        let rowNumber = rowArr.count
        var curX:CGFloat = 0
        var curY:CGFloat = rowH * CGFloat(rowNumber) + nodeW * 1 / 2
        for (i,row) in rowArr.reversed().enumerated(){
            curY -= rowH
            curX =  -nodeW / 2 + CGFloat(i) * nodeW / 2
            for n in row{
                curX += nodeW
                if n != nil {
                    addRBNode(n: n!, center: CGPoint(x: curX, y: curY))
                }
            }
        }
        
        
//        while let n = queue.dequeue(){
//            let button = RBNodeButton(n: n)
//            button.center = CGPoint(x: SCREEN_W / 2, y: button.frame.width / 2)
//        }
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    

}
