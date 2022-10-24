//
//  ContentModeSelectButton.swift
//  ShakuroApp

import UIKit

class ContentModeSelectButton: StateAlphaButton {

    var selectedTintColor: UIColor?
    var normalTintColor: UIColor?
    var selectedBackgroundColor: UIColor?
    var normalBackgroundColor: UIColor?

    override var isSelected: Bool {
        didSet {
            if let selectedTint = selectedTintColor, let normalTint = normalTintColor {
                tintColor = isSelected ? selectedTint : normalTint
                backgroundColor = isSelected ? selectedBackgroundColor : normalBackgroundColor
                shadowLayer.fillColor = isSelected ? selectedBackgroundColor?.cgColor : normalBackgroundColor?.cgColor
                shadowLayer.shadowColor = isSelected ? UIColor(red: 0.188, green: 0.31, blue: 0.996, alpha: 0.3).cgColor : UIColor.clear.cgColor
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private var shadowLayer: CAShapeLayer = CAShapeLayer() {
        didSet {
            setNeedsLayout()
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: 8).cgPath
        shadowLayer.shadowPath = shadowLayer.path
    }

    // MARK: Private

    private func setup() {

        shadowLayer.path = UIBezierPath(roundedRect: bounds,
                                        cornerRadius: 8).cgPath
        shadowLayer.fillColor = backgroundColor?.cgColor
        shadowLayer.shadowColor = isSelected ? UIColor(red: 0.188, green: 0.31, blue: 0.996, alpha: 0.3).cgColor : UIColor.white.cgColor
        shadowLayer.shadowPath = shadowLayer.path
        shadowLayer.shadowOffset = CGSize(width: 0, height: 8)
        shadowLayer.shadowOpacity = 1
        shadowLayer.shadowRadius = 24
        layer.insertSublayer(shadowLayer, at: 0)

        isExclusiveTouch = true
        layer.cornerRadius = 8
    }

}
