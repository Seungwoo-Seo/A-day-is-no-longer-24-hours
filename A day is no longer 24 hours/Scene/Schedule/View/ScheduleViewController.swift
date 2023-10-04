//
//  ScheduleViewController.swift
//  A day is no longer 24 hours
//
//  Created by 서승우 on 2023/09/30.
//

import Floaty
import FSCalendar
import UIKit

final class ScheduleViewController: BaseViewController {
    // MARK: - View
    lazy var calendar = {
        let view = FSCalendar(frame: .zero)
        view.dataSource = self
        view.delegate = self
        view.backgroundColor = Constraints.Color.black
        view.locale = Locale(identifier: "ko_KR")
        view.appearance.headerDateFormat = "YYYY년 MM월"
        view.appearance.headerMinimumDissolvedAlpha = 0
        view.appearance.headerTitleColor = .white
        view.appearance.todayColor = Constraints.Color.clear
        view.appearance.titleTodayColor = Constraints.Color.todayColor
        view.appearance.weekdayTextColor = Constraints.Color.white
        view.appearance.titleDefaultColor = Constraints.Color.white
        return view
    }()
    lazy var collectionView = {
        let view = UICollectionView(
            frame: .zero,
            collectionViewLayout: self.collectionViewLayout()
        )
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.backgroundColor = Constraints.Color.black
        return view
    }()
    let floatyButton = {
        let button = Floaty()
        button.plusColor = Constraints.Color.black
        button.buttonColor = Constraints.Color.white
        button.addItem("Hello, World1", icon: UIImage(systemName: "heart")!)
        button.addItem("Hello, World2", icon: UIImage(systemName: "heart")!)
        return button
    }()

    // MARK: - ViewModel
    let viewModel = ScheduleViewModel()

    // MARK: - DataSource
    var dataSource: UICollectionViewDiffableDataSource<TodoSection, Todo>!

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        configureDataSource()




        viewModel.todoSectionList.bind { [weak self] (todoSectionList) in
            guard let self else {return}
            var snapshot = NSDiffableDataSourceSnapshot<TodoSection, Todo>()
            snapshot.appendSections(todoSectionList)
            self.dataSource.apply(snapshot)
        }

//        apply()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            let section = TodoSection(kind: .simple, startTime: "08:00", endTime: "09:00", category: "식사", title: nil)
            self.viewModel.todoSectionList.value.append(section)
//            self.secondApply()
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
            let section = TodoSection(kind: .detail, startTime: "12:00", endTime: "18:00", category: "업무", title: "새싹 과제")
            let section1 = TodoSection(kind: .simple, startTime: "18:00", endTime: "19:00", category: "식사", title: nil)
            let section2 = TodoSection(kind: .simple, startTime: "19:00", endTime: "20:00", category: "운동", title: nil)
            let section3 = TodoSection(kind: .detail, startTime: "20:00", endTime: "22:00", category: "공부", title: "클린 아키텍쳐")

            [
                section,
                section1,
                section2,
                section3
            ].forEach { self.viewModel.todoSectionList.value.append($0) }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        calendar.setScope(.week, animated: false)
    }

    // MARK: - Initial Setting
    override func initialAttributes() {
        super.initialAttributes()


    }

    override func initialHierarchy() {
        super.initialHierarchy()

        [calendar, collectionView, floatyButton].forEach { view.addSubview($0) }
    }

    override func initialLayout() {
        super.initialLayout()

        calendar.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(300)
        }

        collectionView.snp.makeConstraints { make in
            make.top.equalTo(calendar.snp.bottom)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }

    func apply() {
        var snapshot = NSDiffableDataSourceSnapshot<TodoSection, Todo>()
        let section = TodoSection(kind: .simple, startTime: "08:00", endTime: "09:00", category: "식사", title: nil)
        viewModel.todoSectionList.value.append(section)
        snapshot.appendSections(viewModel.todoSectionList.value)

        dataSource.apply(snapshot)
    }

    func secondApply() {
        var snapshot = NSDiffableDataSourceSnapshot<TodoSection, Todo>()
        let section = TodoSection(kind: .detail, startTime: "12:00", endTime: "18:00", category: "업무", title: "새싹 과제")
        let section1 = TodoSection(kind: .simple, startTime: "18:00", endTime: "19:00", category: "식사", title: nil)
        let section2 = TodoSection(kind: .simple, startTime: "19:00", endTime: "20:00", category: "운동", title: nil)
        let section3 = TodoSection(kind: .detail, startTime: "20:00", endTime: "22:00", category: "공부", title: "클린 아키텍쳐")

        [
            section,
            section1,
            section2,
            section3
        ].forEach { viewModel.todoSectionList.value.append($0) }

        snapshot.appendSections(viewModel.todoSectionList.value)
        snapshot.appendItems(
            [
                Todo(title: "네트워크 작업"),
                Todo(title: "MVVM 패턴 공부하기"),
                Todo(title: "MVVM 패턴 공부하기"),
                Todo(title: "MVVM 패턴 공부하기"),
                Todo(title: "MVVM 패턴 공부하기"),
                Todo(title: "MVVM 패턴 공부하기 MVVM 패턴 공부하기 MVVM 패턴 공부하기 MVVM 패턴 공부하기 MVVM 패턴 공부하기 MVVM 패턴 공부하기 MVVM 패턴 공부하기 MVVM 패턴 공부하기 MVVM 패턴 공부하기 MVVM 패턴 공부하기 MVVM 패턴 공부하기 MVVM 패턴 공부하기 MVVM 패턴 공부하기 "),
                Todo(title: "MVVM 패턴 공부하기"),
                Todo(title: "MVVM 패턴 공부하기")
            ]
        )
        dataSource.apply(snapshot)
    }

}

// MARK: - FSCalendarDataSource
extension ScheduleViewController: FSCalendarDataSource {

}

// MARK: - FSCalendarDelegate
extension ScheduleViewController: FSCalendarDelegate {

    func calendar(
        _ calendar: FSCalendar,
        boundingRectWillChange bounds: CGRect,
        animated: Bool
    ) {
        calendar.snp.updateConstraints { make in
            make.height.equalTo(bounds.height)
        }
        view.layoutIfNeeded()
    }

}

// MARK: - FSCalendarDelegateAppearance
extension ScheduleViewController: FSCalendarDelegateAppearance {

    func calendar(
        _ calendar: FSCalendar,
        appearance: FSCalendarAppearance,
        fillSelectionColorFor date: Date
    ) -> UIColor? {
        return Constraints.Color.white
    }

    func calendar(
        _ calendar: FSCalendar,
        appearance: FSCalendarAppearance,
        titleSelectionColorFor date: Date
    ) -> UIColor? {
        return Constraints.Color.black
    }

}

// MARK: - UICollectionViewDelegate
extension ScheduleViewController: UICollectionViewDelegate {

}

// MARK: - CollectionViewLayout
private extension ScheduleViewController {

    func collectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] (sectionIndex, environment) in
            guard let self else {return nil}
            let section = self.viewModel.getTodoSection(section: sectionIndex)
            switch section.kind {
            case .simple: return self.simpleSection()
            case .detail: return self.detailSection()
            }
        }

        return layout
    }

    func simpleSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(0)
        )

        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(0)
        )

        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: groupSize,
            subitems: [item]
        )

        let section = NSCollectionLayoutSection(group: group)

        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(100)
        )
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: SimpleTodoHeader.identifier,
            alignment: .top
        )
        section.boundarySupplementaryItems = [header]

        return section
    }

    func detailSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(100)
        )

        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(100)
        )

        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: groupSize,
            subitems: [item]
        )

        let section = NSCollectionLayoutSection(group: group)

        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(100)
        )
        let detailHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: DetailTodoHeader.identifier,
            alignment: .top
        )
        let footerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(100)
        )
        let detailFooter = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: footerSize,
            elementKind: DetailTodoFooter.identifier,
            alignment: .bottom
        )
        section.boundarySupplementaryItems = [detailHeader, detailFooter]

        return section
    }

}

// MARK: - CollectionViewDataSource
private extension ScheduleViewController {

    func configureDataSource() {
        let simpleHeaderRegistration = UICollectionView.SupplementaryRegistration<SimpleTodoHeader>(
            elementKind: SimpleTodoHeader.identifier
        ) { [weak self] (supplementaryView, elementKind, indexPath) in
            guard let self else {return}
            let todoSection = self.viewModel.getTodoSection(section: indexPath.section)
            supplementaryView.configure(todoSection)
        }

        let detailHeaderRegistration = UICollectionView.SupplementaryRegistration<DetailTodoHeader>(
            elementKind: DetailTodoHeader.identifier
        ) { [weak self] (supplementaryView, elementKind, indexPath) in
            guard let self else {return}
            let todoSection = self.viewModel.getTodoSection(section: indexPath.section)
            supplementaryView.configure(todoSection)
        }

        let detailFooterRegistration = UICollectionView.SupplementaryRegistration<DetailTodoFooter>(
            elementKind: DetailTodoFooter.identifier
        ) { [weak self] (supplementaryView, elementKind, indexPath) in
            guard let self else {return}
            let todoSection = self.viewModel.getTodoSection(section: indexPath.section)
            supplementaryView.configure(todoSection)
        }

        let detailTodoCellRegistration = UICollectionView.CellRegistration<DetailTodoCell, Todo> { cell, indexPath, itemIdentifier in
            cell.configure(itemIdentifier)
        }

        dataSource = UICollectionViewDiffableDataSource(
            collectionView: collectionView
        ) { (collectionView, indexPath, itemIdentifier) in
            return collectionView.dequeueConfiguredReusableCell(
                using: detailTodoCellRegistration,
                for: indexPath,
                item: itemIdentifier
            )
        }

        dataSource.supplementaryViewProvider = { (collectionView, kind, indexPath) in
            if kind == SimpleTodoHeader.identifier {
                return collectionView.dequeueConfiguredReusableSupplementary(
                    using: simpleHeaderRegistration,
                    for: indexPath
                )

            } else if kind == DetailTodoHeader.identifier {
                return collectionView.dequeueConfiguredReusableSupplementary(
                    using: detailHeaderRegistration,
                    for: indexPath
                )
            } else {
                return collectionView.dequeueConfiguredReusableSupplementary(
                    using: detailFooterRegistration,
                    for: indexPath
                )
            }
        }

    }

}
