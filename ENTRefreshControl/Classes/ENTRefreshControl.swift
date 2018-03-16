//
//  ENTRefreshControl.swift
//  CreateLink
//
//  Created by mac on 3/15/18.
//  Copyright © 2018 mac. All rights reserved.
//

import UIKit
public enum Speed: CGFloat {
    case same = 0.85
    case half = 1.2
    case double = 0.5
}
public enum PullState{
    case up
    case down
    case loading
    case none
}
public typealias ENTRefreshControlPullStateResponse = (PullState, CGRect)->()
public class ENTRefreshControl: UIRefreshControl {
    
    //MARK: - Private Properties/Methods
    fileprivate var shouldEndRefresh = true
    fileprivate var isAnimating = false
    fileprivate var yAxis: CGFloat {
        return frame.origin.y
    }
    fileprivate var currentState = PullState.none
    fileprivate func rotateView(_ angle: CGFloat, _ view: UIView) {
        let radians = angle / 180.0 * CGFloat(Double.pi)
        let rotation = self.transform.rotated(by: radians)
        view.transform = rotation
    }
    var previous: CGFloat = 0
    fileprivate func changeLoaderViewsDirection(_ frame: CGRect) {
        if let view = loaderView {
            if !isAnimating {
                if let state = self.pullState {
                    if yAxis > previous {
                        currentState = .up
                    }else {
                        currentState = .down
                    }
                    previous = yAxis
                    invokeCurrentState
                }else {
                    if yAxis < -3 {
                        rotateView(yAxis / rotationSpeed.rawValue, view)
                        view.isHidden = false
                    }else {
                        rotateView(0, view)
                        view.isHidden = true
                    }
                }
            }
        }
    }
    
    @available(iOS 10.0, *)
    fileprivate var vibrateDevice: Void {
        if shouldVibrate {
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()
        }
        return
    }
    
    //MARK: - Public Properties/Methods
    public var rotationSpeed = Speed.same
    
    public var shouldVibrate: Bool = false {
        didSet{
            if #available(iOS 10.0, *) {
                self.vibrateDevice
            }
        }
    }
    public var loaderView: UIView? {
        willSet(newValue) {
            if newValue != nil {
                self.alpha = 0
            }else {
                self.alpha = 1
            }
            changeLoaderViewsDirection(frame)
        }
    }
    
    public var startRotate: Void {
        let duration: Double = 1.5
        if loaderView?.layer.animation(forKey: kRotationAnimationKey) == nil {
            let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
            rotationAnimation.fromValue = 0.0
            rotationAnimation.toValue = Float.pi * 2.0
            rotationAnimation.duration = duration
            rotationAnimation.repeatCount = Float.infinity
            loaderView?.layer.add(rotationAnimation, forKey: kRotationAnimationKey)
        }
        return
    }
    public var stopRotate: Void {
        if loaderView?.layer.animation(forKey: kRotationAnimationKey) != nil {
            loaderView?.layer.removeAnimation(forKey: kRotationAnimationKey)
        }
    }
    public var pullState: ENTRefreshControlPullStateResponse?
    
    
    //MARK: - Public Overrides
    var invokeCurrentState: Void {
        if let state = self.pullState {
            state(self.currentState, frame)
        }
    }
    override public func beginRefreshing() {
        currentState = .loading
        loaderView?.isHidden = false
        startRotate
        super.beginRefreshing()
        shouldEndRefresh = true
        isAnimating = true
        invokeCurrentState
        endRefreshing()
    }
    override public  var isRefreshing: Bool {
        return isAnimating
    }
    override public  func endRefreshing() {
        if shouldEndRefresh {
            super.endRefreshing()
            shouldEndRefresh = false
            return
        }
        currentState = .none
        loaderView?.isHidden = true
        stopRotate
        isAnimating = false
        super.endRefreshing()
        invokeCurrentState
    }
    override public init() {
        super.init()
        addTarget(self, action: #selector(beginRefreshing), for: .valueChanged)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private let kRotationAnimationKey = "rotationanimationkey"
    
    override public  var frame: CGRect {
        didSet{
            changeLoaderViewsDirection(frame)
        }
    }
}

