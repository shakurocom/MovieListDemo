//
//  UIColor+Bundle.swift
//
//  Created by Eugene Klyuenkov.
//

import UIKit

extension UIColor {

    static func loadColorFromBundle(name: String) -> UIColor? {
        let podBundle = Bundle(for: MoviesListViewController.self)
        if let url = podBundle.url(forResource: "MoviesList", withExtension: "bundle") {
            let bundle = Bundle(url: url)
            return UIColor(named: name, in: bundle, compatibleWith: nil)
        } else {
            return UIColor(named: name)
        }
    }

}
