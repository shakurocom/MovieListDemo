//
//  TransitionConstants.swift

import UIKit

enum TransitionConstants {
    static let cardHighlightedFactor: CGFloat = 0.96
    static let statusBarAnimationDuration: TimeInterval = 0.4
    static let cardCornerRadius: CGFloat = 8
    static let dismissalAnimationDuration = 0.6

    static let cardVerticalExpandingStyle: CardVerticalExpandingStyle = .fromTop
    static let isEnabledDebugAnimatingViews = false
    static let isEnabledTopSafeAreaInsetsFixOnCardDetailViewController = true
    static let isEnabledAllowsUserInteractionWhileHighlightingCard = true
    static let isEnabledDebugShowTimeTouch = true
}

extension TransitionConstants {

    enum CardVerticalExpandingStyle {
        case fromTop
        case fromCenter
    }

}
