//
//  ActorDetailsViewController.swift
//  ShakuroApp

import UIKit

class ActorDetailsViewController: UIViewController, BaseViewControllerProtocol {

    struct Option {
        let actor: Actor
        let transition: UIViewControllerTransitioningDelegate
    }

    @IBOutlet var aScrollView: UIScrollView!
    @IBOutlet var photoContainerView: UIView!
    @IBOutlet var photoImageView: UIImageView!
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var ageLabel: UILabel!

    @IBOutlet private var bioLabel: UILabel!
    @IBOutlet private var bioValueLabel: UILabel!

    @IBOutlet private var infoLabel: UILabel!
    @IBOutlet private var infoTableView: UITableView!

    @IBOutlet private var photoLabel: UILabel!
    @IBOutlet var morePhotosLabel: UILabel!
    @IBOutlet var photoCollectionContainerView: UIView!

    @IBOutlet private var filmographyLabel: UILabel!
    @IBOutlet private var filmographyTableView: UITableView!

    @IBOutlet private var infoTableViewHeight: NSLayoutConstraint!
    @IBOutlet private var filmographyTableViewHeight: NSLayoutConstraint!

    private var photoCollectionView: UICollectionView!

    private var actor: Actor!
    private weak var appRouter: RoutingSupport?

    static func instantiateViewController(_ coordinator: AppCoordinator, options: ActorDetailsViewController.Option) -> UIViewController {
        let viewController = R.unwrap({ R.storyboard.actors.actorDetailsViewController() })
        viewController.actor = options.actor
        viewController.appRouter = coordinator
        viewController.modalPresentationStyle = .custom
        viewController.modalPresentationCapturesStatusBarAppearance = true
        viewController.transitioningDelegate = options.transition

        return viewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        dismissHandler = DismissHandler(source: self)
        scrollView.delegate = self
        scrollView.contentInsetAdjustmentBehavior = .never
        addPhotoCollectionView()
        setupUI()
        setActorData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        infoTableViewHeight.constant = infoTableView.contentSize.height
        filmographyTableViewHeight.constant = filmographyTableView.contentSize.height
    }

}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate

extension ActorDetailsViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: PhotoCell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.photoCell.identifier, for: indexPath)
        cell.setPhoto(photo: actor?.photo)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        showPhotos()
    }

}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension ActorDetailsViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case infoTableView:
            return actor?.actorInfo.count ?? 0
        case filmographyTableView:
            return actor?.filmography.count ?? 0
        default:
            return 1
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView === infoTableView {
            let cell: InfoCell = tableView.dequeueReusableCell(indexPath: indexPath, reuseIdentifier: R.reuseIdentifier.infoCell.identifier)
            cell.setInfo(info: actor.actorInfo[indexPath.row])
            return cell
        } else {
            let cell: FilmographyCell = tableView.dequeueReusableCell(indexPath: indexPath, reuseIdentifier: R.reuseIdentifier.filmographyCell.identifier)
            cell.setFilmography(filmography: actor.filmography[indexPath.row])
            return cell
        }
    }
}

extension ActorDetailsViewController: MovieDetailsProtocol {

    var scrollView: UIScrollView {
        return aScrollView
    }

}

extension ActorDetailsViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // prevent bouncing when swiping down to close
        scrollView.bounces = scrollView.contentOffset.y > 100
        dismissHandler.scrollViewDidScroll(scrollView)
    }

}

// MARK: - Actions

private extension ActorDetailsViewController {

    @IBAction func closeButtonPressed(_ sender: UIButton) {
        appRouter?.appRouter.dismissViewController(self, animated: true)
    }

    @IBAction private func showPhotosPressed() {
        showPhotos()
    }

}

private extension ActorDetailsViewController {

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
        photoCollectionView.backgroundColor = R.color.bg200()
        photoCollectionView.translatesAutoresizingMaskIntoConstraints = false
        photoCollectionView.register(R.nib.photoCell)

        photoCollectionContainerView.addSubview(photoCollectionView)

        photoCollectionView.topAnchor.constraint(equalTo: photoCollectionContainerView.topAnchor, constant: 0).isActive = true
        photoCollectionView.bottomAnchor.constraint(equalTo: photoCollectionContainerView.bottomAnchor, constant: 0).isActive = true
        photoCollectionView.leadingAnchor.constraint(equalTo: photoCollectionContainerView.leadingAnchor, constant: 0).isActive = true
        photoCollectionView.trailingAnchor.constraint(equalTo: photoCollectionContainerView.trailingAnchor, constant: 0).isActive = true

        photoCollectionView.delegate = self
        photoCollectionView.dataSource = self
    }

    private func setupUI() {
        infoTableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: infoTableView.frame.size.width, height: 1))
        filmographyTableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: filmographyTableView.frame.size.width, height: 1))
        infoTableView.layer.cornerRadius = 8
        filmographyTableView.layer.cornerRadius = 8

        photoImageView.clipsToBounds = true
        photoImageView.layer.cornerRadius = 32
        photoImageView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]

        photoContainerView.layer.masksToBounds = false
        photoContainerView.layer.shadowRadius = 10
        photoContainerView.layer.shadowOpacity = 0.4
        photoContainerView.layer.shadowColor = UIColor.gray.cgColor
        photoContainerView.layer.shadowOffset = CGSize(width: 0, height: 20)

        nameLabel.font = CinemaStyleSheet.FontFace.poppinsBold.fontWithSize(24)
        ageLabel.font = CinemaStyleSheet.FontFace.poppinsMedium.fontWithSize(16)
        bioLabel.font = CinemaStyleSheet.FontFace.poppinsSemiBold.fontWithSize(18)
        bioValueLabel.font = CinemaStyleSheet.FontFace.poppinsLight.fontWithSize(14)
        infoLabel.font = CinemaStyleSheet.FontFace.poppinsSemiBold.fontWithSize(18)
        filmographyLabel.font = CinemaStyleSheet.FontFace.poppinsSemiBold.fontWithSize(18)
        photoLabel.font = CinemaStyleSheet.FontFace.poppinsSemiBold.fontWithSize(18)
        morePhotosLabel.font = CinemaStyleSheet.FontFace.poppinsMedium.fontWithSize(14)
    }

    private func setActorData() {
        photoImageView.image = actor?.photo
        nameLabel.text = actor?.name
        ageLabel.text = actor?.age
        bioLabel.text = NSLocalizedString("Bio", comment: "")
        bioValueLabel.text = actor?.bio
        infoLabel.text = "Information"
        photoLabel.text = NSLocalizedString("Photos", comment: "")
        morePhotosLabel.text = NSLocalizedString("More Photos", comment: "")
        filmographyLabel.text = NSLocalizedString("Filmography", comment: "")
    }

    private func showPhotos() {
        _ = appRouter?.presentViewController(type: PhotosViewController.self,
                                             options: PhotosViewController.Option(),
                                             from: self,
                                             style: .modalDefault,
                                             animated: true)
    }

}
