//
//  DismissHandler.swift
//  ShakuroApp

import UIKit
import Foundation

public final class DismissHandler: NSObject {

    private enum Constant {
        static let targetShrinkScale: CGFloat = 0.86
        static let targetCornerRadius: CGFloat = 16
    }

    lazy var dismissalPanGesture: UIPanGestureRecognizer = {
        let pan = UIPanGestureRecognizer()
        pan.maximumNumberOfTouches = 1
        return pan
    }()

    lazy var dismissalScreenEdgePanGesture: UIScreenEdgePanGestureRecognizer = {
        let pan = UIScreenEdgePanGestureRecognizer()
        pan.edges = .left
        return pan
    }()

    private var interactiveStartingPoint: CGPoint?
    private var dismissalAnimator: UIViewPropertyAnimator?
    private var draggingDownToDismiss = false
    private let source: MovieDetailsProtocol
    private var dismissTop = true
    private var lastContentOffset: CGFloat = 0

    init(source: MovieDetailsProtocol) {
        self.source = source
        super.init()

        dismissalPanGesture.addTarget(self, action: #selector(handleDismissalPan(gesture:)))
        dismissalPanGesture.delegate = self

        dismissalScreenEdgePanGesture.addTarget(self, action: #selector(handleDismissalPan(gesture:)))
        dismissalScreenEdgePanGesture.delegate = self

        // Make drag down/scroll pan gesture waits til screen edge pan to fail first to begin
        dismissalPanGesture.require(toFail: dismissalScreenEdgePanGesture)
        source.scrollView.panGestureRecognizer.require(toFail: dismissalScreenEdgePanGesture)

        source.loadViewIfNeeded()
        source.view.addGestureRecognizer(dismissalPanGesture)
        source.view.addGestureRecognizer(dismissalScreenEdgePanGesture)

        checkScrolling(scrollView: source.scrollView)
    }

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        checkScrolling(scrollView: scrollView)
    }

    // This handles both screen edge and dragdown pan. As screen edge pan is a subclass of pan gesture, this input param works.
    @objc func handleDismissalPan(gesture: UIPanGestureRecognizer) {
        guard let targetAnimatedView = gesture.view else {
            return
        }
        _ = gesture.velocity(in: source.view)

        let isScreenEdgePan = gesture.isKind(of: UIScreenEdgePanGestureRecognizer.self)
        let canStartDragDownToDismissPan = !isScreenEdgePan && !draggingDownToDismiss

        guard !canStartDragDownToDismissPan else {
            return
        }

        let startingPoint: CGPoint

        if let point = interactiveStartingPoint {
            startingPoint = point
        } else {
            // Initial location
            startingPoint = gesture.location(in: nil)
            interactiveStartingPoint = startingPoint
        }

        let currentLocation = gesture.location(in: nil)

        let progress: CGFloat
        if dismissTop {
            progress = isScreenEdgePan ? (gesture.translation(in: targetAnimatedView).x / 100) : (currentLocation.y - startingPoint.y) / 100
        } else {
            progress = isScreenEdgePan ? (gesture.translation(in: targetAnimatedView).x / 100) : (startingPoint.y - currentLocation.y) / 100
        }

        switch gesture.state {
        case .began:
            if source.scrollView.contentOffset.y <= 0 {
                dismissTop = true
            }
            dismissalAnimator = createInteractiveDismissalAnimatorIfNeeded(targetAnimatedView: targetAnimatedView,
                                                                           fractionComplete: progress)
            source.didBeginDismissAnimation()
        case .changed:
            dismissalAnimator = createInteractiveDismissalAnimatorIfNeeded(targetAnimatedView: targetAnimatedView,
                                                                           fractionComplete: progress)
            let actualProgress = progress
            let isDismissalSuccess = actualProgress >= 1.0

            dismissalAnimator?.fractionComplete = actualProgress
            if progress >= 0 && progress <= 1 && dismissTop {
                source.scrollView.contentOffset = CGPoint(x: 0, y: 100 * max(progress, 0))
            }
            source.didChangeDismissAnimationProgress(progress: progress)

            if isDismissalSuccess {
                dismissalAnimator?.stopAnimation(false)
                dismissalAnimator?.addCompletion { [weak self] (pos) in
                    switch pos {
                    case .end:
                        self?.didSuccessfullyDragDownToDismiss()
                    default:
                        fatalError("Must finish dismissal at end!")
                    }
                }
                dismissalAnimator?.finishAnimation(at: .end)
            }

        case .ended, .cancelled:
            if dismissalAnimator == nil {
                // Gesture's too quick that it doesn't have dismissalAnimator!
                print("Too quick there's no animator!")
                didCancelDismissalTransition()
                return
            }

            dismissalAnimator?.pauseAnimation()
            dismissalAnimator?.isReversed = true

            source.didCancelDismissAnimation(progress: progress)
            // Disable gesture until reverse closing animation finishes.
            gesture.isEnabled = false
            dismissalAnimator?.addCompletion { [weak self] (_) in
                self?.didCancelDismissalTransition()
                gesture.isEnabled = true
            }
            dismissalAnimator?.startAnimation()
        default:
            fatalError("Impossible gesture state? \(gesture.state.rawValue)")
        }

        do {
            self.lastContentOffset = source.scrollView.contentOffset.y
        }

        source.scrollView.bounces = source.scrollView.contentOffset.y > 100
    }

    // MARK: - Private
    private func didSuccessfullyDragDownToDismiss() {
        source.didStartDismissAnimation()
        source.dismiss(animated: true) {
            self.source.didFinishDismissAnimation()
        }
    }

    private func didCancelDismissalTransition() {
        interactiveStartingPoint = nil
        dismissalAnimator = nil
        draggingDownToDismiss = false
    }

    private func shouldDismiss() -> Bool {
        return source.scrollView.contentOffset.y <= 0
    }

    private func checkScrolling(scrollView: UIScrollView) {
        if shouldDismiss() {
            draggingDownToDismiss = true
        }
        scrollView.showsVerticalScrollIndicator = !draggingDownToDismiss
    }

    private func createInteractiveDismissalAnimatorIfNeeded(targetAnimatedView: UIView,
                                                            fractionComplete: CGFloat) -> UIViewPropertyAnimator {
            if let animator = dismissalAnimator {
                return animator
            } else {
                let animator = UIViewPropertyAnimator(duration: 0, curve: .easeOut, animations: {
                    targetAnimatedView.transform = CGAffineTransform(scaleX: Constant.targetShrinkScale, y: Constant.targetShrinkScale)
                    targetAnimatedView.layer.cornerRadius = Constant.targetCornerRadius
                    targetAnimatedView.clipsToBounds = true
                })
                animator.isReversed = false
                animator.pauseAnimation()
                animator.fractionComplete = fractionComplete
                return animator
            }
        }

}

// MARK: - UIGestureRecognizerDelegate

extension DismissHandler: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        checkScrolling(scrollView: source.scrollView)
        return shouldDismiss()
    }
}
