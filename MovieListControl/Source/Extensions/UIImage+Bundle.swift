//
//  UIImage+Bundle.swift
//

import UIKit

public extension UIImage {

    static func loadImageFromBundle(name: String) -> UIImage? {
        let podBundle = Bundle(for: MoviesListViewController.self)
        if let url = podBundle.url(forResource: "MovieList", withExtension: "bundle") {
            let bundle = Bundle(url: url)
            return UIImage(named: name, in: bundle, compatibleWith: nil)
        } else {
            return UIImage(named: name)
        }
    }

}
