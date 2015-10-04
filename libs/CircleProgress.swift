//
//  ProgressView.swift
//  CustomProgressBar
//
//  Created by Sztanyi Szabolcs on 16/10/14.
//  Copyright (c) 2014 Sztanyi Szabolcs. All rights reserved.
//

import UIKit

class CircleProgress: UIView {
    
    internal let progressLayer: CAShapeLayer = CAShapeLayer()
    
    internal var progressLabel: UILabel
    var fill = "#e74c3c"
    var stroke = "#dce324"
    var lineWidth : CGFloat = CGFloat(4.0)
    
    required init?(coder aDecoder: NSCoder) {
        progressLabel = UILabel()
        super.init(coder: aDecoder)
        createProgressLayer()
        createLabel()
    }
    
    override init(frame: CGRect) {
        progressLabel = UILabel()
        super.init(frame: frame)
        createProgressLayer()
        createLabel()
    }
    
    func createLabel() {
        progressLabel = UILabel(frame: CGRectMake(0.0, 0.0, CGRectGetWidth(frame), 60.0))
        progressLabel.textColor = .whiteColor()
        progressLabel.textAlignment = .Center        
        progressLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(progressLabel)
        
        addConstraint(NSLayoutConstraint(item: self, attribute: .CenterX, relatedBy: .Equal, toItem: progressLabel, attribute: .CenterX, multiplier: 1.0, constant: 0.0))
        addConstraint(NSLayoutConstraint(item: self, attribute: .CenterY, relatedBy: .Equal, toItem: progressLabel, attribute: .CenterY, multiplier: 1.0, constant: 0.0))
    }

    
    
    private func createProgressLayer() {
        let startAngle = CGFloat(M_PI_2)
        let endAngle = CGFloat(M_PI * 2 + M_PI_2)
        let centerPoint = CGPointMake(CGRectGetWidth(frame)/2 , CGRectGetHeight(frame)/2)
        
        progressLayer.path = UIBezierPath(arcCenter:centerPoint, radius: CGRectGetWidth(frame)/2 - 4.0, startAngle:startAngle, endAngle:endAngle, clockwise: true).CGPath
        progressLayer.backgroundColor = UIColor.clearColor().CGColor
        progressLayer.strokeStart = 0.0
        progressLayer.strokeEnd = 0.0
        progressLayer.fillColor = UIColor(rgba: fill).CGColor
        layer.addSublayer(progressLayer)
    }
    
    func animateLayerFill(){
        let animation = CABasicAnimation(keyPath: "fillColor")
        animation.fromValue = UIColor(rgba: fill).CGColor
        animation.toValue = UIColor(rgba: "#35b029").CGColor
        animation.duration = 0.5
        animation.autoreverses = false
        animation.fillMode = kCAFillModeForwards
        animation.delegate = self
        animation.removedOnCompletion = false
        
        progressLayer.addAnimation(animation, forKey: "fillColor")
    }
    
    
    func hideProgressView() {
        progressLayer.strokeEnd = 0.0
        progressLayer.removeAllAnimations()
      //  progressLabel.text = "Load content"
    }
    
    func showProgressView() {
        
        progressLayer.strokeEnd = 1.0
        progressLayer.lineWidth = lineWidth
        progressLayer.fillColor = UIColor(rgba: fill).CGColor
        progressLayer.strokeColor = UIColor(rgba: stroke).CGColor
        progressLayer.removeAllAnimations()
        //  progressLabel.text = "Load content"
    }
    
    func animateProgressView(from : CGFloat, to : CGFloat , duration : CFTimeInterval = 1.0) {
        //println(from,to)
        progressLayer.strokeEnd = 0.0
        progressLayer.lineWidth = lineWidth
        progressLayer.fillColor = UIColor(rgba: fill).CGColor
        progressLayer.strokeColor = UIColor(rgba: stroke).CGColor

        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = from
        animation.toValue = to >= 0.95 ? 1.0 : to // round off
        animation.duration = duration
        animation.delegate = self
        animation.removedOnCompletion = false
        animation.additive = true
        animation.fillMode = kCAFillModeForwards
        progressLayer.addAnimation(animation, forKey: "strokeEnd")
    }
    
    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        //progressLabel.text = "Done"
    }
}
