//
//  PresentCardAnimator.swift

import UIKit

final class PresentCardAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    private let params: Params

    struct Params {
        let fromCardFrame: CGRect
        let fromCell: CardCollectionViewCell
    }

    private let presentAnimationDuration: TimeInterval
    private let springAnimator: UIViewPropertyAnimator
    private var transitionDriver: PresentCardTransitionDriver?

    init(params: Params) {
        self.params = params
        self.springAnimator = PresentCardAnimator.createBaseSpringAnimator(params: params)
        self.presentAnimationDuration = springAnimator.duration
        super.init()
    }

    private static func createBaseSpringAnimator(params: PresentCardAnimator.Params) -> UIViewPropertyAnimator {
        // Damping between 0.7 (far away) and 1.0 (nearer)
        let cardPositionY = params.fromCardFrame.minY
        let distanceToBounce = abs(params.fromCardFrame.minY)
        let extentToBounce = cardPositionY < 0 ? params.fromCardFrame.height : UIScreen.main.bounds.height
        let dampFactorInterval: CGFloat = 0.3
        let damping: CGFloat = 1.0 - dampFactorInterval * (distanceToBounce / extentToBounce)

        // Duration between 0.5 (nearer) and 0.9 (nearer)
        let baselineDuration: TimeInterval = 0.5
        let maxDuration: TimeInterval = 0.9
        let duration: TimeInterval = baselineDuration + (maxDuration - baselineDuration) * TimeInterval(max(0, distanceToBounce) / UIScreen.main.bounds.height)

        let springTiming = UISpringTimingParameters(dampingRatio: damping, initialVelocity: .init(dx: 0, dy: 0))
        return UIViewPropertyAnimator(duration: duration, timingParameters: springTiming)
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return presentAnimationDuration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        transitionDriver = PresentCardTransitionDriver(params: params,
                                                       transitionContext: transitionContext,
                                                       baseAnimator: springAnimator)
        interruptibleAnimator(using: transitionContext).startAnimation()
    }

    func animationEnded(_ transitionCompleted: Bool) {
        transitionDriver = nil
    }

    func interruptibleAnimator(using transitionContext: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {
        return transitionDriver?.animator ?? UIViewPropertyAnimator()
    }
}

final class PresentCardTransitionDriver {

    let animator: UIViewPropertyAnimator

    init?(params: PresentCardAnimator.Params, transitionContext: UIViewControllerContextTransitioning, baseAnimator: UIViewPropertyAnimator) {
        let ctx = transitionContext
        guard let cardDetailView = ctx.view(forKey: .to) else {
            return nil
        }
        let container = ctx.containerView
        let fromCardFrame = params.fromCardFrame

        let animatedContainerView = UIView()
        animatedContainerView.translatesAutoresizingMaskIntoConstraints = false
        if TransitionConstants.isEnabledDebugAnimatingViews {
            animatedContainerView.layer.borderColor = UIColor.yellow.cgColor
            animatedContainerView.layer.borderWidth = 4
            cardDetailView.layer.borderColor = UIColor.red.cgColor
            cardDetailView.layer.borderWidth = 2
        }
        container.addSubview(animatedContainerView)

        do /* Fix centerX/width/height of animated container to container */ {
            let animatedContainerConstraints = [
                animatedContainerView.widthAnchor.constraint(equalToConstant: container.bounds.width),
                animatedContainerView.heightAnchor.constraint(equalToConstant: container.bounds.height),
                animatedContainerView.centerXAnchor.constraint(equalTo: container.centerXAnchor)
            ]
            NSLayoutConstraint.activate(animatedContainerConstraints)
        }

        let animatedContainerVerticalConstraint: NSLayoutConstraint = {
            switch TransitionConstants.cardVerticalExpandingStyle {
            case .fromCenter:
                return animatedContainerView.centerYAnchor.constraint(
                    equalTo: container.centerYAnchor,
                    constant: (fromCardFrame.height / 2 + fromCardFrame.minY) - container.bounds.height / 2
                )
            case .fromTop:
                return animatedContainerView.topAnchor.constraint(equalTo: container.topAnchor, constant: fromCardFrame.minY)
            }

        }()
        animatedContainerVerticalConstraint.isActive = true

        animatedContainerView.addSubview(cardDetailView)
        cardDetailView.translatesAutoresizingMaskIntoConstraints = false

        do /* Pin top (or center Y) and center X of the card, in animated container view */ {
            let verticalAnchor: NSLayoutConstraint = {
                switch TransitionConstants.cardVerticalExpandingStyle {
                case .fromCenter:
                    return cardDetailView.centerYAnchor.constraint(equalTo: animatedContainerView.centerYAnchor)
                case .fromTop:
                    return cardDetailView.topAnchor.constraint(equalTo: animatedContainerView.topAnchor, constant: 0)
                }
            }()
            let cardConstraints = [
                verticalAnchor
            ]
            NSLayoutConstraint.activate(cardConstraints)
        }
        let cardWidthConstraint = cardDetailView.widthAnchor.constraint(equalToConstant: fromCardFrame.width)
        let cardHeightConstraint = cardDetailView.heightAnchor.constraint(equalToConstant: fromCardFrame.height)
        let cardLeadingConstraint = cardDetailView.leadingAnchor.constraint(equalTo: animatedContainerView.leadingAnchor, constant: fromCardFrame.minX)

        NSLayoutConstraint.activate([cardLeadingConstraint, cardWidthConstraint, cardHeightConstraint])

        cardDetailView.layer.cornerRadius = TransitionConstants.cardCornerRadius

        params.fromCell.isHidden = true
        params.fromCell.resetTransform()

        container.layoutIfNeeded()

        func animateContainerBouncingUp() {
            animatedContainerVerticalConstraint.constant = 0
            container.layoutIfNeeded()
        }

        func animateCardDetailViewSizing() {
            cardWidthConstraint.constant = animatedContainerView.bounds.width
            cardHeightConstraint.constant = animatedContainerView.bounds.height
            cardLeadingConstraint.constant = 0
            cardDetailView.layer.cornerRadius = 16
            container.layoutIfNeeded()
        }

        func completeEverything() {
            animatedContainerView.removeConstraints(animatedContainerView.constraints)
            animatedContainerView.removeFromSuperview()

            container.addSubview(cardDetailView)
            cardDetailView.removeConstraints([cardWidthConstraint, cardHeightConstraint])

            // Keep -1 to be consistent with the weird bug above.
            cardDetailView.edges(to: container, top: -1)
            if let movieDetailsViewController = ctx.viewController(forKey: .to)?.children.first as? MovieDetailsViewController {
                movieDetailsViewController.scrollView.isScrollEnabled = true
            }
            let success = !ctx.transitionWasCancelled
            ctx.completeTransition(success)
        }

        baseAnimator.addAnimations {
            animateContainerBouncingUp()
            let cardExpanding = UIViewPropertyAnimator(duration: baseAnimator.duration * 0.6, curve: .linear) {
                animateCardDetailViewSizing()
            }
            cardExpanding.startAnimation()
        }

        baseAnimator.addCompletion { (_) in
            completeEverything()
        }
        animator = baseAnimator
    }
}
