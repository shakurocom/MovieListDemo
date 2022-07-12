//
//  Bundle+Helper.swift
//

import Foundation

extension Bundle {

    /**
     Searches for a bundle for the specified class.
     If the custom bundle is not found, returns the main budle.
     */
    static func findBundleIfNeeded(for aClass: AnyClass) -> Bundle {
        if let podBundleURL = Bundle(for: aClass).url(forResource: "MovieList", withExtension: "bundle"),
           let podBundle = Bundle(url: podBundleURL) {
            return podBundle
        }
        return Bundle.main
    }

}
