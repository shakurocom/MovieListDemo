//
//  CalendarItemCollectionViewCell.swift

import UIKit

class CalendarItemCollectionViewCell: UICollectionViewCell {

    @IBOutlet private var weekTitle: UILabel!
    @IBOutlet private var dayTitle: UILabel!

    var selectedTintColor: UIColor? = Bundle.movieListBundleHelper.color(named: "blueButton")
    var normalTintColor: UIColor? = UIColor.white

    override var isSelected: Bool {
        didSet {
            if let selectedTint = selectedTintColor, let normalTint = normalTintColor {
                weekTitle.textColor = isSelected ? .white : Bundle.movieListBundleHelper.color(named: "c600")
                dayTitle.textColor = isSelected ? .white : Bundle.movieListBundleHelper.color(named: "c600")
                backgroundColor = isSelected ? selectedTint : normalTint
            }
        }
    }

    var title: String? {
        get {
            return weekTitle.text
        }
        set {
            weekTitle.text = newValue
        }
    }

    var subtitle: String? {
        get {
            return dayTitle.text
        }
        set {
            dayTitle.text = newValue
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        backgroundColor = UIColor.white
        layer.cornerRadius = 6

        weekTitle.font = CinemaStyleSheet.FontFace.poppinsRegular.fontWithSize(12.0)
        weekTitle.minimumScaleFactor = 0.5

        dayTitle.font = CinemaStyleSheet.FontFace.poppinsMedium.fontWithSize(14.0)
        dayTitle.minimumScaleFactor = 0.5
    }

}
