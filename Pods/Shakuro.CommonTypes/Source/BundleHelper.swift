//
//
//

import UIKit

public class BundleHelper {

    private let bundle: Bundle

    /// Instantiates bundle for the specified class and bundle name.
    /// - parameter targetClass: The class with which the bundle is associated.
    /// - parameter bundleName: The resource bundle name, used as fallback.
    public init(targetClass: AnyClass, bundleName: String) {
        let bundle = Bundle(for: targetClass)
        if let bundleURL = bundle.url(forResource: bundleName, withExtension: "bundle"),
           let bundleInternal = Bundle(url: bundleURL) {
            self.bundle = bundleInternal
        } else {
            self.bundle = bundle
        }
    }

    // MARK: - Public

    /// Returns an image object using the named image asset that is compatible with the specified trait collection.
    /// - parameter named: The name of the image asset or file.
    /// - parameter traitCollection: The traits associated with the intended environment for the image. Use this parameter to ensure that the correct variant of the image is loaded. If you specify nil, this method uses the traits associated with the main screen.
    /// - returns: The image object that best matches the desired traits with the given name, or nil if no suitable image was found.
    public func image(named: String, compatibleWith traitCollection: UITraitCollection? = nil) -> UIImage? {
        return UIImage(named: named, in: bundle, compatibleWith: traitCollection)
    }

    /// Returns a color object using the named asset that’s compatible with the specified trait collection.
    /// - parameter named: The name of the asset containing the color.
    /// - parameter traitCollection: The trait collection that specifies the gamut to use when selecting the color.
    /// - returns: An initialized color object. The returned object uses the color space specified for the asset.
    public func color(named: String, compatibleWith traitCollection: UITraitCollection? = nil) -> UIColor? {
        return UIColor(named: named, in: bundle, compatibleWith: traitCollection)
    }

    /// Registers the specified font from the bundle.
    /// - parameter name: The name of the font file.
    /// - parameter extension: The extension of the font file.
    public func registerFont(name: String, fontExtension: String) {
        guard let fontURL = bundle.url(forResource: name, withExtension: fontExtension) else {
            debugPrint("Couldn't find font \(name)")
            return
        }
        guard let fontDataProvider = CGDataProvider(url: fontURL as CFURL) else {
            debugPrint("Couldn't load data from the font \(name)")
            return
        }
        guard let font = CGFont(fontDataProvider) else {
            debugPrint("Couldn't create font(\(name)) from data")
            return
        }
        var error: Unmanaged<CFError>?
        let success = CTFontManagerRegisterGraphicsFont(font, &error)
        guard success else {
            debugPrint("Error registering font(\(name)): maybe it was already registered.")
            return
        }
    }

    /// Registers the specified fonts from the bundle.
    /// - parameter fonts: Array of font names with extensions.
    public func registerFonts(_ fonts: [(fontName: String, fontExtension: String)]) {
        for font in fonts {
            registerFont(name: font.fontName, fontExtension: font.fontExtension)
        }
    }

    /// Returns a nib object from the nib file.
    /// - parameter name: The name of the nib file, without any leading path information.
    /// - returns: The initialized UINib object. An exception is thrown if there were errors during initialization or the nib file could not be located.
    public func loadNib(name: String) -> UINib {
        return UINib(nibName: name, bundle: bundle)
    }

    /**
     Returns instance of a UIViewController.

     - Parameters:
        - targetClass: View controller type,  that must be created.
        - nibName: The name of the nib file to associate with the view controller.
     - Returns: A newly initialized UIViewController object.

     - Example:
     `let exampleViewController: ExampleViewController = BundleHelper.instantiateViewControllerFromBundle(targetClass: ExampleViewController.type, nibName: "kExampleViewController")`
     */
    public func instantiateViewController<T>(targetClass: T.Type, nibName: String) -> T where T: UIViewController {
        return targetClass.init(nibName: nibName, bundle: bundle)
    }

}
