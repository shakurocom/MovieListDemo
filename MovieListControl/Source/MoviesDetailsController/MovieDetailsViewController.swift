//
//  MovieDetailsViewController.swift
//  ShakuroApp

import UIKit

class MovieDetailsViewController: UIViewController {

    private enum ContentMode {
        case showtimes
        case details
        case comingSoon
    }

    private enum Constant {
        static let targetShrinkScale: CGFloat = 0.86
        static let targetCornerRadius: CGFloat = TransitionConstants.cardCornerRadius
    }

    @IBOutlet var cardContentView: CardContentView!
    @IBOutlet var scrollView: UIScrollView!

    @IBOutlet private var countryLabel: UILabel!
    @IBOutlet private var buttonContainer: UIView!
    @IBOutlet private var showtimesButton: ContentModeSelectButton!
    @IBOutlet private var detailsButton: ContentModeSelectButton!
    @IBOutlet private var comingSoonLabel: UILabel!

    @IBOutlet private var movieShowtimesContainer: MovieShowtimesContainer!
    @IBOutlet private var movieDetailsContainer: MovieDetailsContainer!
    @IBOutlet private var movieShowtimesContainerHeight: NSLayoutConstraint!
    @IBOutlet private var movieDetailsContainerHeight: NSLayoutConstraint!
    @IBOutlet private var comingSoonHeight: NSLayoutConstraint!

    var unhighlightedCardViewModel: MovieItem!
    var movie: MovieItem!
    var transition: CardTransition?
    var fromCardContentViewMode: CardContentView.Mode = .header

    private var contentMode: ContentMode = .showtimes
    private var draggingDownToDismiss = false
    private var interactiveStartingPoint: CGPoint?
    private var dismissalAnimator: UIViewPropertyAnimator?

    private lazy var dismissalPanGesture: UIPanGestureRecognizer = {
        let pan = UIPanGestureRecognizer()
        pan.maximumNumberOfTouches = 1
        return pan
    }()

    private lazy var dismissalScreenEdgePanGesture: UIScreenEdgePanGestureRecognizer = {
        let pan = UIScreenEdgePanGestureRecognizer()
        pan.edges = .left
        return pan
    }()

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        scrollView.delegate = self
        scrollView.contentInsetAdjustmentBehavior = .never

        cardContentView.delegate = self
        cardContentView.setupUIForMode(mode: .details)
        cardContentView.setMovieItem(movieItem: movie)

        dismissalPanGesture.addTarget(self, action: #selector(handleDismissalPan(gesture:)))
        dismissalPanGesture.delegate = self
        dismissalScreenEdgePanGesture.addTarget(self, action: #selector(handleDismissalPan(gesture:)))
        dismissalScreenEdgePanGesture.delegate = self

        // Make drag down/scroll pan gesture waits til screen edge pan to fail first to begin
        dismissalPanGesture.require(toFail: dismissalScreenEdgePanGesture)
        scrollView.panGestureRecognizer.require(toFail: dismissalScreenEdgePanGesture)

        view.addGestureRecognizer(dismissalPanGesture)
        view.addGestureRecognizer(dismissalScreenEdgePanGesture)

        setup()

        toggleMode(animated: false)
        selectModeButton(showtimesButton)

        movieDetailsContainer.detailsView.delegate = self
        movieDetailsContainer.detailsView.setDetailsView(movie: movie)
        movieShowtimesContainer.showtimesView.setShowtimesView(movie: movie)

        movieDetailsContainerHeight.constant = movieDetailsContainer.detailsView.frame.size.height
        movieShowtimesContainerHeight.constant = movieShowtimesContainer.showtimesView.frame.size.height

        comingSoonLabel.text = NSLocalizedString("Coming soon!", comment: "")
        comingSoonLabel.textAlignment = .center
        comingSoonLabel.font = CinemaStyleSheet.FontFace.poppinsSemiBold.fontWithSize(24)
        comingSoonHeight.constant = 200
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        switch contentMode {
        case .showtimes:
            movieShowtimesContainerHeight.constant = movieShowtimesContainer.showtimesView.frame.size.height
        case .details:
            movieDetailsContainerHeight.constant = movieDetailsContainer.detailsView.frame.size.height
        case .comingSoon:
            break
        }
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        scrollView.scrollIndicatorInsets = .init(top: cardContentView.bounds.height, left: 0, bottom: 0, right: 0)
        if TransitionConstants.isEnabledTopSafeAreaInsetsFixOnCardDetailViewController {
            additionalSafeAreaInsets = UIEdgeInsets(top: max(-view.safeAreaInsets.top, 0), left: 0, bottom: 0, right: 0)
        }
    }

    @objc func handleDismissalPan(gesture: UIPanGestureRecognizer) {
        let isScreenEdgePan = gesture.isKind(of: UIScreenEdgePanGestureRecognizer.self)
        let canStartDragDownToDismissPan = !isScreenEdgePan && !draggingDownToDismiss

        guard let targetAnimatedView = gesture.view, !canStartDragDownToDismissPan else {
            return
        }

        let startingPoint: CGPoint
        if let point = interactiveStartingPoint {
            startingPoint = point
        } else {
            startingPoint = gesture.location(in: nil)
            interactiveStartingPoint = startingPoint
        }

        let currentLocation = gesture.location(in: nil)
        let progress = isScreenEdgePan ? (gesture.translation(in: targetAnimatedView).x / 100) : (currentLocation.y - startingPoint.y) / 100

        switch gesture.state {
        case .began:
            dismissalAnimator = createInteractiveDismissalAnimatorIfNeeded(targetAnimatedView: targetAnimatedView, progress: progress)

        case .changed:
            dismissalAnimator = createInteractiveDismissalAnimatorIfNeeded(targetAnimatedView: targetAnimatedView, progress: progress)

            let actualProgress = progress
            let isDismissalSuccess = actualProgress >= 1.0

            dismissalAnimator?.fractionComplete = actualProgress

            if isDismissalSuccess {
                dismissalAnimator?.stopAnimation(false)
                dismissalAnimator?.addCompletion { [weak self] (pos) in
                    switch pos {
                    case .end:
                        self?.dissmiss()
                    default:
                        fatalError("Must finish dismissal at end!")
                    }
                }
                dismissalAnimator?.finishAnimation(at: .end)
            }

        case .ended, .cancelled:
            targetAnimatedView.clipsToBounds = false
            if dismissalAnimator == nil {
                print("Too quick there's no animator!")
                didCancelDismissalTransition()
                return
            }

            // Ended, Animate back to start
            dismissalAnimator?.pauseAnimation()
            dismissalAnimator?.isReversed = true

            gesture.isEnabled = false
            dismissalAnimator?.addCompletion { [weak self] _ in
                self?.didCancelDismissalTransition()
                gesture.isEnabled = true
            }
            dismissalAnimator?.startAnimation()
        default:
            fatalError("Impossible gesture state? \(gesture.state.rawValue)")
        }
    }

    // MARK: - Actions

    @IBAction private func showtimesDidPress(_ sender: UIButton) {
        contentMode = .showtimes
        toggleMode(animated: false)
        selectModeButton(sender)
    }

    @IBAction private func detailsDidPress(_ sender: UIButton) {
        contentMode = movie.hasDetails ? .details : .comingSoon
        toggleMode(animated: false)
        selectModeButton(sender)
    }
}

extension MovieDetailsViewController: DetailsViewDelegate {
    func detailsViewMorePhotosDidPress(_ detailsView: DetailsView) {
        let viewController = PhotosViewController(nibName: "PhotosViewController", bundle: Bundle.findBundleIfNeeded(for: PhotosViewController.self))
        viewController.modalPresentationStyle = .custom
        present(viewController, animated: true)
    }

    func detailsViewActorsDidPress(_ detailsView: DetailsView) {
        let viewController = ActorListViewController(nibName: "ActorListViewController", bundle: Bundle.findBundleIfNeeded(for: ActorListViewController.self))
        viewController.actorItems = movie.actor
        viewController.modalPresentationStyle = .custom
        present(viewController, animated: true)
    }

    func detailsViewTrailerDidPress(_ detailsView: DetailsView) {
        guard let url = URL(string: "https://www.imdb.com/video/vi2273816345?ref_=nv_sr_srsg_1") else {
            return
        }
        UIApplication.shared.open(url)
    }

}

// MARK: - CardContentViewDelegate

extension MovieDetailsViewController: CardContentViewDelegate {
    func cardContentView(_ cardContentView: CardContentView, didPressCloseButton: UIButton) {
        dissmiss()
    }
}

// MARK: - UIScrollViewDelegate

extension MovieDetailsViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if draggingDownToDismiss || (scrollView.isTracking && scrollView.contentOffset.y < 0) {
            draggingDownToDismiss = true
            scrollView.contentOffset = .zero
        }
        scrollView.showsVerticalScrollIndicator = !draggingDownToDismiss
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if velocity.y > 0 && scrollView.contentOffset.y <= 0 {
            scrollView.contentOffset = .zero
        }
    }

}

// MARK: - UIGestureRecognizerDelegate

extension MovieDetailsViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

// MARK: - Private

private extension MovieDetailsViewController {

    private func setup() {
        countryLabel.text = movie.info
        countryLabel.font = CinemaStyleSheet.FontFace.poppinsMedium.fontWithSize(12)

        buttonContainer.layer.cornerRadius = 8

        let selectedTint = UIColor.white
        let normalTint = UIColor.loadColorFromBundle(name: "cinemaText500")
        let selectedBackground = UIColor.loadColorFromBundle(name: "BlueButton")
        let normalBackground = UIColor.white

        let buttonFont = CinemaStyleSheet.FontFace.poppinsSemiBold.fontWithSize(16)
        [showtimesButton, detailsButton].forEach { (button: ContentModeSelectButton) in
            button.setTitleColor(normalTint, for: .normal)
            button.setTitleColor(normalTint, for: [.normal, .highlighted])
            button.setTitleColor(selectedTint, for: .selected)
            button.setTitleColor(selectedTint, for: [.selected, .highlighted])
            button.titleLabel?.font = buttonFont
            button.titleLabel?.textAlignment = .center
            button.selectedBackgroundColor = selectedBackground
            button.normalBackgroundColor = normalBackground
            button.selectedTintColor = selectedTint
            button.normalTintColor = normalTint
        }
    }

    private func toggleMode(animated: Bool) {
        let performUpdate = {
            switch self.contentMode {
            case .showtimes:
                self.movieShowtimesContainer.isHidden = false
                self.movieDetailsContainer.isHidden = true
                self.movieShowtimesContainer.alpha = 1
                self.movieDetailsContainer.alpha = 0
                self.comingSoonLabel.isHidden = true
                self.comingSoonLabel.alpha = 0
            case .details:
                self.movieShowtimesContainer.isHidden = true
                self.movieDetailsContainer.isHidden = false
                self.movieShowtimesContainer.alpha = 0
                self.movieDetailsContainer.alpha = 1
                self.comingSoonLabel.isHidden = true
                self.comingSoonLabel.alpha = 0
            case .comingSoon:
                self.movieShowtimesContainer.isHidden = true
                self.movieDetailsContainer.isHidden = true
                self.movieShowtimesContainer.alpha = 0
                self.movieDetailsContainer.alpha = 0
                self.comingSoonLabel.isHidden = false
                self.comingSoonLabel.alpha = 1
            }
        }
        if animated {
            UIView.animate(withDuration: 0.4) {
                performUpdate()
                self.view.setNeedsLayout()

            }
        } else {
            performUpdate()
            view.setNeedsLayout()
        }
    }

    private func selectModeButton(_ button: UIButton) {
        guard !button.isSelected else {
            return
        }
        button.isSelected = true
        switch button {
        case showtimesButton:
            detailsButton.isSelected = false
        case detailsButton:
            showtimesButton.isSelected = false
        default:
            break
        }
        button.superview?.bringSubviewToFront(button)
    }

    private func createInteractiveDismissalAnimatorIfNeeded(targetAnimatedView: UIView, progress: CGFloat) -> UIViewPropertyAnimator {
        if let animator = dismissalAnimator {
            return animator
        } else {
            let animator = UIViewPropertyAnimator(duration: 0, curve: .linear, animations: {
                targetAnimatedView.transform = .init(scaleX: Constant.targetShrinkScale, y: Constant.targetShrinkScale)
                targetAnimatedView.layer.cornerRadius = Constant.targetCornerRadius
                targetAnimatedView.clipsToBounds = true
            })
            animator.isReversed = false
            animator.pauseAnimation()
            animator.fractionComplete = progress
            return animator
        }
    }

    private func didSuccessfullyDragDownToDismiss() {
        dissmiss()
    }

    private func didCancelDismissalTransition() {
        interactiveStartingPoint = nil
        dismissalAnimator = nil
        draggingDownToDismiss = false
    }

    private func dissmiss() {
        movie = unhighlightedCardViewModel
        cardContentView.setupUIForMode(mode: fromCardContentViewMode)
        dismiss(animated: true)
    }

}
