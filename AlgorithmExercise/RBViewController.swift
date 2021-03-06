//
//  RBViewController.swift
//  AlgorithmExercise
//
//  Created by Song Bo on 31/03/2017.
//  Copyright © 2017 Song Bo. All rights reserved.
//

import UIKit
import GameKit


class RBViewController: UIViewController {

    @IBOutlet weak var tf: UITextField!
    let t = RBTree<Int>()
    let scrollView = UIScrollView()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = UIColor.white
        navigationController?.navigationBar.isTranslucent = false
        scrollView.frame = view.bounds
        scrollView.contentSize = view.bounds.size
        view.addSubview(scrollView)
        
//        t.insert(e: 105)
//        t.insert(e: 100)
//        t.insert(e: 99)
//        stride(from: 500, through: 100, by: -10).forEach { (i) in
//            t.insert(e: i)
//        }
//        [445,435,437,433].forEach { (i) in
//            t.insert(e: i)
//        }
        let rs = GKMersenneTwisterRandomSource()
        rs.seed = 100
        
        // Use the random source and a lowest and highest value to create a
        // GKRandomDistribution object that will provide the random numbers.
        let rd = GKRandomDistribution(randomSource: rs, lowestValue: 0, highestValue: 1000)
        
        (1...100).forEach{_ in
            t.insert(e: rd.nextInt())}
//        (1...100).forEach{_ in
//            t.insert(e: Int(arc4random_uniform(999)))}
        drawRBTree(t: t)
    }
    @IBAction func add(_ sender: UIBarButtonItem) {
        if let i = Int(tf.text!){
            t.insert(e: i)
            drawRBTree(t: t)

        }
        view.endEditing(false)
    }
    @IBAction func subtract(_ sender: UIBarButtonItem) {
        if let i = Int(tf.text!){
            t.delete(e: i)
            drawRBTree(t: t)
        }
        view.endEditing(false)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func drawRBTree<T:Comparable>(t:RBTree<T>){
        for v in scrollView.subviews{
            v.removeFromSuperview()
        }
        
        if let layers = scrollView.layer.sublayers{
            for l in layers {
                l.removeFromSuperlayer()
            }
        }
        
        let nodeW:CGFloat = 25
        let rowH = nodeW
        
        func addLine(p1:CGPoint,p2:CGPoint){
            let line = CAShapeLayer()
            let linePath = UIBezierPath()
            let r = nodeW / 2
            let sin = (p2.y - p1.y) / (p2.distanceTo(p1))
            let cos = (p2.x - p1.x) / (p2.distanceTo(p1))
            let v = CGVector(dx: r * cos, dy: r * sin)
            let a1 = p1 + v
            let a2 = p2 - v
            linePath.move(to: a1)
            linePath.addLine(to: a2)
            line.lineWidth = 1.0
            line.path = linePath.cgPath
//            let d = p1.distanceTo(p2)
//            line.lineDashPhase = nodeW / 2
//            line.lineDashPattern = [NSNumber(value: Float(Float(nodeW / 2))),NSNumber(value: Float(Float(d - nodeW))),NSNumber(value: Float(Float(nodeW / 2)))]
//            line.fillColor = UIColor.black.cgColor
            line.strokeColor = UIColor.blue.cgColor
            scrollView.layer.addSublayer(line)
        }

        func addRBNode(n:RBNode<T>,center:CGPoint,i:Int){
            let button = UIButton()
            button.frame.size = CGSize(width: nodeW, height: nodeW)
            button.isEnabled = true
            button.backgroundColor = n.isBlack ? UIColor.black : UIColor.red
            button.setTitleColor(UIColor.white, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 10)
            button.setTitle(String(describing: n.element), for: .normal)
            button.layer.cornerRadius = nodeW / 2
            button.center = center
            scrollView.addSubview(button)
            
            button.addTarget(self, action: #selector(RBViewController.clickToDelete(b:)), for: .touchUpInside)
            
            if n.left != nil {
                let p1 = center
                let p2 = CGPoint(x: p1.x - pow(2, CGFloat(i - 1)) * (nodeW / 2), y: p1.y + rowH)
                addLine(p1: p1, p2: p2)
            }
            
            if n.right != nil {
                let p1 = center
                let p2 = CGPoint(x: p1.x + pow(2, CGFloat(i - 1)) * (nodeW / 2), y: p1.y + rowH)
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
        var curX:CGFloat
        var curY:CGFloat = rowH * CGFloat(rowNumber) - nodeW * 1 / 2
        if (curY + rowH)  > scrollView.contentSize.height{
            scrollView.contentSize.height = curY + rowH
        }
        for (i,row) in rowArr.reversed().enumerated(){
            curX = i == 0 ? (nodeW * 1 / 2) : (nodeW * pow(2, CGFloat(i - 1 )))
            for n in row{
                if n != nil {
                    addRBNode(n: n!, center: CGPoint(x: curX, y: curY),i: i)
                }
                let spaceX = nodeW * pow(2, CGFloat(i))
//                print("spaceX: \(spaceX)")
                curX += spaceX
//                curX += nodeW
            }
            if curX > scrollView.contentSize.width{
                scrollView.contentSize.width = curX
            }
            curY -= rowH
        }
        
        
//        while let n = queue.dequeue(){
//            let button = RBNodeButton(n: n)
//            button.center = CGPoint(x: SCREEN_W / 2, y: button.frame.width / 2)
//        }
        
    }
    
    func clickToDelete(b:UIButton){
        if let i = Int(b.titleLabel!.text!){
            t.delete(e: i)
            drawRBTree(t: t)
        }
    }
    
    override func viewDidLayoutSubviews() {
        
    }

}

