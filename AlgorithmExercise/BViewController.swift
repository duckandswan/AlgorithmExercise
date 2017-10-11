//
//  BViewController.swift
//  AlgorithmExercise
//
//  Created by Song Bo on 10/10/2017.
//  Copyright © 2017 Song Bo. All rights reserved.
//

import UIKit

class BViewController: UIViewController {
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    @IBOutlet weak var subtractButton: UIBarButtonItem!
    
    @IBOutlet weak var adjustButton: UIBarButtonItem!
    
    @IBOutlet weak var preButton: UIBarButtonItem!
    
    @IBOutlet weak var tf: UITextField!
    var tree = BTreeAnimation<Int>()
    let scrollView = UIScrollView()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = UIColor.white
        navigationController?.navigationBar.isTranslucent = false
        scrollView.frame = view.bounds
        scrollView.contentSize = view.bounds.size
        scrollView.keyboardDismissMode = .onDrag
        view.addSubview(scrollView)
        
        let pinchGestureRecognizer =  UIPinchGestureRecognizer(target: self,
                                                               action: #selector(RBViewController.handlePinches(_:)))
        scrollView.addGestureRecognizer(pinchGestureRecognizer)
        
        randomWithFixedSeed()
        
        drawBTree(t: tree, isAnimated: false)
    }
    
    func randomWithFixedSeed(){
        var arr:[Int] = []
        (1...10).forEach{_ in
            let i = Int(arc4random_uniform(1000))
            tree.insert(k: i)
            arr.append(i)
        }
        print("arr:\(arr)")
    }
    
    func randomWithNewSeed(){
        var arr:[Int] = []
        ALGUtils.randomArrWithNewSeed(n: 10).forEach{i in
            arr.append(i)
            tree.insert(k: i)
        }
        arr.sort()
        for i in arr {
            print(i, terminator:" ")
        }
        tree.traverse()
    }
    
    func handlePinches(_ sender: UIPinchGestureRecognizer){
        
        if sender.state != .ended && sender.state != .failed{
            scrollView.transform = scrollView.transform.scaledBy(x: sender.scale, y: sender.scale)
            scrollView.frame = UIScreen.main.bounds
            sender.scale = 1
        }else{
            
        }
    }
    
    var treeArr:[BTreeAnimation<Int>] = []

    
    
    @IBAction func subtract(_ sender: UIBarButtonItem) {
        
    }
    
    var isContinuous = true
    
    @IBAction func resolve(_ sender: UIBarButtonItem) {
        if sender.title == "✂︎" {
            sender.title = "➤"
            isContinuous = false
        }else{
            sender.title = "✂︎"
            isContinuous = true
        }
    }
    
    var timeInterval:TimeInterval = 0
    let nodeW:CGFloat = 25
    func drawBTree<T>(t:BTreeAnimation<T>, isAnimated:Bool = false){
        for v in scrollView.subviews{
            v.removeFromSuperview()
        }
        
        if let layers = scrollView.layer.sublayers{
            for l in layers {
                l.removeFromSuperlayer()
            }
        }
        
        timeInterval = isAnimated ? 1.5 : 0
        
        let level = t.level()
        let t = BNodeAnimation<T>.t
        let gap = CGFloat(2 * t - 1) * nodeW * CGFloat(level - 1)
        let point = CGPoint(x: gap * pow(CGFloat(2*t-1), CGFloat(level)) / 2, y: nodeW / 2)
        
        draw(n: tree.root, p: point, level: level)
        
    }
    
    func draw<T>(n:BNodeAnimation<T>,p:CGPoint,level:Int){
        
        let t = BNodeAnimation<T>.t
        let gap = CGFloat(2*t - 1) * nodeW * pow(CGFloat(2*t-1), CGFloat(level))
        
        func addRBNode(k:T,center:CGPoint){
            let button = UIButton()
            button.frame.size = CGSize(width: nodeW, height: nodeW)
            button.isEnabled = true
            button.setTitleColor(UIColor.white, for: .normal)
            button.setTitleColor(UIColor.aqua, for: .disabled)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 10)
            button.setTitle(String(describing: k), for: .normal)
            button.layer.cornerRadius = nodeW / 2
            UIView.animate(withDuration: timeInterval) {
                button.center = center
            }
            button.backgroundColor = UIColor.black
            scrollView.addSubview(button)
            
            button.addTarget(self, action: #selector(BViewController.clickToDelete(b:)), for: .touchUpInside)
            
        }
        
        var center = CGPoint(x: p.x - gap * CGFloat(t - 1), y: p.y )
        for key in n.keys{
            addRBNode(k: key, center: center)
            center.x += gap
        }
        if !n.isLeaf{
            center = CGPoint(x: p.x - gap * CGFloat(t - 1) - 1/2*gap, y: p.y - nodeW)
            for child in n.children{
                draw(n: child, p: center, level: level - 1)
                center.x += gap
            }
        }
        
    }
    
    func clickToDelete(b:UIButton){
        
    }

    
    override func viewDidLayoutSubviews() {
        print("UIScreen.main.bounds: \(UIScreen.main.bounds)")
        scrollView.frame = UIScreen.main.bounds
    }
    
    
    
}


