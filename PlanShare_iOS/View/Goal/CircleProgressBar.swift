//
//  CircleProgressBar.swift
//  PlanShare_iOS
//
//  Created by Doyun Park on 2022/06/23.
//

import UIKit

class CircleProgressBar: UIView {
    
    //MARK: - Properties
    private var circleLayer = CAShapeLayer()
    private var progressLayer = CAShapeLayer()
    private var startPoint = CGFloat(-Double.pi / 2)
    private var endPoint = CGFloat(3 * Double.pi / 2)
    
    var percent: Double = 0 {
        didSet{
            print(percent)
            progressLayer.strokeEnd = percent
        }
    }
    //MARK: - LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        createCircularPath()
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    private func createCircularPath() {
        // created circularPath for circleLayer and progressLayer
        let circularPath = UIBezierPath(arcCenter: CGPoint(x: 30, y: 30), radius: 15, startAngle: startPoint, endAngle: endPoint, clockwise: true)
        // circleLayer path defined to circularPath
        circleLayer.path = circularPath.cgPath
        // ui edits
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.lineCap = .round
        circleLayer.lineWidth = 4
        circleLayer.strokeEnd = 1.0
        circleLayer.strokeColor = UIColor.gray.cgColor
        circleLayer.opacity = 0.4
        // added circleLayer to layer
        layer.addSublayer(circleLayer)
        // progressLayer path defined to circularPath
        progressLayer.path = circularPath.cgPath
        // ui edits
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.lineCap = .round
        progressLayer.lineWidth = 4
        progressLayer.strokeEnd = percent
        progressLayer.strokeColor = UIColor.white.cgColor
        // added progressLayer to layer
        layer.addSublayer(progressLayer)
    }
}
