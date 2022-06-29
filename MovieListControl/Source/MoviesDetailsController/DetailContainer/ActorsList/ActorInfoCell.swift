//
//  InfoCell.swift

import UIKit

class InfoCell: UITableViewCell {

    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var subtitleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        titleLabel.font = CinemaStyleSheet.FontFace.poppinsMedium.fontWithSize(12)
        titleLabel.textColor = R.color.cinema300()
        subtitleLabel.font = CinemaStyleSheet.FontFace.poppinsMedium.fontWithSize(14)
        subtitleLabel.textColor = R.color.cDark()
    }

    func setInfo(info: Info) {
        titleLabel.text = info.title
        subtitleLabel.text = info.value
    }
}
