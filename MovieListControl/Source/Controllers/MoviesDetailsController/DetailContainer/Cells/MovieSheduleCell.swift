//
//  MovieSheduleCell.swift
//  ShakuroApp

import UIKit

class MovieSheduleCell: UICollectionViewCell {

    @IBOutlet private var timeTitle: UILabel!

    var selectedTintColor: UIColor? = CinemaStyleSheet.Color.sheduleButtonBackground
    var normalTintColor: UIColor? = Bundle.movieListBundleHelper.color(named: "bg50")

    override var isSelected: Bool {
        didSet {
            if let selectedTint = selectedTintColor, let normalTint = normalTintColor {
                timeTitle.textColor = isSelected ? .white : Bundle.movieListBundleHelper.color(named: "c200")
                backgroundColor = isSelected ? selectedTint : normalTint
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        timeTitle.font = CinemaStyleSheet.FontFace.poppinsMedium.fontWithSize(14.0)
        timeTitle.minimumScaleFactor = 0.5

        self.layer.cornerRadius = 6
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.clear.cgColor
    }

    func setTime(time: SeanceTime?) {
        timeTitle.text = time?.time
    }

}
