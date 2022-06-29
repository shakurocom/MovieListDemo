//
//  SheduleCollectionViewCell.swift

import UIKit
import AFDateHelper

class SheduleCollectionViewCell: UICollectionViewCell {

    @IBOutlet private var containerView: UIView!
    @IBOutlet private var addresslabel: UILabel!
    @IBOutlet private var subAddresslabel: UILabel!

    @IBOutlet private var time1ContainerView: UIView!
    @IBOutlet private var hall1label: UILabel!

    @IBOutlet private var time2ContainerView: UIView!
    @IBOutlet private var hall2label: UILabel!

    private var time1CollectionView: UICollectionView!
    private var time2CollectionView: UICollectionView!

    private var cinemaItem: Cinema?
    private var selectedDate: Date = Date()

    override func awakeFromNib() {
        super.awakeFromNib()

        backgroundColor = UIColor.white

        containerView.layer.cornerRadius = 8
        layer.cornerRadius = 8

        addresslabel.font = CinemaStyleSheet.FontFace.poppinsSemiBold.fontWithSize(18.0)
        addresslabel.minimumScaleFactor = 0.5
        subAddresslabel.font = CinemaStyleSheet.FontFace.poppinsMedium.fontWithSize(12.0)
        subAddresslabel.minimumScaleFactor = 0.5

        addCastCollectionView()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }

    func setCinema(cinema: Cinema?, date: Date) {
        cinemaItem = cinema

        selectedDate = date
        addresslabel.text = cinema?.name
        subAddresslabel.text = cinema?.address
        hall1label.text = cinema?.hallName1
        hall2label.text = cinema?.hallName2

        time1CollectionView.reloadData()
        time2CollectionView.reloadData()
    }

}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension SheduleCollectionViewCell: UICollectionViewDelegate, UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case time1CollectionView:
            return cinemaItem?.time1.count ?? 0
        case time2CollectionView:
            return cinemaItem?.time2.count ?? 0
        default:
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: MovieSheduleCell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.movieSheduleCell.identifier, for: indexPath)
        cell.isSelected = true

        var time: SeanceTime? = SeanceTime(time: "")

        switch collectionView {
        case time1CollectionView:
            time = cinemaItem?.time1[indexPath.item]
        case time2CollectionView:
            time = cinemaItem?.time2[indexPath.item]
        default:
            break
        }

        cell.isSelected = isLater(dateString: time?.time ?? "")

        cell.setTime(time: time)
        return cell
    }

}

// MARK: - Private

private extension SheduleCollectionViewCell {

    private func addCastCollectionView() {

        let flowLayout1 = UICollectionViewFlowLayout()
        let width = (time1ContainerView.bounds.width - 24) / 3
        flowLayout1.itemSize = CGSize(width: width, height: 30)
        flowLayout1.sectionInset = UIEdgeInsets(top: 2, left: 0, bottom: 2, right: 0)
        flowLayout1.scrollDirection = .vertical
        flowLayout1.minimumLineSpacing = 4
        flowLayout1.minimumInteritemSpacing = 4
        let collectionFrame = CGRect(origin: .zero,
                                     size: CGSize(width: flowLayout1.itemSize.width, height: flowLayout1.itemSize.height + flowLayout1.sectionInset.bottom + flowLayout1.sectionInset.top))
        time1CollectionView = UICollectionView(frame: collectionFrame, collectionViewLayout: flowLayout1)
        time1CollectionView.clipsToBounds = false
        time1CollectionView.showsVerticalScrollIndicator = false
        time1CollectionView.showsHorizontalScrollIndicator = false
        time1CollectionView.backgroundColor = UIColor.clear
        time1CollectionView.translatesAutoresizingMaskIntoConstraints = false
        time1CollectionView.register(R.nib.movieSheduleCell)
        time1ContainerView.addSubview(time1CollectionView)
        time1CollectionView.topAnchor.constraint(equalTo: time1ContainerView.topAnchor, constant: 0).isActive = true
        time1CollectionView.bottomAnchor.constraint(equalTo: time1ContainerView.bottomAnchor, constant: 0).isActive = true
        time1CollectionView.leadingAnchor.constraint(equalTo: time1ContainerView.leadingAnchor, constant: 0).isActive = true
        time1CollectionView.trailingAnchor.constraint(equalTo: time1ContainerView.trailingAnchor, constant: 0).isActive = true
        time1CollectionView.delegate = self
        time1CollectionView.dataSource = self

        let flowLayout2 = UICollectionViewFlowLayout()
        let width2 = (time2ContainerView.bounds.width - 24) / 3
        flowLayout2.itemSize = CGSize(width: width2, height: 30)
        flowLayout2.sectionInset = UIEdgeInsets(top: 2, left: 0, bottom: 2, right: 0)
        flowLayout2.scrollDirection = .vertical
        flowLayout2.minimumLineSpacing = 4
        flowLayout2.minimumInteritemSpacing = 4
        let collectionFrame2 = CGRect(origin: .zero,
                                      size: CGSize(width: flowLayout2.itemSize.width, height: flowLayout2.itemSize.height + flowLayout1.sectionInset.bottom + flowLayout1.sectionInset.top))
        time2CollectionView = UICollectionView(frame: collectionFrame2, collectionViewLayout: flowLayout2)
        time2CollectionView.clipsToBounds = false
        time2CollectionView.showsVerticalScrollIndicator = false
        time2CollectionView.showsHorizontalScrollIndicator = false
        time2CollectionView.backgroundColor = UIColor.clear
        time2CollectionView.translatesAutoresizingMaskIntoConstraints = false
        time2CollectionView.register(R.nib.movieSheduleCell)
        time2ContainerView.addSubview(time2CollectionView)

        time2CollectionView.topAnchor.constraint(equalTo: time2ContainerView.topAnchor, constant: 0).isActive = true
        time2CollectionView.bottomAnchor.constraint(equalTo: time2ContainerView.bottomAnchor, constant: 0).isActive = true
        time2CollectionView.leadingAnchor.constraint(equalTo: time2ContainerView.leadingAnchor, constant: 0).isActive = true
        time2CollectionView.trailingAnchor.constraint(equalTo: time2ContainerView.trailingAnchor, constant: 0).isActive = true
        time2CollectionView.delegate = self
        time2CollectionView.dataSource = self

    }

    private func isLater(dateString: String) -> Bool {
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "h:mm a"
        guard let date = timeFormatter.date(from: dateString) else {
            return false
        }
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day, .hour, .minute], from: date)

        guard let newDate = calendar.date(bySettingHour: components.hour ?? 0, minute: components.minute ?? 0, second: 0, of: selectedDate) else {
            return false
        }

        return Date().compare(.isEarlier(than: newDate))
    }

}
