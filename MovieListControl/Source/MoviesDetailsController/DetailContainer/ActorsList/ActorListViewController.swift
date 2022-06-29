//
//  ActorListViewController.swift
//  ShakuroApp

import UIKit

class ActorListViewController: UIViewController {

    struct Option {
        let actors: [Actor]
    }

    @IBOutlet private var topView: UIView!
    @IBOutlet private var backButton: StateAlphaButton!
    @IBOutlet private var barTitle: UILabel!

    var selectedCell: ActorTableViewCell?
    var selectedCellImageViewSnapshot: UIView?

    private weak var transition: UIViewControllerTransitioningDelegate?
    private var actorItems: [Actor] = []

    static func instantiateViewController(_ coordinator: AppCoordinator, options: Option) -> UIViewController {
        let viewController = R.unwrap({ R.storyboard.actors.actorListViewController() })
        viewController.actorItems = options.actors
        viewController.appRouter = coordinator
        viewController.modalPresentationStyle = .custom
        return viewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        topView.clipsToBounds = true
        topView.layer.cornerRadius = 32
        topView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]

        barTitle.text = NSLocalizedString("Cast", comment: "")
        barTitle.font = CinemaStyleSheet.FontFace.poppinsSemiBold.fontWithSize(18)
        barTitle.textColor = UIColor.loadColorFromBundle(name: "cDark")

        let backIconConfig = UIImage.SymbolConfiguration(pointSize: 24, weight: .medium, scale: .medium)
        let backIconImage = UIImage(systemName: "arrow.left", withConfiguration: backIconConfig)
        backButton.setImage(backIconImage, for: .normal)
        backButton.tintColor = UIColor.loadColorFromBundle(name: "AccentColor")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension ActorListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return actorItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ActorTableViewCell = tableView.dequeueReusableCell(indexPath: indexPath, reuseIdentifier: R.reuseIdentifier.actorTableViewCell.identifier)
        cell.setActor(actor: actorItems[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? ActorTableViewCell else {
            return
        }
        selectedCell = cell
        selectedCellImageViewSnapshot = selectedCell?.actorImageView.snapshotView(afterScreenUpdates: false)

        let actor = actorItems[indexPath.row]
        _ = appRouter?.presentViewController(type: ActorDetailsViewController.self,
                                             options: ActorDetailsViewController.Option(actor: actor, transition: self),
                                             from: self,
                                             style: .modalDefault,
                                             animated: true)
    }

}

extension ActorListViewController: UIViewControllerTransitioningDelegate {

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let firstViewController = presenting as? ActorListViewController,
              let secondViewController = presented as? ActorDetailsViewController,
              let aSelectedCellImageViewSnapshot = selectedCellImageViewSnapshot else {
                return nil
        }
        return MovieAnimator(type: .present,
                             firstViewController: firstViewController,
                             secondViewController: secondViewController,
                             selectedCellImageViewSnapshot: aSelectedCellImageViewSnapshot)
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let secondViewController = dismissed as? ActorDetailsViewController,
              let selectedCellImageViewSnapshot = selectedCellImageViewSnapshot else {
              return nil
        }
        return MovieAnimator(type: .dismiss,
                             firstViewController: self,
                             secondViewController: secondViewController,
                             selectedCellImageViewSnapshot: selectedCellImageViewSnapshot)
    }
}

// MARK: - Actions

private extension ActorListViewController {

    @IBAction func backButtonPressed(_ sender: UIButton) {
        dismiss(animated: true)
    }

}
