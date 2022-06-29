//
//  PhotoCell.swift
//  ShakuroApp

import UIKit

class PhotoCell: UICollectionViewCell {

    @IBOutlet private var containerView: UIView!
    @IBOutlet private var imageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()

        containerView.layer.cornerRadius = 8
        containerView.clipsToBounds = true
    }

    func setPhoto(photo: UIImage?) {
        imageView.image = photo
    }

}
