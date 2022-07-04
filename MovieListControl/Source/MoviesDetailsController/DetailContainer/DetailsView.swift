//
//  DetailsView.swift
//  ShakuroApp

import UIKit

protocol DetailsViewDelegate: AnyObject {
    func detailsViewActorsDidPress(_ detailsView: DetailsView)
    func detailsViewMorePhotosDidPress(_ detailsView: DetailsView)
    func detailsViewTrailerDidPress(_ detailsView: DetailsView)
}

class DetailsView: UIView {

    @IBOutlet var storyLabel: UILabel!
    @IBOutlet var storyValue: UILabel!
    @IBOutlet var castLabel: UILabel!
    @IBOutlet var fullCastLabel: UILabel!
    @IBOutlet var castCollectionContainerView: UIView!
    @IBOutlet var trailerLabel: UILabel!
    @IBOutlet var moreVideosLabel: UILabel!
    @IBOutlet var trailerCollectionContainerView: UIView!
    @IBOutlet var photoLabel: UILabel!
    @IBOutlet var morePhotosLabel: UILabel!
    @IBOutlet var photoCollectionContainerView: UIView!

    weak var delegate: DetailsViewDelegate?

    private var trailerCollectionView: UICollectionView!
    private var castCollectionView: UICollectionView!
    private var photoCollectionView: UICollectionView!

    private var movieItem: MovieItem?

    static func loadFromNib() -> DetailsView {
        let detailsView = UINib(nibName: "DetailsView", bundle: Bundle.findBundleIfNeeded(for: DetailsView.self)).instantiate(withOwner: nil).first as? DetailsView
        return unwrap({ detailsView })
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        commonInit()
    }

    public func setDetailsView(movie: MovieItem) {
        movieItem = movie
        storyValue.text = movie.story
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate

extension DetailsView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case castCollectionView:
            return movieItem?.actor.count ?? 0
        case trailerCollectionView:
            return movieItem?.trailer.count ?? 0
        case photoCollectionView:
            return movieItem?.photo.count ?? 0
        default:
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case castCollectionView:
            let cell: ActorCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ActorCell", for: indexPath)
            cell.setActor(actor: movieItem?.actor[indexPath.item])
            return cell
        case trailerCollectionView:
            let cell: TrailerCell = collectionView.dequeueReusableCell(withReuseIdentifier: "TrailerCell", for: indexPath)
            cell.setTrailer(trailer: movieItem?.trailer[indexPath.item])
            return cell
        case photoCollectionView:
            let cell: PhotoCell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath)
            cell.setPhoto(photo: movieItem?.photo[indexPath.item].image)
            return cell
        default:
            return UICollectionViewCell()
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        switch collectionView {
        case castCollectionView:
            showActors()

        case trailerCollectionView:
            showTrailer()

        case photoCollectionView:
            showPhotos()

        default:
            break
        }
    }
}

// MARK: - User Actions

private extension DetailsView {

    @IBAction private func showActorsPressed() {
        showActors()
    }

    @IBAction private func showTrailerPressed() {
        showTrailer()
    }

    @IBAction private func showPhotosPressed() {
        showPhotos()
    }

}

// MARK: - Private

private extension DetailsView {

    private func commonInit() {
        storyLabel.text = NSLocalizedString("Story", comment: "")
        castLabel.text = NSLocalizedString("Cast", comment: "")
        fullCastLabel.text = NSLocalizedString("Full Cast", comment: "")
        trailerLabel.text = NSLocalizedString("Trailers", comment: "")
        moreVideosLabel.text = NSLocalizedString("More Videos", comment: "")
        photoLabel.text = NSLocalizedString("Photos", comment: "")
        morePhotosLabel.text = NSLocalizedString("More Photos", comment: "")

        storyLabel.font = CinemaStyleSheet.FontFace.poppinsSemiBold.fontWithSize(18)
        storyValue.font = CinemaStyleSheet.FontFace.poppinsLight.fontWithSize(14)
        castLabel.font = CinemaStyleSheet.FontFace.poppinsSemiBold.fontWithSize(18)
        fullCastLabel.font = CinemaStyleSheet.FontFace.poppinsMedium.fontWithSize(14)
        trailerLabel.font = CinemaStyleSheet.FontFace.poppinsSemiBold.fontWithSize(18)
        moreVideosLabel.font = CinemaStyleSheet.FontFace.poppinsMedium.fontWithSize(14)
        photoLabel.font = CinemaStyleSheet.FontFace.poppinsSemiBold.fontWithSize(18)
        morePhotosLabel.font = CinemaStyleSheet.FontFace.poppinsMedium.fontWithSize(14)

        addCastCollectionView()
        addTrailerCollectionView()
        addPhotoCollectionView()
    }

    private func addCastCollectionView() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: 198, height: 64)
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 32)
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 16
        flowLayout.minimumInteritemSpacing = 16
        let collectionFrame = CGRect(origin: .zero,
                                     size: CGSize(width: flowLayout.itemSize.width, height: flowLayout.itemSize.height + flowLayout.sectionInset.bottom + flowLayout.sectionInset.top))
        castCollectionView = UICollectionView(frame: collectionFrame, collectionViewLayout: flowLayout)
        castCollectionView.clipsToBounds = false
        castCollectionView.showsVerticalScrollIndicator = false
        castCollectionView.showsHorizontalScrollIndicator = false
        castCollectionView.backgroundColor = UIColor.loadColorFromBundle(name: "bg200")
        castCollectionView.translatesAutoresizingMaskIntoConstraints = false
        castCollectionView.register(UINib(nibName: "ActorCell", bundle: Bundle.findBundleIfNeeded(for: ActorCell.self)), forCellWithReuseIdentifier: "ActorCell")

        castCollectionContainerView.addSubview(castCollectionView)

        castCollectionView.topAnchor.constraint(equalTo: castCollectionContainerView.topAnchor, constant: 0).isActive = true
        castCollectionView.bottomAnchor.constraint(equalTo: castCollectionContainerView.bottomAnchor, constant: 0).isActive = true
        castCollectionView.leadingAnchor.constraint(equalTo: castCollectionContainerView.leadingAnchor, constant: 0).isActive = true
        castCollectionView.trailingAnchor.constraint(equalTo: castCollectionContainerView.trailingAnchor, constant: 0).isActive = true

        castCollectionView.delegate = self
        castCollectionView.dataSource = self
    }

    private func addTrailerCollectionView() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: 198, height: 136)
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 32)
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 16
        flowLayout.minimumInteritemSpacing = 16
        let collectionFrame = CGRect(origin: .zero,
                                     size: CGSize(width: flowLayout.itemSize.width, height: flowLayout.itemSize.height + flowLayout.sectionInset.bottom + flowLayout.sectionInset.top))
        trailerCollectionView = UICollectionView(frame: collectionFrame, collectionViewLayout: flowLayout)
        trailerCollectionView.clipsToBounds = false
        trailerCollectionView.showsVerticalScrollIndicator = false
        trailerCollectionView.showsHorizontalScrollIndicator = false
        trailerCollectionView.backgroundColor = UIColor.loadColorFromBundle(name: "bg200")
        trailerCollectionView.translatesAutoresizingMaskIntoConstraints = false
        trailerCollectionView.register(UINib(nibName: "TrailerCell", bundle: Bundle.findBundleIfNeeded(for: TrailerCell.self)), forCellWithReuseIdentifier: "TrailerCell")

        trailerCollectionContainerView.addSubview(trailerCollectionView)

        trailerCollectionView.topAnchor.constraint(equalTo: trailerCollectionContainerView.topAnchor, constant: 0).isActive = true
        trailerCollectionView.bottomAnchor.constraint(equalTo: trailerCollectionContainerView.bottomAnchor, constant: 0).isActive = true
        trailerCollectionView.leadingAnchor.constraint(equalTo: trailerCollectionContainerView.leadingAnchor, constant: 0).isActive = true
        trailerCollectionView.trailingAnchor.constraint(equalTo: trailerCollectionContainerView.trailingAnchor, constant: 0).isActive = true

        trailerCollectionView.delegate = self
        trailerCollectionView.dataSource = self
    }

    private func addPhotoCollectionView() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: 120, height: 112)
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 32)
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 16
        flowLayout.minimumInteritemSpacing = 16
        let collectionFrame = CGRect(origin: .zero,
                                     size: CGSize(width: flowLayout.itemSize.width, height: flowLayout.itemSize.height + flowLayout.sectionInset.bottom + flowLayout.sectionInset.top))
        photoCollectionView = UICollectionView(frame: collectionFrame, collectionViewLayout: flowLayout)
        photoCollectionView.clipsToBounds = false
        photoCollectionView.showsVerticalScrollIndicator = false
        photoCollectionView.showsHorizontalScrollIndicator = false
        photoCollectionView.backgroundColor = UIColor.loadColorFromBundle(name: "bg200")
        photoCollectionView.translatesAutoresizingMaskIntoConstraints = false
        photoCollectionView.register(UINib(nibName: "PhotoCell", bundle: Bundle.findBundleIfNeeded(for: PhotoCell.self)), forCellWithReuseIdentifier: "PhotoCell")

        photoCollectionContainerView.addSubview(photoCollectionView)

        photoCollectionView.topAnchor.constraint(equalTo: photoCollectionContainerView.topAnchor, constant: 0).isActive = true
        photoCollectionView.bottomAnchor.constraint(equalTo: photoCollectionContainerView.bottomAnchor, constant: 0).isActive = true
        photoCollectionView.leadingAnchor.constraint(equalTo: photoCollectionContainerView.leadingAnchor, constant: 0).isActive = true
        photoCollectionView.trailingAnchor.constraint(equalTo: photoCollectionContainerView.trailingAnchor, constant: 0).isActive = true

        photoCollectionView.delegate = self
        photoCollectionView.dataSource = self
    }

    private func showActors() {
        delegate?.detailsViewActorsDidPress(self)
    }

    private func showTrailer() {
        delegate?.detailsViewTrailerDidPress(self)
    }

    private func showPhotos() {
        delegate?.detailsViewMorePhotosDidPress(self)
    }
}
