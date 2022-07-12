//
//  DismissCardAnimator.swift

import UIKit

final class DismissCardAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    struct Params {
        let fromCardFrame: CGRect
        let fromCardFrameWithoutTransform: CGRect
        let fromCell: CardCollectionViewCell
    }

    struct Constants {
        static let relativeDurationBeforeNonInteractive: TimeInterval = 0.5
        static let minimumScaleBeforeNonInteractive: CGFloat = 0.8
    }

    private let params: Params

    init(params: Params) {
        self.params = params
        super.init()
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return TransitionConstants.dismissalAnimationDuration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let ctx = transitionContext
        let container = ctx.containerView

        guard let movieDetailsViewController = ctx.viewController(forKey: .from) as? MovieDetailsViewController,
              let cardDetailView = ctx.view(forKey: .from) else {
            return
        }

        let animatedContainerView = UIView()
        if TransitionConstants.isEnabledDebugAnimatingViews {
            animatedContainerView.layer.borderColor = UIColor.yellow.cgColor
            animatedContainerView.layer.borderWidth = 3
            cardDetailView.layer.borderColor = UIColor.red.cgColor
            cardDetailView.layer.borderWidth = 2
        }
        animatedContainerView.translatesAutoresizingMaskIntoConstraints = false
        cardDetailView.translatesAutoresizingMaskIntoConstraints = false

        container.removeConstraints(container.constraints)

        container.addSubview(animatedContainerView)
        animatedContainerView.addSubview(cardDetailView)

        // Card fills inside animated container view
        cardDetailView.edges(to: animatedContainerView)
        cardDetailView.layer.cornerRadius = TransitionConstants.cardCornerRadius

        let animatedContainerTopConstraint = animatedContainerView.topAnchor.constraint(equalTo: container.topAnchor, constant: 0)
        let animatedContainerLeadingConstraint = animatedContainerView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 0)
        let animatedContainerWidthConstraint = animatedContainerView.widthAnchor.constraint(equalToConstant: cardDetailView.frame.width)
        let animatedContainerHeightConstraint = animatedContainerView.heightAnchor.constraint(equalToConstant: cardDetailView.frame.height)

        NSLayoutConstraint.activate([animatedContainerLeadingConstraint, animatedContainerTopConstraint, animatedContainerWidthConstraint, animatedContainerHeightConstraint])

        // Fix weird top inset
        let topTemporaryFix = movieDetailsViewController.cardContentView.topAnchor.constraint(equalTo: cardDetailView.topAnchor)
        topTemporaryFix.isActive = true
        container.layoutIfNeeded()

        // Force card filling bottom
        let stretchCardToFillBottom = movieDetailsViewController.cardContentView.bottomAnchor.constraint(equalTo: cardDetailView.bottomAnchor)

        func animateCardViewBackToPlace() {
            stretchCardToFillBottom.isActive = true
            // Back to identity
            // NOTE: Animated container view in a way, helps us to not messing up `transform` with `AutoLayout` animation.
            cardDetailView.transform = CGAffineTransform.identity
            animatedContainerLeadingConstraint.constant = self.params.fromCardFrameWithoutTransform.minX
            animatedContainerTopConstraint.constant = self.params.fromCardFrameWithoutTransform.minY
            animatedContainerWidthConstraint.constant = self.params.fromCardFrameWithoutTransform.width
            animatedContainerHeightConstraint.constant = self.params.fromCardFrameWithoutTransform.height
            container.layoutIfNeeded()
        }

        func completeEverything() {
            let success = !ctx.transitionWasCancelled
            animatedContainerView.removeConstraints(animatedContainerView.constraints)
            animatedContainerView.removeFromSuperview()
            if success {
                params.fromCell.isHidden = false
                cardDetailView.removeFromSuperview()
            } else {
                // Remove temporary fixes if not success!
                topTemporaryFix.isActive = false
                stretchCardToFillBottom.isActive = false

                cardDetailView.removeConstraint(topTemporaryFix)
                cardDetailView.removeConstraint(stretchCardToFillBottom)

                container.removeConstraints(container.constraints)

                container.addSubview(cardDetailView)
                cardDetailView.edges(to: container)
            }
            ctx.completeTransition(success)
        }

        UIView.animate(withDuration: transitionDuration(using: ctx),
                       delay: 0, usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 0.0,
                       options: [],
                       animations: {
                        animateCardViewBackToPlace()
        }, completion: { _ in
            completeEverything()
        })

        UIView.animate(withDuration: transitionDuration(using: ctx) * 0.6) {
            movieDetailsViewController.scrollView.contentOffset = .zero
        }
    }
}
