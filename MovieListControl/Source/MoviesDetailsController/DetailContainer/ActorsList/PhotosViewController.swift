//
//  PhotosViewController.swift
//  ShakuroApp

import UIKit

class PhotosViewController: UIViewController, BaseViewControllerProtocol {

    struct Option {
    }

    @IBOutlet private var scrollView: UIScrollView!
    @IBOutlet private var topView: UIView!
    @IBOutlet private var backButton: StateAlphaButton!
    @IBOutlet private var barTitle: UILabel!

    private weak var appRouter: RoutingSupport?

    static func instantiateViewController(_ coordinator: AppCoordinator, options: Option) -> UIViewController {
        let viewController = R.unwrap({ R.storyboard.actors.photosViewController() })
        viewController.appRouter = coordinator
        viewController.modalPresentationStyle = .custom
        return viewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        scrollView.contentInset = UIEdgeInsets(top: 48, left: 0, bottom: 0, right: 0)

        topView.clipsToBounds = true
        topView.layer.cornerRadius = 32
        topView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]

        barTitle.text = NSLocalizedString("Photos", comment: "")
        barTitle.font = CinemaStyleSheet.FontFace.poppinsSemiBold.fontWithSize(18)
        barTitle.textColor = R.color.cDark()

        let backIconConfig = UIImage.SymbolConfiguration(pointSize: 24, weight: .medium, scale: .medium)
        let backIconImage = UIImage(systemName: "arrow.left", withConfiguration: backIconConfig)
        backButton.setImage(backIconImage, for: .normal)
        backButton.tintColor = R.color.accentColor()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    @IBAction private func backButtonPressed(_ sender: UIButton) {
        appRouter?.appRouter.dismissViewController(self, animated: true)
    }
}
