//
//  Unwrap.swift
//  MovieList

import Foundation

func unwrap<T>(_ block: () -> T?) -> T {
    guard let result = block() else {
        fatalError("Can't unwrap resource")
    }
    return result
}
