//
//  MoviesListViewController.swift
//  ShakuroApp

import Shakuro_CommonTypes
import Foundation
import UIKit

class MoviesListViewController: UIViewController {

    struct Option {
    }

    private enum Constant {
        static let aspectRatio: CGFloat = 298 / 164
        static let topInset: CGFloat = 121
    }

    @IBOutlet private var collectionView: UICollectionView!

    private var transition: CardTransition?
    private let movieItems: [MovieItem] = MovieList.generate().items

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.register(MoviesListCollectionViewHeader.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: MoviesListCollectionViewHeader.reuseIdentifier)
    }

    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        collectionView.collectionViewLayout.invalidateLayout()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        collectionView.collectionViewLayout.invalidateLayout()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let flowLayout = (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)
        let width = (collectionView.bounds.width - 48) / 2
        flowLayout?.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 16, right: 16)

        flowLayout?.itemSize = CGSize(width: width, height: width * Constant.aspectRatio)
        flowLayout?.minimumLineSpacing = 16
        flowLayout?.minimumInteritemSpacing = 16
        flowLayout?.invalidateLayout()
    }

}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate

extension MoviesListViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieItems.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: MoviesListCell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.moviesListCell.identifier, for: indexPath)
        cell.cardContentView.setupUIForMode(mode: .list)
        cell.cardContentView.setMovieItem(movieItem: movieItems[indexPath.item])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header: MoviesListCollectionViewHeader = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader,
                                                                                                     withReuseIdentifier: MoviesListCollectionViewHeader.reuseIdentifier,
                                                                                                     for: indexPath)
        header.contentView.delegate = self
        header.contentView.movieItems = movieItems
        return header
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let indexPath = IndexPath(item: 0, section: section)
        if let headerView = self.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: indexPath) as? MoviesListCollectionViewHeader {
            let height = headerView.contentView.frame.height
            return CGSize(width: collectionView.frame.width, height: height)
        } else {
            return CGSize(width: 1, height: 1)
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? MoviesListCell else {
            return
        }
        presentCell(indexPath: indexPath, cell: cell, mode: .list)
    }
}

// MARK: - MoviesListHeaderViewDelegate

extension MoviesListViewController: MoviesListHeaderViewDelegate {

    func moviesListHeaderCollectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? CardCollectionViewCell else {
            return
        }
        presentCell(indexPath: indexPath, cell: cell, mode: .header)
    }

}

// MARK: - Private

private extension MoviesListViewController {

    private func presentCell(indexPath: IndexPath, cell: CardCollectionViewCell, mode: CardContentView.Mode) {
        cell.freezeAnimations()

        let rect = CGRect(x: cell.center.x - cell.bounds.size.width / 2,
                          y: cell.center.y - cell.bounds.size.height / 2,
                          width: cell.bounds.size.width,
                          height: cell.bounds.size.height)

        guard let currentCellFrame = cell.layer.presentation()?.frame,
              let cardPresentationFrameOnScreen = cell.superview?.convert(currentCellFrame, to: nil),
              var cardFrameWithoutTransform = cell.superview?.convert(rect, to: nil),
              let topbarViewHeight = (parent as? DemoContainerViewController)?.topbarView.frame.size.height else {
            return
        }

        if cardFrameWithoutTransform.origin.y < topbarViewHeight {
            if mode == .header {
                collectionView.setContentOffset(CGPoint(x: 0, y: Constant.topInset), animated: true)
            } else {
                collectionView.scrollToItem(at: indexPath, at: .top, animated: true)
            }
            cardFrameWithoutTransform = CGRect(x: cardFrameWithoutTransform.origin.x,
                                               y: topbarViewHeight,
                                               width: cardFrameWithoutTransform.size.width,
                                               height: cardFrameWithoutTransform.size.height)
        }

        let movieItem = movieItems[indexPath.item]
        let params = CardTransition.Params(fromCardFrame: cardPresentationFrameOnScreen,
                                           fromCardFrameWithoutTransform: cardFrameWithoutTransform,
                                           fromCell: cell)

        transition = CardTransition(params: params)

        _ = appRouter?.presentViewController(type: MovieDetailsViewController.self,
                                             options: MovieDetailsViewController.Option(movieItem: movieItem,
                                                                                        fromCardContentViewMode: mode,
                                                                                        transition: transition),
                                             from: self,
                                             style: .modal(transitionStyle: .coverVertical, completion: { [weak cell] in
                                                cell?.unfreezeAnimations()
                                             }),
                                             animated: true)
    }
}
