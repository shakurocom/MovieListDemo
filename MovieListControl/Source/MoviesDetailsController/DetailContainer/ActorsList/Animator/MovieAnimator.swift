//
//  Animator.swift
//  CustomTransitionTutorial

import UIKit

final class MovieAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    private enum Constant {
        static let duration = 0.3
        static let cornerRadius: CGFloat = 16
    }

    private let type: PresentationType
    private let firstViewController: ActorListViewController
    private let secondViewController: ActorDetailsViewController
    private let cellImageViewRect: CGRect

    private var selectedCellImageViewSnapshot: UIView

    init?(type: PresentationType, firstViewController: ActorListViewController, secondViewController: ActorDetailsViewController, selectedCellImageViewSnapshot: UIView) {
        self.type = type
        self.firstViewController = firstViewController
        self.secondViewController = secondViewController
        self.selectedCellImageViewSnapshot = selectedCellImageViewSnapshot

        guard let window = firstViewController.view.window ?? secondViewController.view.window,
              let selectedCell = firstViewController.selectedCell else {
            return nil
        }
        cellImageViewRect = selectedCell.actorImageView.convert(selectedCell.actorImageView.bounds, to: window)
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return Constant.duration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView

        guard let toView = secondViewController.view else {
            transitionContext.completeTransition(false)
            return
        }

        containerView.addSubview(toView)

        guard let selectedCell = firstViewController.selectedCell,
              let window = firstViewController.view.window ?? secondViewController.view.window,
              let cellImageSnapshot = selectedCell.actorImageView.snapshotView(afterScreenUpdates: true),
              let controllerImageSnapshot = secondViewController.photoImageView.snapshotView(afterScreenUpdates: true) else {
            transitionContext.completeTransition(true)
            return
        }

        let isPresenting = type.isPresenting

        let backgroundView: UIView
        let fadeView = UIView(frame: containerView.bounds)
        fadeView.backgroundColor = secondViewController.view.backgroundColor

        if isPresenting {
            selectedCellImageViewSnapshot = cellImageSnapshot
            backgroundView = UIView(frame: containerView.bounds)
            backgroundView.addSubview(fadeView)
            fadeView.alpha = 0
        } else {
            backgroundView = firstViewController.view.snapshotView(afterScreenUpdates: true) ?? fadeView
            backgroundView.addSubview(fadeView)
        }

        toView.alpha = 0

        [backgroundView, selectedCellImageViewSnapshot, controllerImageSnapshot].forEach { containerView.addSubview($0) }

        let controllerImageViewRect = secondViewController.photoImageView.convert(secondViewController.photoImageView.bounds, to: window)
        let centerImageViewRect = CGRect(x: controllerImageViewRect.midX / 2,
                                         y: controllerImageViewRect.midY / 2,
                                         width: controllerImageViewRect.size.width / 2,
                                         height: controllerImageViewRect.size.height / 2)

        [selectedCellImageViewSnapshot, controllerImageSnapshot].forEach {
            $0.frame = isPresenting ? cellImageViewRect : controllerImageViewRect
            $0.layer.cornerRadius = isPresenting ? Constant.cornerRadius : 0
            $0.layer.masksToBounds = true
        }

        UIView.animateKeyframes(withDuration: Constant.duration, delay: 0, options: .calculationModeCubic, animations: {
            if isPresenting {
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.3) {
                    self.selectedCellImageViewSnapshot.frame = isPresenting ? centerImageViewRect : self.cellImageViewRect
                    controllerImageSnapshot.frame = isPresenting ? centerImageViewRect : self.cellImageViewRect
                    fadeView.alpha = isPresenting ? 1 : 0

                    [controllerImageSnapshot, self.selectedCellImageViewSnapshot].forEach {
                        $0.layer.cornerRadius = isPresenting ? 0 : Constant.cornerRadius
                    }
                }
                UIView.addKeyframe(withRelativeStartTime: 0.4, relativeDuration: 1) {
                    self.selectedCellImageViewSnapshot.frame = isPresenting ? controllerImageViewRect : self.cellImageViewRect
                    controllerImageSnapshot.frame = isPresenting ? controllerImageViewRect : self.cellImageViewRect
                    fadeView.alpha = isPresenting ? 1 : 0
                }
            } else {
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1) {
                    self.selectedCellImageViewSnapshot.frame = isPresenting ? controllerImageViewRect : self.cellImageViewRect
                    controllerImageSnapshot.frame = isPresenting ? controllerImageViewRect : self.cellImageViewRect
                    fadeView.alpha = isPresenting ? 1 : 0

                    [controllerImageSnapshot, self.selectedCellImageViewSnapshot].forEach {
                        $0.layer.cornerRadius = isPresenting ? 0 : Constant.cornerRadius
                    }
                }
            }
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.6) {
                self.selectedCellImageViewSnapshot.alpha = isPresenting ? 0 : 1
                controllerImageSnapshot.alpha = isPresenting ? 1 : 0
            }

        }, completion: { _ in
            self.selectedCellImageViewSnapshot.removeFromSuperview()
            controllerImageSnapshot.removeFromSuperview()
            backgroundView.removeFromSuperview()
            toView.alpha = 1

            transitionContext.completeTransition(true)
        })
    }
}

enum PresentationType {

    case present
    case dismiss

    var isPresenting: Bool {
        return self == .present
    }
}
