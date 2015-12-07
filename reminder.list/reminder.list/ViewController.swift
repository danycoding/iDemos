//
//  ViewController.swift
//  reminder.list
//
//  Created by DanyChen on 7/12/15.
//  Copyright © 2015 DanyChen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let scrollView = UIScrollView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(scrollView)
        scrollView.frame = CGRect(x: 0, y: 20, width: view.bounds.width, height: view.bounds.height - 20)
        
        
        scrollView.addSubview(setupCard(UIColor.redColor(), index: 0))
        scrollView.addSubview(setupCard(UIColor.blueColor(), index: 1))
        scrollView.addSubview(setupCard(UIColor.blackColor(), index: 2))
        scrollView.addSubview(setupCard(UIColor.greenColor(), index: 3))
        scrollView.addSubview(setupCard(UIColor.yellowColor(), index: 4))
        scrollView.addSubview(setupCard(UIColor.redColor(), index: 5))
        scrollView.addSubview(setupCard(UIColor.blueColor(), index: 6))
        scrollView.addSubview(setupCard(UIColor.blackColor(), index: 7))
        scrollView.addSubview(setupCard(UIColor.greenColor(), index: 8))
        
        scrollView.contentSize = CGSize(width: view.bounds.size.width, height: scrollView.bounds.size.height + 100 * (8-7) + 80)
        
        scrollView.alwaysBounceVertical = true
        
        scrollView.delegate = self
    }
    
    func setupCard(color : UIColor, index : Int) -> UIView {
        let card = UIView(frame: CGRect(origin: CGPoint(x: 0, y: 100 * index), size: CGSize(width:  view.bounds.size.width, height:  view.bounds.size.height - 120)))
        card.backgroundColor = color
        card.layer.cornerRadius = 10
        card.layer.borderColor = UIColor.grayColor().CGColor
        card.layer.borderWidth = 1
        return card
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

extension ViewController : UIScrollViewDelegate {
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView.contentOffset.y <= 0 {
            for var i = 0; i < scrollView.subviews.count; i++ {
                let view = scrollView.subviews[i]
                let offset = scrollView.contentOffset.y * CGFloat(i) / 8
                view.frame = CGRect(x : 0, y: -offset + 100.0 * CGFloat(i), width: view.bounds.width, height: 630)
            }
        }else {
            for var i = 0; i < scrollView.subviews.count; i++ {
                let view = scrollView.subviews[i]
                let originY = (100 * i)
                if CGFloat(originY) <= scrollView.contentOffset.y {
                    view.frame = CGRect(x : 0, y: scrollView.contentOffset.y, width: view.bounds.width, height: 630)
                }
            }
        }
    }
}

