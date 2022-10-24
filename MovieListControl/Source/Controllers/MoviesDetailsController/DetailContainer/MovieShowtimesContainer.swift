//
//  MovieShowtimesContainer.swift
//  ShakuroApp
//
import UIKit

class MovieShowtimesContainer: UIView {

    let showtimesView = ShowtimesView.loadFromNib()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup() {
        backgroundColor = UIColor.clear
        showtimesView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(showtimesView)
        showtimesView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        showtimesView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        showtimesView.bottomAnchor.constraint(greaterThanOrEqualTo: bottomAnchor).isActive = true
        showtimesView.topAnchor.constraint(equalTo: topAnchor).isActive = true
    }
}
