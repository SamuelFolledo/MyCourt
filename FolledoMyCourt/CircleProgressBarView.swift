//
//  CircleProgressBarView.swift
//  FolledoMyCourt
//
//  Created by Samuel Folledo on 10/5/18.
//  Copyright © 2018 Samuel Folledo. All rights reserved.
//

import UIKit

class CircleProgressBarView: UIViewController {
    
    let shapeLayer = CAShapeLayer()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    //start drawing a circle
        let center = view.center
        let circularPath = UIBezierPath(arcCenter: center, radius: 100, startAngle: -CGFloat.pi / 2, endAngle: 2 * CGFloat.pi, clockwise: true) //UIBezierPath = Summary it is A path that consists of straight and curved line segments that you can render in your custom views. //animate it clockwise, use the view's ceneter, use a 100 radius, startAngle 0, endAngle will be 2 pi which is around the circle
        
    //trackLayer that our shapeLayer will be walking to
        let trackLayer = CAShapeLayer()
        trackLayer.path = circularPath.cgPath // this creates a circle for us with 100 diamater, now we need a stroke path around our circle
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.strokeColor = UIColor.lightGray.cgColor //cant just give it a .red value
        trackLayer.lineWidth = 10 //the stroke's width
        trackLayer.lineCap = CAShapeLayerLineCap.round //makes the stroke progressing up have a rounded end, not box
        
        
    //progressing shapeLayer
        shapeLayer.path = circularPath.cgPath // this creates a circle for us with 100 diamater, now we need a stroke path around our circle
        
        shapeLayer.fillColor = UIColor.clear.cgColor
        
        shapeLayer.strokeColor = UIColor.red.cgColor //cant just give it a .red value
        shapeLayer.lineWidth = 10 //the stroke's width
        shapeLayer.lineCap = CAShapeLayerLineCap.round //makes the stroke progressing up have a rounded end, not box
        shapeLayer.strokeEnd = 0 //strokeEnd at 0, so it becomes not visible
        view.layer.addSublayer(shapeLayer)
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
        
    }
    
    @objc private func handleTap() {
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.toValue = 1 //toValue = Defines the value the receiver uses to end interpolation.
        basicAnimation.duration = 2 //makes animation's duration to 2 seconds
        
        basicAnimation.fillMode = CAMediaTimingFillMode.forwards //fillMode = Determines if the receiver’s presentation is frozen or removed once its active duration has completed. //forwards = The receiver remains visible in its final state when the animation is completed.
        basicAnimation.isRemovedOnCompletion = false //When true, the animation is removed from the target layer’s animations once completion or its active duration has passed. Defaults to true
        
        shapeLayer.add(basicAnimation, forKey: "urSoBasic")
        
    }
}
