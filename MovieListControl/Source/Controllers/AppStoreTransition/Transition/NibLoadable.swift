//
//  NibLoadable.swift

import UIKit

protocol NibLoadable where Self: UIView {
    func fromNib() -> UIView?
}

extension NibLoadable {
    @discardableResult
    func fromNib() -> UIView? {
        guard let contentView = Bundle.movieListBundleHelper.loadNib(name: String(describing: type(of: self))).instantiate(withOwner: self, options: nil).first as? UIView else {
            return nil
        }
        self.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.edges(to: self)
        return contentView
    }
}
