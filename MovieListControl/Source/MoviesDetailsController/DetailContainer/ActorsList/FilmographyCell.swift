//
//  FilmographyCell.swift
//  ShakuroApp

import UIKit

class FilmographyCell: UITableViewCell {

    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var subtitleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        titleLabel.font = CinemaStyleSheet.FontFace.poppinsMedium.fontWithSize(12)
        titleLabel.textColor = UIColor.loadColorFromBundle(name: "cDark")
        subtitleLabel.font = CinemaStyleSheet.FontFace.poppinsMedium.fontWithSize(14)
        subtitleLabel.textColor = UIColor.loadColorFromBundle(name: "cDark")
    }

    func setFilmography(filmography: Filmography?) {
        titleLabel.text = filmography?.title
        subtitleLabel.text = filmography?.year
    }

}
