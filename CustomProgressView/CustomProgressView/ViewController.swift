//
//  AppDelegate.swift
//  CustomProgressView
//
//  Created by Rajesh on 30/08/18.
//  Copyright © 2018 Rajesh. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK:- Variable Declaration
    let circularProgressLayer = CAShapeLayer()
    let circularTracklayer = CAShapeLayer()
    let linearProgressLayer = CAShapeLayer()
    let linearTracklayer = CAShapeLayer()
    
    //MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.cirularProgress()
        self.linearProgress()
    }
    
    //MARK: - Circular Progress
    func cirularProgress()
    {
        let radius: Int = 100
        
        var circlePath = UIBezierPath()
        
        //-- Draw circle
        circlePath = UIBezierPath(arcCenter: CGPoint(x: 100, y: 50), radius: CGFloat(radius), startAngle: CGFloat(135.0).degreesToRadians, endAngle: CGFloat(45.0).degreesToRadians, clockwise: true)
        
        //-- Track layer (Inner Layer)
        circularTracklayer.path = circlePath.cgPath
        circularTracklayer.position = CGPoint(x: CGFloat(view.frame.midX - 100), y: CGFloat(view.frame.midY - 100))
        circularTracklayer.fillColor = UIColor.clear.cgColor
        circularTracklayer.strokeColor = self.hexStringToUIColor(hex: "f2f2f2").cgColor//f2f2f2
        circularTracklayer.lineWidth = 8
        circularTracklayer.lineCap = kCALineCapRound
        view.layer.addSublayer(circularTracklayer)
        
        //-- Progress layer (Upper Layer)
        circularProgressLayer.path = circularTracklayer.path
        circularProgressLayer.position = circularTracklayer.position
        circularProgressLayer.fillColor = UIColor.clear.cgColor
        circularProgressLayer.strokeColor = UIColor.purple.cgColor
        circularProgressLayer.lineWidth = 8
        circularProgressLayer.lineCap = kCALineCapRound
        view.layer.addSublayer(circularProgressLayer)
        
        //-- Animate progress layer with fill color
        self.fillProgressLayerWithAnimation(layer: circularProgressLayer, fromValue: 0.0, toValue: 0.8)
        
        //-- Apply gradient color to progress layer for fill color
        self.applyGradientFillColor(layer: circularProgressLayer, gradientColorsArray: [self.hexStringToUIColor(hex: "9c5fb8").cgColor, self.hexStringToUIColor(hex: "ee6495").cgColor, self.hexStringToUIColor(hex: "f87a60").cgColor])
    }
    
    //MARK: - Linear Progress
    func linearProgress()
    {
        
        //-- Draw line
        let linePath = UIBezierPath()
        //-- Start position of x,y
        linePath.move(to: CGPoint(x: 20, y: 50))
        //-- End position of x,y
        linePath.addLine(to: CGPoint(x: view.frame.size.width - 20, y: 50))
        
        //-- Track layer (Inner Layer)
        linearTracklayer.path = linePath.cgPath
        linearTracklayer.fillColor = UIColor.clear.cgColor
        linearTracklayer.strokeColor = self.hexStringToUIColor(hex: "f2f2f2").cgColor//f2f2f2
        linearTracklayer.lineWidth = 10
        linearTracklayer.lineCap = kCALineCapRound
        view.layer.addSublayer(linearTracklayer)
        
        //-- Progress layer (Upper Layer)
        linearProgressLayer.path = linearTracklayer.path
        linearProgressLayer.fillColor = nil
        linearProgressLayer.opacity = 1.0
        linearProgressLayer.lineWidth = 10
        linearProgressLayer.strokeColor = UIColor.red.cgColor
        linearProgressLayer.lineCap = kCALineCapRound
        view.layer.addSublayer(linearProgressLayer)
        
        //-- Animate progress layer with fill color
        self.fillProgressLayerWithAnimation(layer: linearProgressLayer, fromValue: 0.0, toValue: 0.6)
        
        //-- Apply gradient color to progress layer for fill color
        self.applyGradientFillColor(layer: linearProgressLayer, gradientColorsArray: [self.hexStringToUIColor(hex: "9c5fb8").cgColor, self.hexStringToUIColor(hex: "ee6495").cgColor, self.hexStringToUIColor(hex: "f87a60").cgColor])
    }
    
}

//MARK:- CAShapeLayer Properties
extension ViewController
{
    func fillProgressLayerWithAnimation(layer : CAShapeLayer, fromValue: Float, toValue: Float)
    {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = 1.0
        // Animate from 0 (no circle) to 1 (full circle)
        animation.fromValue = fromValue
        animation.toValue = toValue
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        layer.strokeEnd = CGFloat(toValue)
        layer.add(animation, forKey: "animateStroke")
    }
    
    func applyGradientFillColor(layer : CAShapeLayer, gradientColorsArray: [CGColor])
    {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.frame
        gradientLayer.colors = gradientColorsArray
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        view.layer.addSublayer(gradientLayer)
        //-- Using arc as a mask instead of adding it as a sublayer.
        gradientLayer.mask = layer
    }
}

//MARK:- HexString TO UIColor
extension ViewController
{
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#"))
        {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.characters.count) != 6)
        {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}

extension FloatingPoint {
    var degreesToRadians: Self { return self * .pi / 180 }
    var radiansToDegrees: Self { return self * 180 / .pi }
}

