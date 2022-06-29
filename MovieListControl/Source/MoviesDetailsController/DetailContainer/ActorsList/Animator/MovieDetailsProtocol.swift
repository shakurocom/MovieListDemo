//
//  DetailsViewController.swift
//  ShakuroApp
//

import UIKit
import Foundation

public protocol MovieDetailsProtocol: UIViewController {
    var scrollView: UIScrollView { get }
    var dismissHandler: DismissHandler { get }

    func didStartPresentAnimationProgress()
    func didFinishPresentAnimationProgress()

    func didBeginDismissAnimation()
    func didChangeDismissAnimationProgress(progress: CGFloat)
    func didStartDismissAnimation()
    func didFinishDismissAnimation()
    func didCancelDismissAnimation(progress: CGFloat)
}

private struct AssociatedKeys {
    static var dismissHandlerKey: UInt8 = 0
}

public extension MovieDetailsProtocol {

    var dismissHandler: DismissHandler {
        get {
            if let aDismissHandler = objc_getAssociatedObject(self, &AssociatedKeys.dismissHandlerKey) as? DismissHandler {
                return aDismissHandler
            } else {
                self.dismissHandler = DismissHandler(source: self)
                return dismissHandler
            }
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.dismissHandlerKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    var dismissEnabled: Bool {
        get {
            return dismissHandler.dismissalPanGesture.isEnabled
        }

        set {
            dismissHandler.dismissalPanGesture.isEnabled = newValue
            dismissHandler.dismissalScreenEdgePanGesture.isEnabled = newValue
        }
    }

    func didStartPresentAnimationProgress() {}
    func didFinishPresentAnimationProgress() {}

    func didBeginDismissAnimation() {}
    func didChangeDismissAnimationProgress(progress: CGFloat) {}
    func didStartDismissAnimation() {}
    func didFinishDismissAnimation() {}
    func didCancelDismissAnimation(progress: CGFloat) {}

}
