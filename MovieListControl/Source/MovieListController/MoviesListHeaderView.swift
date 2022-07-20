//
//  MoviesListHeaderView.swift
//  ShakuroApp

import UIKit

protocol MoviesListHeaderViewDelegate: AnyObject {
    func moviesListHeaderCollectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
}

class MoviesListHeaderView: UIView {

    private enum Constant {
        static let maxOffsetX: CGFloat = 100
        static let maxScaleX: CGFloat = 0.8
    }

    weak var delegate: MoviesListHeaderViewDelegate?

    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var premiersLabel: UILabel!
    @IBOutlet private var contentContainer: UIView!

    private var moviesListHeaderCollectionView: UICollectionView!

    var movieItems: [MovieItem] = []

    static func loadFromNib() -> MoviesListHeaderView {
        let headerView = MovieListBundleHelper.loadNib(name: "MoviesListHeaderView").instantiate(withOwner: nil).first as? MoviesListHeaderView
        return unwrap({ headerView })
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        backgroundColor = UIColor.clear

        titleLabel.font = CinemaStyleSheet.FontFace.poppinsBold.fontWithSize(24)
        titleLabel.text = NSLocalizedString("Current on", comment: "")
        premiersLabel.font = CinemaStyleSheet.FontFace.poppinsBold.fontWithSize(24)
        premiersLabel.text = NSLocalizedString("Premieres", comment: "")

        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 240, height: 466)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 12
        layout.minimumInteritemSpacing = 12
        let collectionFrame = CGRect(origin: .zero,
                                     size: CGSize(width: layout.itemSize.width, height: layout.itemSize.height + layout.sectionInset.bottom + layout.sectionInset.top))
        moviesListHeaderCollectionView = UICollectionView(frame: collectionFrame, collectionViewLayout: layout)
        moviesListHeaderCollectionView.clipsToBounds = false
        moviesListHeaderCollectionView.showsVerticalScrollIndicator = false
        moviesListHeaderCollectionView.showsHorizontalScrollIndicator = false
        moviesListHeaderCollectionView.backgroundColor = UIColor.clear
        moviesListHeaderCollectionView.translatesAutoresizingMaskIntoConstraints = false

        moviesListHeaderCollectionView.register(MoviesListCollectionViewHeader.self,
                                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                                withReuseIdentifier: MoviesListCollectionViewHeader.reuseIdentifier)

        contentContainer.addSubview(moviesListHeaderCollectionView)

        moviesListHeaderCollectionView.topAnchor.constraint(equalTo: contentContainer.topAnchor).isActive = true
        moviesListHeaderCollectionView.bottomAnchor.constraint(equalTo: contentContainer.bottomAnchor).isActive = true
        moviesListHeaderCollectionView.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor).isActive = true
        moviesListHeaderCollectionView.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor).isActive = true

        moviesListHeaderCollectionView.delegate = self
        moviesListHeaderCollectionView.dataSource = self

        moviesListHeaderCollectionView.register(MovieListBundleHelper.loadNib(name: "MoviesListHeaderCell"),
                                                forCellWithReuseIdentifier: "MoviesListHeaderCell")
        scrollViewDidScroll(moviesListHeaderCollectionView)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let centerX = scrollView.contentOffset.x + scrollView.frame.size.width / 2
        for cell in moviesListHeaderCollectionView.visibleCells {
            var offsetX = centerX - cell.center.x
            if offsetX < 0 {
                offsetX *= -1
            }
            cell.transform = CGAffineTransform(scaleX: 1, y: 1)
            if offsetX > Constant.maxOffsetX {
                let offsetPercentage = (offsetX - Constant.maxOffsetX) / bounds.width
                var scaleX = 1 - offsetPercentage
                if scaleX < Constant.maxScaleX {
                    scaleX = Constant.maxScaleX
                }
                cell.transform = CGAffineTransform(scaleX: scaleX, y: scaleX)
            }
        }
    }

}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate

extension MoviesListHeaderView: UICollectionViewDataSource, UICollectionViewDelegate {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieItems.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: MoviesListHeaderCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MoviesListHeaderCell", for: indexPath)
        cell.cardContentView.setupUIForMode(mode: .header)
        cell.cardContentView.setMovieItem(movieItem: movieItems[indexPath.item])
        cell.transform = CGAffineTransform(scaleX: Constant.maxScaleX, y: Constant.maxScaleX)
        if indexPath.item == 0 {
            cell.transform = CGAffineTransform(scaleX: 1, y: 1)
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.moviesListHeaderCollectionView(collectionView, didSelectItemAt: indexPath)
    }
}
