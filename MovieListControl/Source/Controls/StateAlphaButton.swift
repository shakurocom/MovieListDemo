import UIKit

class StateAlphaButton: UIButton {

    var selectedAlpha: CGFloat?

    override var isHighlighted: Bool {
        didSet {
            updateAlpha()
        }
    }

    override var isEnabled: Bool {
        didSet {
            updateAlpha()
        }
    }

    override var isSelected: Bool {
        didSet {
            updateAlpha()
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

    // MARK: Private

    private func setup() {
        isExclusiveTouch = true
        adjustsImageWhenDisabled = false
        adjustsImageWhenHighlighted = false
    }

    private func updateAlpha() {
        if !isEnabled {
            alpha = 0.3
        } else if isHighlighted {
            alpha = 0.6
        } else if let actualSelectedAlpha = selectedAlpha, isSelected {
            alpha = actualSelectedAlpha
        } else {
            alpha = 1.0
        }
    }
}
