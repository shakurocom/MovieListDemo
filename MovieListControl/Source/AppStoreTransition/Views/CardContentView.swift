//
//  CardContentView.swift
//  AppStoreHomeInteractiveTransition

import UIKit

protocol CardContentViewDelegate: AnyObject {
    func cardContentView(_ cardContentView: CardContentView, didPressCloseButton: UIButton)
}

final class CardContentView: UIView, NibLoadable {

    enum Mode {
        case header
        case list
        case details
    }

    weak var delegate: CardContentViewDelegate?

    @IBOutlet private var closeButton: UIButton!
    @IBOutlet private var playImageView: UIImageView!
    @IBOutlet private var imdbTitleLabel: UILabel!
    @IBOutlet private var imdbValueLabel: UILabel!
    @IBOutlet private var imdbView: UIView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var genresLabel: UILabel!
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var blurImageView: UIImageView!
    @IBOutlet private var imageViewBottomConstraint: NSLayoutConstraint!

    private var mode: Mode = .list

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fromNib()
        commonSetup()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        fromNib()
        commonSetup()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        commonSetup()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }

    func setMovieItem(movieItem: MovieItem) {
        imdbValueLabel.text = movieItem.imdb
        titleLabel.text = movieItem.title
        genresLabel.text = movieItem.genre
        switch self.mode {
        case .header, .details:
            imageView.image = movieItem.midImage
            blurImageView.image = generateShadowImage(image: movieItem.image)
        case .list:
            imageView.image = movieItem.image
            blurImageView.image = nil
        }
    }

    func setupUIForMode(mode: Mode) {
        closeButton.isHidden = true
        playImageView.isHidden = true

        self.mode = mode
        switch mode {
        case .header:
            blurImageView.isHidden = false
            imdbView.isHidden = false
            titleLabel.font = CinemaStyleSheet.FontFace.poppinsBold.fontWithSize(16)
            genresLabel.font = CinemaStyleSheet.FontFace.poppinsMedium.fontWithSize(12)
            imageView.layer.cornerRadius = 16
            imageView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMinYCorner]
            layer.cornerRadius = 0
            backgroundColor = R.color.bg200()

            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 440 / 286).isActive = true
            imageViewBottomConstraint.constant = 16

        case .list:
            blurImageView.isHidden = true
            imdbView.isHidden = true
            titleLabel.font = CinemaStyleSheet.FontFace.poppinsBold.fontWithSize(12)
            genresLabel.font = CinemaStyleSheet.FontFace.poppinsRegular.fontWithSize(12)
            imageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            imageView.layer.cornerRadius = 8
            layer.cornerRadius = 8
            backgroundColor = UIColor.white

            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 252 / 164).isActive = true
            imageViewBottomConstraint.constant = 8

        case .details:
            blurImageView.isHidden = false
            imdbView.isHidden = false
            closeButton.isHidden = false
            playImageView.isHidden = false
            titleLabel.font = CinemaStyleSheet.FontFace.poppinsBold.fontWithSize(16)
            genresLabel.font = CinemaStyleSheet.FontFace.poppinsMedium.fontWithSize(12)
            imageView.layer.cornerRadius = 32
            imageView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
            layer.cornerRadius = 0
            backgroundColor = R.color.bg200()
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 440 / 286).isActive = true

            imageViewBottomConstraint.constant = 32
        }
    }

    // MARK: - Actions

    @IBAction private func close(_ sender: UIButton) {
        delegate?.cardContentView(self, didPressCloseButton: sender)
    }

    // MARK: - Private

    private func commonSetup() {
        imdbTitleLabel.layer.borderWidth = 1
        imdbTitleLabel.layer.cornerRadius = 4
        imdbTitleLabel.layer.borderColor = R.color.subtitleText()?.cgColor
        imdbTitleLabel.text = NSLocalizedString("IMDb", comment: "")
        imdbTitleLabel.font = CinemaStyleSheet.FontFace.poppinsMedium.fontWithSize(12)
        imdbValueLabel.font = CinemaStyleSheet.FontFace.poppinsMedium.fontWithSize(12)
        imageView.clipsToBounds = true
        blurImageView.alpha = 0.6
        closeButton.setImage(R.image.close(), for: .normal)
    }

    private func generateShadowImage(image: UIImage?, radius: CGFloat = 16.0) -> UIImage? {
        guard let sourceImage = image else {
            return nil
        }
        let size = sourceImage.size
        let contextRect: CGRect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        let drawInset = radius * 2
        var drawRect = contextRect.insetBy(dx: drawInset, dy: drawInset)
        drawRect.origin.y = 0
        UIGraphicsBeginImageContextWithOptions(contextRect.size, false, 1.0)
        let snapshot: UIImage?
        if let effectInContext: CGContext = UIGraphicsGetCurrentContext() {
            let clipPath = UIBezierPath(roundedRect: drawRect, cornerRadius: radius)
            effectInContext.saveGState()
            effectInContext.addPath(clipPath.cgPath)
            effectInContext.clip()
            sourceImage.draw(in: drawRect)
            effectInContext.restoreGState()
            effectInContext.resetClip()
            snapshot = UIImage.blurredImage(blurRadius: radius, tintColor: UIColor.clear, context: effectInContext, scale: 1)
        } else {
            snapshot = nil
        }
        UIGraphicsEndImageContext()
        let inset = min(radius * 3, (size.width - 1) * 0.5)
        return snapshot?.resizableImage(withCapInsets: UIEdgeInsets(top: 0, left: inset, bottom: size.height - 1, right: inset), resizingMode: .stretch)
    }

}
