//
//  TrailerCell.swift
//  ShakuroApp

import UIKit

class TrailerCell: UICollectionViewCell {

    @IBOutlet private var containerView: UIView!
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var titleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        containerView.layer.cornerRadius = 8
        containerView.clipsToBounds = true

        titleLabel.font = CinemaStyleSheet.FontFace.poppinsMedium.fontWithSize(14)
        titleLabel.textColor = Bundle.movieListBundleHelper.color(named: "cinema400")
    }

    func setTrailer(trailer: Trailer?) {
        imageView.image = trailer?.image
        titleLabel.text = trailer?.title
    }

}
