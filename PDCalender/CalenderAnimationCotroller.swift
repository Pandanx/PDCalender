//
//  CalenderAnimationCotroller.swift
//  PDCalender
//
//  Created by 张晓鑫 on 2017/7/31.
//  Copyright © 2017年 张晓鑫. All rights reserved.
//

import UIKit
import Alamofire

class CalenderAnimationCotroller: NSObject, UIViewControllerAnimatedTransitioning {
    var reverse: Bool?
    var upViewY: CGFloat?
    let screenHeight: CGFloat = UIScreen.main.bounds.height
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5;
    }
    
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let fromVC: UIViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
        let toVC: UIViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
        
        let toView: UIView = toVC.view
        let fromView: UIView = fromVC.view
        
        if self.reverse! {
            self.executeReverseAnimation(transitionContext: transitionContext, fromVC: fromVC, toVC: toVC, fromView: fromView, toView: toView)
        } else {
            self.executeForwardsAnimation(transitionContext: transitionContext, fromVC: fromVC, toVC: toVC, fromView: fromView, toView: toView)
        }
    }
    
    func executeForwardsAnimation(transitionContext: UIViewControllerContextTransitioning, fromVC: UIViewController, toVC: UIViewController, fromView: UIView, toView: UIView) {
        let containerView: UIView = transitionContext.containerView
        containerView.addSubview(fromView)
        fromView.frame = toView.frame.offsetBy(dx: toView.frame.size.width, dy: 0)
        containerView.addSubview(toView)
        
        let upRegion: CGRect = CGRect(x: 0, y: 0, width: fromView.frame.size.width, height: upViewY!)
        let upView: UIView = fromView.resizableSnapshotView(from: upRegion, afterScreenUpdates: false, withCapInsets: .zero)!
        upView.frame = upRegion
        containerView.addSubview(upView)
        
        let downRegion: CGRect = CGRect(x: 0, y: upViewY!, width: fromView.frame.size.width, height: screenHeight - upViewY!)
        let downView: UIView = fromView.resizableSnapshotView(from: downRegion, afterScreenUpdates: false, withCapInsets: .zero)!
        downView.frame = downRegion
        containerView.addSubview(downView)
        
        toView.frame = toView.frame.offsetBy(dx: 0, dy: upViewY!)//TODO
        
        let duration: TimeInterval = self .transitionDuration(using: transitionContext)
        
        UIView.animate(withDuration: duration, delay: 0.0, options: .curveEaseOut, animations: { 
            upView.frame = upView.frame.offsetBy(dx: 0, dy: -self.upViewY!)
            downView.frame = downView.frame.offsetBy(dx: 0, dy: downView.frame.size.height)
            toView.frame = toView.frame.offsetBy(dx: 0, dy: -self.upViewY!)
        }) { (finished) in
            upView.removeFromSuperview()
            downView.removeFromSuperview()
            fromView.frame = containerView.frame
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        
    }
    
    func executeReverseAnimation(transitionContext: UIViewControllerContextTransitioning, fromVC: UIViewController, toVC: UIViewController, fromView: UIView, toView: UIView) {
        let containerView: UIView = transitionContext.containerView
        toView.frame = toView.frame.offsetBy(dx: toView.frame.size.width, dy: 0)
        containerView.addSubview(toView)
        
        let upRegion: CGRect = CGRect(x: 0, y: 0, width: toView.frame.width, height: upViewY!)
        let upView: UIView = toView.resizableSnapshotView(from: upRegion, afterScreenUpdates: false, withCapInsets: UIEdgeInsets.zero)!
        upView.frame = upRegion.offsetBy(dx: 0, dy: -upViewY!)
        containerView.addSubview(upView)
        
        let downRegion: CGRect = CGRect(x: 0, y: upViewY!, width: toView.frame.size.width, height: screenHeight-upViewY!)
        let downView: UIView = toView.resizableSnapshotView(from: downRegion, afterScreenUpdates: false, withCapInsets: .zero)!
        downView.frame = downRegion.offsetBy(dx: 0, dy: screenHeight-upViewY!)
        containerView.addSubview(downView)
        
        let duration:TimeInterval = self.transitionDuration(using: transitionContext)
        
        UIView.animate(withDuration: duration, delay: 0.0, options: .curveEaseOut, animations: { 
            upView.frame = upRegion
            downView.frame = downRegion
            
            fromView.frame = fromView.frame.offsetBy(dx: 0, dy: self.upViewY!)
        }) { (finished) in
            upView.removeFromSuperview()
            downView.removeFromSuperview()
            toView.frame = containerView.frame
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        
    }
}
