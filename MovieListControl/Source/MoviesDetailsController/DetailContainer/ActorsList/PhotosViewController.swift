//
//  PhotosViewController.swift
//  ShakuroApp

import UIKit

class PhotosViewController: UIViewController {

    @IBOutlet private var scrollView: UIScrollView!
    @IBOutlet private var topView: UIView!
    @IBOutlet private var backButton: StateAlphaButton!
    @IBOutlet private var barTitle: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        scrollView.contentInset = UIEdgeInsets(top: 48, left: 0, bottom: 0, right: 0)

        topView.clipsToBounds = true
        topView.layer.cornerRadius = 32
        topView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]

        barTitle.text = NSLocalizedString("Photos", comment: "")
        barTitle.font = CinemaStyleSheet.FontFace.poppinsSemiBold.fontWithSize(18)
        barTitle.textColor = UIColor.loadColorFromBundle(name: "cDark")

        let backIconConfig = UIImage.SymbolConfiguration(pointSize: 24, weight: .medium, scale: .medium)
        let backIconImage = UIImage(systemName: "arrow.left", withConfiguration: backIconConfig)
        backButton.setImage(backIconImage, for: .normal)
        backButton.tintColor = UIColor.loadColorFromBundle(name: "accentColor")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    @IBAction private func backButtonPressed(_ sender: UIButton) {
        dismiss(animated: true)
    }

}
