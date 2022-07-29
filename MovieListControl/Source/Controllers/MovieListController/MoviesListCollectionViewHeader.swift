//
//  MoviesListCollectionViewHeader.swift
//  ShakuroApp

import UIKit

final class MoviesListCollectionViewHeader: UICollectionReusableView {

    static let reuseIdentifier: String = "MoviesListCollectionViewHeader"

    let contentView = MoviesListHeaderView.loadFromNib()

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
        contentView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentView)
        contentView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        contentView.topAnchor.constraint(lessThanOrEqualTo: topAnchor).isActive = true
    }
}
