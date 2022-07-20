//
//  ActorCell.swift
//  ShakuroApp

import UIKit

class ActorCell: UICollectionViewCell {

    @IBOutlet private var containerView: UIView!
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var roleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        containerView.layer.cornerRadius = 8
        containerView.clipsToBounds = true

        nameLabel.font = CinemaStyleSheet.FontFace.poppinsSemiBold.fontWithSize(14)
        nameLabel.textColor = MovieListBundleHelper.color(named: "TitleText")
        roleLabel.font = CinemaStyleSheet.FontFace.poppinsRegular.fontWithSize(12)
        roleLabel.textColor = MovieListBundleHelper.color(named: "Cinema400")
    }

    func setActor(actor: Actor?) {
        imageView.image = actor?.photo
        nameLabel.text = actor?.name
        roleLabel.text = actor?.role
    }

}
