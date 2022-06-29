//
//  ShowtimesViewController.swift
//  ShakuroApp
//

import UIKit

class ShowtimesView: UIView {

    private struct Day {
        let dayOfTheWeek: String
        let dateOfTheWeek: String
        let dateValue: Date
    }

    private enum Constant {
        static let sectionInset = UIEdgeInsets(top: 40, left: 0, bottom: 0, right: 0)
        static let minimumLineSpacing: CGFloat = 40
        static let days: Int = 7
    }

    @IBOutlet private var dateLabel: UILabel!
    @IBOutlet private var calendarContainerView: UIView!
    @IBOutlet private var sheduleContainerView: UIView!
    @IBOutlet private var sheduleCollectionViewHeightConstraint: NSLayoutConstraint!

    var movieItem: MovieItem?

    private var calendarCollectionView: UICollectionView!
    private var sheduleCollectionView: UICollectionView!
    private var dates: [Day] = []

    static func loadFromNib() -> ShowtimesView {
        return R.unwrap({ R.nib.showtimesView(owner: nil) })
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        backgroundColor = UIColor.loadColorFromBundle(name: "bg200")

        addCalendarCollectionView()
        addSheduleCollectionView()
        generateDates()
        calendarCollectionView.selectItem(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: .centeredHorizontally)

        commonInit()

    }

    public func setShowtimesView(movie: MovieItem) {
        movieItem = movie
    }

    private func commonInit() {
        dateLabel.text = NSLocalizedString("Date", comment: "")
        dateLabel.font = CinemaStyleSheet.FontFace.poppinsSemiBold.fontWithSize(18)

        sheduleContainerView.backgroundColor = UIColor.loadColorFromBundle(name: "bg200")
        calendarContainerView.clipsToBounds = true
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        sheduleCollectionViewHeightConstraint.constant = sheduleCollectionView.contentSize.height

        guard let flowLayout: UICollectionViewFlowLayout = sheduleCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        let boundsSize = sheduleContainerView.bounds.size
        flowLayout.itemSize = CGSize(width: (boundsSize.width - (Constant.sectionInset.left + Constant.sectionInset.right)).rounded(),
                                     height: 294)
        flowLayout.minimumLineSpacing = Constant.minimumLineSpacing
        flowLayout.sectionInset = Constant.sectionInset
        flowLayout.invalidateLayout()
    }

}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate

extension ShowtimesView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case calendarCollectionView:
            return Constant.days
        case sheduleCollectionView:
            return movieItem?.cinema.count ?? 0
        default:
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case calendarCollectionView:
            let cell: CalendarItemCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.calendarItemCollectionViewCell.identifier, for: indexPath)
            cell.title = dates[indexPath.item].dayOfTheWeek
            cell.subtitle = dates[indexPath.item].dateOfTheWeek
            return cell
        case sheduleCollectionView:
            let cell: SheduleCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.sheduleCollectionViewCell.identifier, for: indexPath)
            cell.setCinema(cinema: movieItem?.cinema[indexPath.item], date: Date())
            return cell
        default:
            return UICollectionViewCell()
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case calendarCollectionView:
            guard let numberOfItemsInSection = movieItem?.cinema.count else {
                return
            }
            for index in 0..<numberOfItemsInSection {
                guard let cell = sheduleCollectionView.cellForItem(at: IndexPath(item: index, section: 0)) as? SheduleCollectionViewCell else {
                    return
                }
                cell.setCinema(cinema: movieItem?.cinema[index], date: dates[indexPath.item].dateValue)
            }

        default:
            break
        }
    }

}

// MARK: - Private

private extension ShowtimesView {

    private func addCalendarCollectionView() {
        let itemSize = CGSize(width: 63, height: 50)
        let itemLayoutSize = NSCollectionLayoutSize(widthDimension: .absolute(itemSize.width),
                                                    heightDimension: .absolute(itemSize.height))
        let item = NSCollectionLayoutItem(layoutSize: itemLayoutSize)
        item.contentInsets.leading = 8
        item.contentInsets.trailing = 8
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(itemSize.width * CGFloat(Constant.days)),
                                               heightDimension: .fractionalHeight(1))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])
        group.contentInsets.top = 8
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
        let bgItem = NSCollectionLayoutDecorationItem.background(elementKind: "background")
        bgItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
        section.decorationItems = [bgItem]
        section.orthogonalScrollingBehavior = .continuous
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.scrollDirection = .horizontal
        let layout = UICollectionViewCompositionalLayout(section: section, configuration: config)
        layout.register(DateBackgroundView.self, forDecorationViewOfKind: "background")
        let collectionFrame = CGRect(origin: .zero,
                                     size: CGSize(width: itemSize.width,
                                                  height: itemSize.height))
        calendarCollectionView = UICollectionView(frame: collectionFrame, collectionViewLayout: layout)
        calendarCollectionView.clipsToBounds = false
        calendarCollectionView.showsVerticalScrollIndicator = false
        calendarCollectionView.showsHorizontalScrollIndicator = false
        calendarCollectionView.backgroundColor = UIColor.clear
        calendarCollectionView.translatesAutoresizingMaskIntoConstraints = false
        calendarCollectionView.register(R.nib.calendarItemCollectionViewCell)

        calendarContainerView.addSubview(calendarCollectionView)

        calendarCollectionView.topAnchor.constraint(equalTo: calendarContainerView.topAnchor, constant: 0).isActive = true
        calendarCollectionView.bottomAnchor.constraint(equalTo: calendarContainerView.bottomAnchor, constant: 0).isActive = true
        calendarCollectionView.leadingAnchor.constraint(equalTo: calendarContainerView.leadingAnchor, constant: 0).isActive = true
        calendarCollectionView.trailingAnchor.constraint(equalTo: calendarContainerView.trailingAnchor, constant: 0).isActive = true

        calendarCollectionView.delegate = self
        calendarCollectionView.dataSource = self
    }

    private func addSheduleCollectionView() {
        let boundsSize = sheduleContainerView.bounds.size

        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: (boundsSize.width - (Constant.sectionInset.left + Constant.sectionInset.right)).rounded(),
                                     height: 294)

        flowLayout.sectionInset = Constant.sectionInset
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumLineSpacing = Constant.minimumLineSpacing

        let collectionFrame = CGRect(origin: .zero,
                                     size: CGSize(width: boundsSize.width,
                                                  height: flowLayout.itemSize.height + flowLayout.sectionInset.bottom + flowLayout.sectionInset.top))
        sheduleCollectionView = UICollectionView(frame: collectionFrame, collectionViewLayout: flowLayout)
        sheduleCollectionView.clipsToBounds = false
        sheduleCollectionView.showsVerticalScrollIndicator = false
        sheduleCollectionView.showsHorizontalScrollIndicator = false
        sheduleCollectionView.backgroundColor = UIColor.loadColorFromBundle(name: "bg200")
        sheduleCollectionView.translatesAutoresizingMaskIntoConstraints = false
        sheduleCollectionView.register(R.nib.sheduleCollectionViewCell)

        sheduleContainerView.addSubview(sheduleCollectionView)

        sheduleCollectionView.topAnchor.constraint(equalTo: sheduleContainerView.topAnchor, constant: 0).isActive = true
        sheduleCollectionView.bottomAnchor.constraint(equalTo: sheduleContainerView.bottomAnchor, constant: 0).isActive = true
        sheduleCollectionView.leadingAnchor.constraint(equalTo: sheduleContainerView.leadingAnchor, constant: 0).isActive = true
        sheduleCollectionView.trailingAnchor.constraint(equalTo: sheduleContainerView.trailingAnchor, constant: 0).isActive = true

        sheduleCollectionView.delegate = self
        sheduleCollectionView.dataSource = self
    }

    private func generateDates() {
        let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        let today = calendar.startOfDay(for: Date())
        guard let weekdays = calendar.range(of: .weekday, in: .weekOfYear, for: today) else {
            return
        }
        let dayss = (weekdays.lowerBound ..< weekdays.upperBound).compactMap {
            calendar.date(byAdding: .day, value: $0 - 1, to: today)
        }

        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = "dd"
        let weekFormatter = DateFormatter()
        weekFormatter.dateFormat = "EE"

        _ = dayss.map {
            dates.append(Day(dayOfTheWeek: weekFormatter.string(from: $0),
                             dateOfTheWeek: dayFormatter.string(from: $0),
                             dateValue: $0))
        }
    }
}

private final class DateBackgroundView: UICollectionReusableView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        backgroundColor = .white
        layer.cornerRadius = 8.0
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
