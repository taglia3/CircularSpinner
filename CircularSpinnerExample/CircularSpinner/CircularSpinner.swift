//
//  CircularSpinner.swift
//  CircularSpinnerExample
//
//  Created by Matteo Tagliafico on 15/09/16.
//  Copyright © 2016 Matteo Tagliafico. All rights reserved.
//

import UIKit

@objc public protocol CircularSpinnerDelegate: NSObjectProtocol {
    optional func circularSpinnerTitleForValue(value: Float) -> NSAttributedString
}


public enum CircularSpinnerType {
    case determinate
    case indeterminate
}

private let duration = 2.0
private let strokeRange = (start: 0.0, end: 0.8)

public class CircularSpinner: UIView {
    
    // MARK: - singleton
    static let sharedInstance = CircularSpinner(frame: CGRect.zero)
    
    
    // MARK: - outlets
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var dismissButton: UIButton!
    
    // MARK: - properties
    public weak var delegate: CircularSpinnerDelegate?
    private var mainView: UIView!
    private let nibName = "CircularSpinner"
    
    private var backgroundCircleLayer = CAShapeLayer()
    private var rotationLayer = CAShapeLayer()
    private var progressCircleLayer = CAShapeLayer()
    
    private var startAngle: CGFloat {
        return CGFloat(M_PI_2)
    }
    private var endAngle: CGFloat {
        return 5 * CGFloat(M_PI_2)
    }
    private var arcCenter: CGPoint {
        return CGPointMake(CGRectGetWidth(bounds) / 2, CGRectGetHeight(bounds) / 2)
    }
    private var arcRadius: CGFloat {
        return (min(CGRectGetWidth(bounds), CGRectGetHeight(bounds)) * 0.8) / 2
    }
    private var animationGroup: CAAnimationGroup = {
        var tempGroup = CAAnimationGroup()
        tempGroup.repeatCount = 1
        tempGroup.duration = duration
        return tempGroup
    }()
    private var rotationAnimation: CABasicAnimation = {
        var tempRotation = CABasicAnimation(keyPath: "transform.rotation")
        tempRotation.repeatCount = Float.infinity
        tempRotation.fromValue = 0
        tempRotation.toValue = 1
        tempRotation.cumulative = true
        tempRotation.duration = duration / 2
        return tempRotation
    }()
    
    private var backingValue: Float = 0
    public var value: Float {
        get {
            return backingValue
        }
        set {
            backingValue = min(1, max(0, newValue))
        }
    }
    public var type: CircularSpinnerType = .determinate {
        didSet {
            configureType()
        }
    }
    public var showDismissButton: Bool = true {
        didSet {
            appearanceDismissButton()
        }
    }
    public var lineWidth: CGFloat = 6 {
        didSet {
            appearanceBackgroundLayer()
            appearanceProgressLayer()
        }
    }
    public var bgColor: UIColor = UIColor(colorLiteralRed: 238.0/255, green: 238.0/255, blue: 238.0/255, alpha: 1) {
        didSet {
            appearanceBackgroundLayer()
        }
    }
    public var pgColor: UIColor = UIColor(colorLiteralRed: 47.0/255, green: 177.0/255, blue: 254.0/255, alpha: 1) {
        didSet {
            appearanceProgressLayer()
        }
    }
    
    
    // MARK: - view lifecycle
    public override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
        configure()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func xibSetup() {
        mainView = loadViewFromNib()
        mainView.frame = bounds
        mainView.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        addSubview(mainView)
    }
    
    private func loadViewFromNib() -> UIView {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil).first as! UIView
        return view
    }
    
    
    // MARK: - drawing methods
    public override func drawRect(rect: CGRect) {
        backgroundCircleLayer.path = getCirclePath()
        progressCircleLayer.path = getCirclePath()
    }
    
    private func getCirclePath() -> CGPath {
        return UIBezierPath(arcCenter: arcCenter, radius: arcRadius, startAngle: startAngle, endAngle: endAngle, clockwise: true).CGPath
    }
    
    
    // MARK: - configure
    private func configure() {
        backgroundColor = UIColor.clearColor()
        
        configureBackgroundLayer()
        configureRotationLayer()
        configureProgressLayer()
        configureDismissButton()
        
        if type == .indeterminate {
            makeStrokeAnimationGroup()
            startInderminateAnimation()
        }
    }
    
    private func startInderminateAnimation() {
        progressCircleLayer.addAnimation(animationGroup, forKey: "strokeEnd")
        rotationLayer.addAnimation(rotationAnimation, forKey: rotationAnimation.keyPath)
    }
    
    private func configureBackgroundLayer() {
        backgroundCircleLayer.frame = bounds
        layer.addSublayer(backgroundCircleLayer)
        appearanceBackgroundLayer()
    }
    
    private func configureRotationLayer() {
        rotationLayer.frame = bounds
        layer.addSublayer(rotationLayer)
    }
    
    private func configureProgressLayer() {
        progressCircleLayer.frame = bounds
        rotationLayer.addSublayer(progressCircleLayer)
        appearanceProgressLayer()
    }
    
    private func configureDismissButton() {
        appearanceDismissButton()
    }
    
    private func configureType() {
        progressCircleLayer.strokeEnd = type == .determinate ? 0 : CGFloat(strokeRange.end)
        if type == .indeterminate {
            makeStrokeAnimationGroup()
            startInderminateAnimation()
        }
    }
    
    
    // MARK: - appearance
    private func appearanceBackgroundLayer() {
        backgroundCircleLayer.lineWidth = lineWidth
        backgroundCircleLayer.fillColor = UIColor.clearColor().CGColor
        backgroundCircleLayer.strokeColor = bgColor.CGColor
        backgroundCircleLayer.lineCap = kCALineCapRound
    }
    
    private func appearanceProgressLayer() {
        progressCircleLayer.lineWidth = lineWidth
        progressCircleLayer.fillColor = UIColor.clearColor().CGColor
        progressCircleLayer.strokeColor = pgColor.CGColor
        progressCircleLayer.lineCap = kCALineCapRound
    }
    
    private func appearanceDismissButton() {
        dismissButton.hidden = !showDismissButton
    }
    
    
    // MARK: - methods
    private static func containerView() -> UIView? {
        return UIApplication.sharedApplication().keyWindow
    }
    
    private func updateFrame() {
        if let containerView = CircularSpinner.containerView() {
            CircularSpinner.sharedInstance.frame = containerView.bounds
            backgroundCircleLayer.frame = bounds
            rotationLayer.frame = bounds
            progressCircleLayer.frame = bounds
        }
    }
    
    private func makeStrokeAnimationGroup() {
        var strokeStartAnimation: CABasicAnimation!
        var strokeEndAnimation: CABasicAnimation!
        
        func makeAnimationforKeyPath(keyPath: String) -> CABasicAnimation {
            let tempAnimation = CABasicAnimation(keyPath: keyPath)
            tempAnimation.repeatCount = 1
            tempAnimation.speed = 2.0
            tempAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            
            tempAnimation.fromValue = strokeRange.start
            tempAnimation.toValue =  strokeRange.end
            tempAnimation.duration = duration
            
            return tempAnimation
        }
        strokeEndAnimation = makeAnimationforKeyPath("strokeEnd")
        strokeStartAnimation = makeAnimationforKeyPath("strokeStart")
        strokeStartAnimation.beginTime = duration / 2
        animationGroup.animations = [strokeEndAnimation, strokeStartAnimation, ]
        animationGroup.delegate = self
    }
    
    
    // MARK: - update
    public class func setValue(value: Float, animated: Bool) {
        let spinner = CircularSpinner.sharedInstance
        guard spinner.type == .determinate else { return }
        
        spinner.value = value
        spinner.updateTitleLabel()
        spinner.setStrokeEnd(animated: animated) {
            if value >= 1 {
                CircularSpinner.hide()
            }
        }
    }
    
    private func updateTitleLabel() {
        let spinner = CircularSpinner.sharedInstance
        
        if let attributeStr = spinner.delegate?.circularSpinnerTitleForValue?(value) {
            spinner.titleLabel.attributedText = attributeStr
        } else {
            spinner.titleLabel.text = "\(Int(value * 100))%"
        }
    }
    
    private func setStrokeEnd(animated animated: Bool, completed: (() -> Void)? = nil) {
        let spinner = CircularSpinner.sharedInstance
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        CATransaction.setCompletionBlock({
            completed?()
        })
        
        let strokeAnimation = CABasicAnimation(keyPath: "strokeEnd")
        strokeAnimation.duration = animated ? 0.66 : 0
        strokeAnimation.repeatCount = 1
        strokeAnimation.fromValue = progressCircleLayer.strokeEnd
        strokeAnimation.toValue = CGFloat(spinner.value)
        strokeAnimation.removedOnCompletion = false
        strokeAnimation.fillMode = kCAFillModeRemoved
        strokeAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        progressCircleLayer.addAnimation(strokeAnimation, forKey: "strokeAnimation")
        progressCircleLayer.strokeEnd = CGFloat(spinner.value)
        CATransaction.commit()
    }
    
    
    // MARK: - actions
    @IBAction private func dismissButtonTapped(sender: UIButton?) {
        CircularSpinner.hide()
    }
    
    var currentRotation = 0.0
    let π2 = M_PI * 2
    override public func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        
        progressCircleLayer.strokeEnd = CGFloat(strokeRange.start)
        progressCircleLayer.addAnimation(animationGroup, forKey: "strokeEnd")
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        currentRotation += strokeRange.end * π2
        currentRotation %= π2
        progressCircleLayer.setAffineTransform(CGAffineTransformMakeRotation(CGFloat(currentRotation)))
        progressCircleLayer.strokeEnd = CGFloat(strokeRange.end)
        CATransaction.commit()
        
    }
}


// MARK: - API
extension CircularSpinner {
    
    public class func show(title: String, animated: Bool = true, type: CircularSpinnerType = .determinate, delegate: CircularSpinnerDelegate? = nil) -> CircularSpinner {
        let spinner = CircularSpinner.sharedInstance
        spinner.type = type
        spinner.delegate = delegate
        spinner.updateFrame()
        
        if spinner.superview == nil {
            spinner.alpha = 0
            
            guard let containerView = containerView() else {
                fatalError("\n`UIApplication.keyWindow` is `nil`.")
            }
            
            containerView.addSubview(spinner)
            
            UIView.animateWithDuration(0.33, delay: 0, options: .CurveEaseOut, animations: {
                spinner.alpha = 1
                }, completion: nil)
        }
        return spinner
    }
    
    public class func hide(completion: (() -> Void)? = nil) {
        let spinner = CircularSpinner.sharedInstance
        
        spinner.rotationLayer.removeAllAnimations()
        spinner.progressCircleLayer.removeAllAnimations()
        
        dispatch_async(dispatch_get_main_queue(), {
            if spinner.superview == nil {
                return
            }
            
            UIView.animateWithDuration(0.33, delay: 0, options: .CurveEaseOut, animations: {
                spinner.alpha = 0
                }, completion: {_ in
                    spinner.alpha = 1
                    spinner.removeFromSuperview()
                    completion?()
            })
        })
    }
}
