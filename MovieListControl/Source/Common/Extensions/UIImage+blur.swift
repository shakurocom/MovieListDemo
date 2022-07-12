//
//  UIImage+blur.swift
//  ShakuroApp
//
//  Created by Sergey on 17/07/2020.
//  Copyright © 2020 Shakuro. All rights reserved.
//

import UIKit
import Accelerate

extension UIImage {
    class func blurredImage(blurRadius: CGFloat, tintColor: UIColor, context: CGContext, scale: CGFloat) -> UIImage? {
        var blurredImage: UIImage?
        if blurRadius > .ulpOfOne {
            let boundingBoxSize = CGSize(width: context.width, height: context.height)

            var inBuffer = vImage_Buffer()
            var outBuffer = vImage_Buffer()

            inBuffer.data = context.data
            inBuffer.width = vImagePixelCount(context.width)
            inBuffer.height = vImagePixelCount(context.height)
            inBuffer.rowBytes = context.bytesPerRow

            UIGraphicsBeginImageContextWithOptions(boundingBoxSize, false, scale)
            if let outContext = UIGraphicsGetCurrentContext() {
                outBuffer.data = outContext.data
                outBuffer.width = vImagePixelCount(outContext.width)
                outBuffer.height = vImagePixelCount(outContext.height)
                outBuffer.rowBytes = outContext.bytesPerRow

                let inputRadius = blurRadius * scale
                var radius: UInt32 = UInt32(round(inputRadius * 3.0 * sqrt(2.0 * .pi) / 4.0))
                if radius % 2 != 1 {
                    radius += 1
                }

                vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, nil, 0, 0, radius, radius, nil, vImage_Flags(kvImageEdgeExtend))
                vImageBoxConvolve_ARGB8888(&outBuffer, &inBuffer, nil, 0, 0, radius, radius, nil, vImage_Flags(kvImageEdgeExtend))
                vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, nil, 0, 0, radius, radius, nil, vImage_Flags(kvImageEdgeExtend))

                outContext.saveGState()
                outContext.setFillColor(tintColor.cgColor)
                outContext.fill(CGRect(origin: .zero, size: boundingBoxSize))
                outContext.restoreGState()
            }
            blurredImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
        }
        return blurredImage
    }
}
