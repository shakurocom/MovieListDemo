//
//  MovieDetailsContainer.swift
//  ShakuroApp

import UIKit

final class MovieDetailsContainer: UIView {

    let detailsView = DetailsView.loadFromNib()

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
        detailsView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(detailsView)
        detailsView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        detailsView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        detailsView.bottomAnchor.constraint(greaterThanOrEqualTo: bottomAnchor).isActive = true
        detailsView.topAnchor.constraint(equalTo: topAnchor).isActive = true
    }
}
