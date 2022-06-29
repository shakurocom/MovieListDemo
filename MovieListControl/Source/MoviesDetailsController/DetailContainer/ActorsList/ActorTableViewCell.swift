//
//  ActorTableViewCell.swift
//  ShakuroApp

import UIKit

class ActorTableViewCell: UITableViewCell {

    @IBOutlet private var containerView: UIView!
    @IBOutlet private (set) var actorImageView: UIImageView!
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var roleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        containerView.layer.cornerRadius = 8
        containerView.clipsToBounds = true

        nameLabel.font = CinemaStyleSheet.FontFace.poppinsSemiBold.fontWithSize(14)
        nameLabel.textColor = R.color.titleText()
        roleLabel.font = CinemaStyleSheet.FontFace.poppinsRegular.fontWithSize(12)
        roleLabel.textColor = R.color.cinema400()
    }

    func setActor(actor: Actor?) {
        actorImageView.image = actor?.photo
        nameLabel.text = actor?.name
        roleLabel.text = actor?.role
    }

}
