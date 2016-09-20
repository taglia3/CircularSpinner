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
    private var progressCircleLayer = CAShapeLayer()
    
    var indeterminateDuration: Double = 1.5
    
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
    
    private var oldStrokeEnd: Float?
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
    }
    
    public override func willMoveToSuperview(newSuperview: UIView?) {
        super.willMoveToSuperview(newSuperview)
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
        configureProgressLayer()
        configureDismissButton()
        configureType()
    }
    
    private func configureBackgroundLayer() {
        backgroundCircleLayer.bounds = bounds
        layer.addSublayer(backgroundCircleLayer)
        appearanceBackgroundLayer()
    }
    
    private func configureProgressLayer() {
        progressCircleLayer.bounds = bounds
        layer.addSublayer(progressCircleLayer)
        appearanceProgressLayer()
    }
    
    private func configureDismissButton() {
        appearanceDismissButton()
    }
    
    private func configureType() {
        switch type {
        case .indeterminate:
            startInderminateAnimation()
        default:
            oldStrokeEnd = nil
            updateTitleLabel()
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
            
            backgroundCircleLayer.bounds = bounds
            progressCircleLayer.bounds = bounds
            
            backgroundCircleLayer.position = arcCenter
            progressCircleLayer.position = arcCenter
        }
    }
    
    private func generateAnimation() -> CAAnimationGroup {
        let headAnimation = CABasicAnimation(keyPath: "strokeStart")
        headAnimation.beginTime = indeterminateDuration / 3
        headAnimation.fromValue = 0
        headAnimation.toValue = 1
        headAnimation.duration = indeterminateDuration / 1.5
        headAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        
        let tailAnimation = CABasicAnimation(keyPath: "strokeEnd")
        tailAnimation.fromValue = 0
        tailAnimation.toValue = 1
        tailAnimation.duration = indeterminateDuration / 1.5
        tailAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        
        let groupAnimation = CAAnimationGroup()
        groupAnimation.duration = indeterminateDuration
        groupAnimation.repeatCount = Float.infinity
        groupAnimation.animations = [headAnimation, tailAnimation]
        return groupAnimation
    }
    
    private func generateRotationAnimation() -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        animation.fromValue = 0
        animation.toValue = 2 * M_PI
        animation.duration = indeterminateDuration
        animation.repeatCount = Float.infinity
        return animation
    }
    
    private func startInderminateAnimation() {
        progressCircleLayer.addAnimation(generateAnimation(), forKey: "strokeLineAnimation")
        progressCircleLayer.addAnimation(generateRotationAnimation(), forKey: "rotationAnimation")
    }
    
    private func stopInderminateAnimation() {
        progressCircleLayer.removeAllAnimations()
        progressCircleLayer.removeAllAnimations()
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
        strokeAnimation.fromValue = oldStrokeEnd ?? 0
        strokeAnimation.toValue = spinner.value
        strokeAnimation.removedOnCompletion = false
        strokeAnimation.fillMode = kCAFillModeRemoved
        strokeAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        progressCircleLayer.addAnimation(strokeAnimation, forKey: "strokeLineAnimation")
        progressCircleLayer.strokeEnd = CGFloat(spinner.value)
        CATransaction.commit()
        
        oldStrokeEnd = spinner.value
    }
    
    
    // MARK: - actions
    @IBAction private func dismissButtonTapped(sender: UIButton?) {
        CircularSpinner.hide()
    }
}


// MARK: - API
extension CircularSpinner {
    
    public class func show(title: String = "", animated: Bool = true, type: CircularSpinnerType = .determinate, showDismissButton: Bool = true, delegate: CircularSpinnerDelegate? = nil) -> CircularSpinner {
        let spinner = CircularSpinner.sharedInstance
        spinner.type = type
        spinner.delegate = delegate
        spinner.titleLabel.text = title
        spinner.showDismissButton = showDismissButton
        spinner.value = 0
        spinner.updateFrame()
        
        if spinner.superview == nil {
            spinner.alpha = 0
            
            guard let containerView = containerView() else {
                fatalError("UIApplication.keyWindow is nil.")
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
        spinner.stopInderminateAnimation()
        
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
