//
//  UIImage+Bundle.swift
//
//  Created by Eugene Klyuenkov.
//

import UIKit

public extension UIImage {

    static func loadImageFromBundle(name: String) -> UIImage? {
        let podBundle = Bundle(for: CinemaSeatsViewController.self)
        if let url = podBundle.url(forResource: "CinemaSeats", withExtension: "bundle") {
            let bundle = Bundle(url: url)
            return UIImage(named: name, in: bundle, compatibleWith: nil)
        } else {
            return UIImage(named: name)
        }
    }

}
