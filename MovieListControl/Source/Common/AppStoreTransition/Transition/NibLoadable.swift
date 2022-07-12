//
//  NibLoadable.swift

import UIKit

protocol NibLoadable where Self: UIView {
    func fromNib() -> UIView?
}

extension NibLoadable {
    @discardableResult
    func fromNib() -> UIView? {
        let bundle = Bundle.findBundleIfNeeded(for: type(of: self))
        guard let contentView = bundle.loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)?.first as? UIView else {
            return nil
        }
        self.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.edges(to: self)
        return contentView
    }
}
