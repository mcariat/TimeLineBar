//
//  TimerAudioBar.swift
//  TimerAudioBar
//
//  Created by Cariat Matthieu on 27/12/2017.
//  Copyright © 2017 Cariat Matthieu. All rights reserved.
//

import UIKit

@IBDesignable public class TimeLineBar : UIView {
    
    @IBInspectable var OrientationAdapter: Int{
        get{
            return self.orientation.rawValue
        }set(index){
            let currentIndex: Int = max(index, 0)
            self.orientation = OrientationState(rawValue: currentIndex % 2) ?? .Bottom
        }
    }
    
    @IBInspectable var ScalesQuantity : Int = 6{
        didSet{
            ScalesQuantity = max(ScalesQuantity, 0)
            computeUtilitiesValues()
            #if TARGET_INTERFACE_BUILDER
                self.drawMeterLayer()
                self.drawTimerLabels()
            #endif
        }
    }
    
    @IBInspectable var ScalesBorderMarging: CGFloat = 0{
        didSet{
            ScalesBorderMarging = min(ScalesBorderMarging, self.frame.height / 3)
            ScalesBorderMarging = max(ScalesBorderMarging, 0)
            #if TARGET_INTERFACE_BUILDER
                self.drawMeterLayer()
                self.drawTimerLabels()
            #endif
        }
    }
    
    @IBInspectable var intervalQuantity : Int = 2{
        didSet{
            intervalQuantity = max(intervalQuantity, 0)
            computeUtilitiesValues()
            #if TARGET_INTERFACE_BUILDER
                self.drawMeterLayer()
                self.drawTimerLabels()
            #endif
        }
    }
    
    @IBInspectable var intervalsBarHeightPercentage : CGFloat = 25{
        didSet{
            intervalsBarHeightPercentage = min(intervalsBarHeightPercentage, 100)
            intervalsBarHeightPercentage = max(intervalsBarHeightPercentage, 0)
            computeUtilitiesValues()
            #if TARGET_INTERFACE_BUILDER
                self.drawMeterLayer()
                self.drawTimerLabels()
            #endif
        }
    }
    
    @IBInspectable var drawWidth : CGFloat = 1{
        didSet{
            drawWidth = min(drawWidth, 20)
            drawWidth = max(drawWidth, 0)
            #if TARGET_INTERFACE_BUILDER
                self.drawMeterLayer()
                self.drawTimerLabels()
            #endif
        }
    }
    
    @IBInspectable var drawColor: UIColor = .black{
        didSet{
            #if TARGET_INTERFACE_BUILDER
                drawMeterLayer()
            #endif
        }
    }
    
    @IBInspectable var timeLayerEnabled: Bool = false
    @IBInspectable var timeIncrementationValue : Double = 1{
        didSet{
            computeUtilitiesValues()
            #if TARGET_INTERFACE_BUILDER
                self.drawMeterLayer()
                self.drawTimerLabels()
            #endif
        }
    }
    
    @IBInspectable var fontColor: UIColor = .black
    @IBInspectable var fontSize : CGFloat = 20{
        didSet{
            computeUtilitiesValues()
            #if TARGET_INTERFACE_BUILDER
                self.drawMeterLayer()
                self.drawTimerLabels()
            #endif
        }
    }
    
    @IBInspectable var scrollViewBounceEnabled: Bool = false
    
    private var orientation : OrientationState = .Bottom{
        didSet{
            #if TARGET_INTERFACE_BUILDER
                self.drawMeterLayer()
                self.drawTimerLabels()
            #endif
        }
    }
    
    private var heightIntervalsBar : CGFloat = 10
    public private(set) var widthOfScales : CGFloat = 50
    public var timeIncrement: Double{
        return self.timeIncrementationValue
    }
    private var maxFontSize : CGFloat = 20
    private let ratioFontSizePerWidth : CGFloat = 2.75
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        computeUtilitiesValues()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        computeUtilitiesValues()
    }
    
    override public func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        computeUtilitiesValues()
        drawMeterLayer()
        drawTimerLabels()
    }
    
    private func computeUtilitiesValues(){
        self.widthOfScales = UIScreen.main.bounds.width / CGFloat(self.ScalesQuantity)
        self.maxFontSize = self.widthOfScales / self.ratioFontSizePerWidth
        if(self.fontSize > self.maxFontSize){
            self.fontSize = self.maxFontSize
        }
        self.heightIntervalsBar = ((self.frame.height / 2) * intervalsBarHeightPercentage) / 100
    }
    
    override public func draw(_ rect: CGRect) {
        super.draw(rect)
        drawMeterLayer()
        drawTimerLabels()
    }
    
    private func drawMeterLayer(){
        self.layer.sublayers?.removeAll()
        var backgrounfFrame = self.frame
        var i : Int = 0
        
        if(scrollViewBounceEnabled){
            i = -(ScalesQuantity * 2)
            self.frame = CGRect(origin: self.frame.origin, size: CGSize(width: self.frame.width + (self.bounds.width * 2), height: self.frame.height))
            backgrounfFrame = CGRect(x: -widthOfScales * CGFloat(ScalesQuantity * 2), y: self.frame.origin.y, width: self.frame.width + (self.bounds.width * 2), height: self.frame.height)
        }
        
        let backgroundLayer : CAShapeLayer = CAShapeLayer(path: UIBezierPath(rect: backgrounfFrame), fillColor: self.backgroundColor)
        self.layer.addSublayer(backgroundLayer)
        let path : UIBezierPath = UIBezierPath()
        while (self.widthOfScales * CGFloat(i) <= self.frame.width) {
            for j in 0...self.intervalQuantity{
                if(self.widthOfScales * CGFloat(i) + ((self.widthOfScales * CGFloat(j))/(CGFloat(self.intervalQuantity) + 1.0)) > self.frame.width){break}
                computePath(forPath: path, atScale: i, atBar: j)
            }
            i += 1
        }
        let layer : CAShapeLayer = CAShapeLayer(path: path, color: self.drawColor, lineWidth: drawWidth)
        self.layer.addSublayer(layer)
        
    }
    
    private func drawTimerLabels(){
        if !timeLayerEnabled{
            return
        }
        var i : Int = 0
        while (self.widthOfScales * CGFloat(i) < self.frame.width) {
            let timerLayer : CATextLayer = CATextLayer()
            timerLayer.fontSize = self.fontSize
            switch orientation{
            case .Top:
                timerLayer.frame = CGRect(x: self.widthOfScales * CGFloat(i) + 2, y: (self.frame.height - timerLayer.fontSize - 2), width: self.widthOfScales, height: timerLayer.fontSize + 2)
                break
            case .Bottom:
                timerLayer.frame = CGRect(x: self.widthOfScales * CGFloat(i) + 2, y: 0, width: self.widthOfScales, height: timerLayer.fontSize)
                break
            }
            timerLayer.string = computeTime(atScale: i)
            timerLayer.foregroundColor = self.fontColor.cgColor
            timerLayer.contentsScale = UIScreen.main.scale;
            self.layer.addSublayer(timerLayer)
            i += 1
        }
    }
    
    private func computeTime(atScale index :Int)->String{
        let second : Int = Int((timeIncrementationValue * Double(index)).truncatingRemainder(dividingBy: 60.0))
        let minute : Int = Int((timeIncrementationValue * Double(index)) / 60.0)
        return "\(String(format:"%.2i",minute)):\(String(format:"%.2i",second))"
    }
    
    private func computePath(forPath path: UIBezierPath,atScale index: Int, atBar subindex : Int ){
        let x = self.widthOfScales * CGFloat(index) + ((self.widthOfScales * CGFloat(subindex))/(CGFloat(self.intervalQuantity + 1)))
        switch self.orientation{
        case .Top:
            path.move(to: CGPoint(x: x, y: 0))
            if(subindex == 0){
                path.addLine(to: CGPoint(x: x, y: self.frame.height - ScalesBorderMarging ))
            }else{
                path.addLine(to: CGPoint(x: x, y: (0 + self.heightIntervalsBar) ))
            }
            break
        case .Bottom:
            path.move(to: CGPoint(x: x, y: self.frame.height))
            if(subindex == 0){
                path.addLine(to: CGPoint(x: x, y: 0 + ScalesBorderMarging ))
            }else{
                path.addLine(to: CGPoint(x: x, y: (self.frame.height - self.heightIntervalsBar) ))
            }
            break
        }
    }
    
}

extension TimeLineBar{
    public enum OrientationState : Int {
        case Bottom
        case Top
    }
}

extension TimeLineBar{
    public func getScalesQuantity()->CGFloat{
        return self.frame.width / self.widthOfScales
    }
    
    public func setTimeByScale(_ timeByScale: Double){
        self.timeIncrementationValue = timeByScale
    }
    
}



// MARK: - Easy creation of CAshapeLayer.
extension CAShapeLayer{
    
    /// Create CAShapeLayer with a path, a color and a line width.
    ///
    /// - Parameters:
    ///   - path: Need UIBezierPath.
    ///   - color: Need UIColor.
    ///   - lineWidth: Need CGFloat.
    convenience init(path: UIBezierPath,color: UIColor , lineWidth: CGFloat){
        self.init()
        self.lineWidth = lineWidth
        self.path = path.cgPath
        self.strokeColor = color.cgColor
        self.fillColor = UIColor.white.withAlphaComponent(0).cgColor
    }
    
    convenience init(path: UIBezierPath,fillColor: UIColor?){
        self.init()
        self.path = path.cgPath
        self.fillColor = fillColor?.cgColor
    }
}

