//
//  ScheduleViewController.swift
//  A day is no longer 24 hours
//
//  Created by 서승우 on 2023/09/30.
//

import FSCalendar
import UIKit

final class ScheduleViewController: BaseViewController {
    // MARK: - View
    private let titleLabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 24, weight: .bold)
        return label
    }()
    private lazy var titleBarButtonItem = UIBarButtonItem(customView: titleLabel)
    private lazy var addTodoBarButtonItem = {
        let button = UIBarButtonItem(
            image: UIImage(systemName: "plus"),
            style: .plain,
            target: self,
            action: #selector(didTapAddTodoBarButtonItem)
        )
        button.tintColor = Constraints.Color.white
        return button
    }()
    private lazy var calendarView = {
        let view = FSCalendar(frame: .zero)
        view.dataSource = self
        view.delegate = self
        view.backgroundColor = Constraints.Color.black
        view.scope = .week
        view.headerHeight = 0
        view.locale = Locale(identifier: "ko_KR")
        view.appearance.todayColor = Constraints.Color.clear
        view.appearance.titleTodayColor = Constraints.Color.todayColor
        view.appearance.weekdayTextColor = Constraints.Color.white
        view.appearance.titleDefaultColor = Constraints.Color.white
        view.select(view.today)
        return view
    }()
    private lazy var collectionView = {
        let view = UICollectionView(
            frame: .zero,
            collectionViewLayout: self.collectionViewLayout()
        )
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.backgroundColor = Constraints.Color.black
        return view
    }()
    private lazy var dateBranchButton = {
        var config = UIButton.Configuration.plain()
        config.baseForegroundColor = .white
        config.title = "분기처리"
        let button = UIButton(configuration: config)
        button.configurationUpdateHandler = { button in
            switch button.state {
            case .selected:
                print("selected")
            default:
                print("normal")
            }
        }
        button.addTarget(self, action: #selector(didTapDateBranchButton), for: .touchUpInside)
        return button
    }()

    @objc func didTapDateBranchButton(_ sender: UIButton) {
        let vc = UINavigationController(rootViewController: DateBranchViewController())
//        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }

    // MARK: - ViewModel
    let viewModel = ScheduleViewModel()

    // MARK: - DataSource
    var dataSource: UICollectionViewDiffableDataSource<TodoSection, Todo>!
    var snapshot: NSDiffableDataSourceSnapshot<TodoSection, Todo>!

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        configureDataSource()

        // bind
        viewModel.currentMonth.bind { [weak self] (currentMonth) in
            guard let self else {return}
            self.titleLabel.text = currentMonth
        }

        viewModel.todoSectionList.bind { [weak self] (todoSectionList) in
            guard let self else {return}
            var snapshot = NSDiffableDataSourceSnapshot<TodoSection, Todo>()
            snapshot.appendSections(todoSectionList)
            self.snapshot = snapshot
            self.dataSource.apply(snapshot)
        }

        // initial input
        viewModel.currentMonth.value = viewModel.currentPage(date: calendarView.currentPage)

        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            let section = TodoSection(kind: .simple, startTime: "08:00", endTime: "09:00", category: "식사", title: nil)
            self.viewModel.todoSectionList.value.append(section)
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
            let section = TodoSection(kind: .detail, startTime: "12:00", endTime: "18:00", category: "업무", title: "새싹 과제", todoList: [
                Todo(title: "첫번째 씬", sectionIdentifier: ""),
                Todo(title: "두번째 씬", sectionIdentifier: ""),
                Todo(title: "세번째 씬", sectionIdentifier: ""),
                Todo(title: "네번째 씬", sectionIdentifier: "")
            ])
            let section1 = TodoSection(kind: .simple, startTime: "18:00", endTime: "19:00", category: "식사", title: nil)
            let section2 = TodoSection(kind: .simple, startTime: "19:00", endTime: "20:00", category: "운동", title: nil)
            let section3 = TodoSection(kind: .detail, startTime: "20:00", endTime: "22:00", category: "공부", title: "클린 아키텍쳐", todoList: [
                Todo(title: "네트워크", sectionIdentifier: ""),
                Todo(title: "MVVM", sectionIdentifier: ""),
                Todo(title: "MVC", sectionIdentifier: ""),
                Todo(title: "라이브러리", sectionIdentifier: ""),
                Todo(title: "라이브러리", sectionIdentifier: ""),
                Todo(title: "라이브러리", sectionIdentifier: ""),
                Todo(title: "라이브러리", sectionIdentifier: ""),
                Todo(title: "라이브러리", sectionIdentifier: "")
            ])

            [
                section,
                section1,
                section2,
                section3
            ].forEach { self.viewModel.todoSectionList.value.append($0) }
        }
    }

    // MARK: - Initial Setting
    override func initialAttributes() {
        super.initialAttributes()

    }

    override func initialHierarchy() {
        super.initialHierarchy()

        navigationItem.leftBarButtonItem = titleBarButtonItem
        navigationItem.rightBarButtonItem = addTodoBarButtonItem
        [calendarView, collectionView, dateBranchButton].forEach { view.addSubview($0) }
    }

    override func initialLayout() {
        super.initialLayout()

        calendarView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(300)
        }

        collectionView.snp.makeConstraints { make in
            make.top.equalTo(calendarView.snp.bottom)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }

        dateBranchButton.snp.makeConstraints { make in
            make.center.equalTo(collectionView)
        }
    }

    // MARK: - Event
    @objc
    private func didTapAddTodoBarButtonItem(_ sender: UIBarButtonItem) {
        presentActionSheet()
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

    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        switch calendar.scope {
        case .month:
            viewModel.currentMonth.value = viewModel.currentPage(
                date: calendarView.currentPage,
                isMonth: true
            )
        case .week:
            viewModel.currentMonth.value = viewModel.currentPage(
                date: calendarView.currentPage
            )
        @unknown default:
            fatalError("calendar scope case 추가됌")
        }
    }

    func calendar(
        _ calendar: FSCalendar,
        didSelect date: Date,
        at monthPosition: FSCalendarMonthPosition
    ) {
        // 한국 시간으로 변경 필요
        let format = DateFormatter()
        format.locale = Locale(identifier: "ko_KR")
        format.dateFormat = "yyyyMMdd"
        let tapDate = format.string(from: date) // 년월일 이니까 Unique 하다.
        print("탭한 날은 -> \(tapDate)")

        // 탭 했을 때 해당 날짜가 분기처리 되었는지 확인하고

        // 만약 분기 처리가 되어 있다면 Tabman을 이용한 분기처리와 TimeLine, addTodoBarButtomItem을 보여주고
        // flotyButton을 숨긴다.

        // 되어 있지 않다면 Tabman, TimeLineView, addTodoBarButtonItem을 숨기고 flotyButton을 보여준다.
    }

}

// MARK: - FSCalendarDelegateAppearance
extension ScheduleViewController: FSCalendarDelegateAppearance {

    func calendar(
        _ calendar: FSCalendar,
        appearance: FSCalendarAppearance,
        fillSelectionColorFor date: Date
    ) -> UIColor? {
        return calendar.today == date ? Constraints.Color.todayColor : Constraints.Color.white
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

// MARK: - DetailTodoHeaderProtocol
extension ScheduleViewController: DetailTodoHeaderProtocol {

    func didTapExpandButton(_ sender: ExpandButton) {
        if sender.isSelected {
            if sender.identifier == "12:0018:00" {
                snapshot.deleteItems(viewModel.todoSectionList.value.filter{ $0.identifier == "12:0018:00" }.first!.todoList)
            } else {
                snapshot.deleteItems(viewModel.todoSectionList.value.filter{ $0.identifier == "20:0022:00" }.first!.todoList)
            }
        } else {
            if sender.identifier == "12:0018:00" {
                snapshot.appendItems(
                    viewModel.todoSectionList.value.filter{ $0.identifier == "12:0018:00" }.first!.todoList,
                    toSection: viewModel.todoSectionList.value.filter{ $0.identifier == "12:0018:00" }.first!
                )
            } else {
                snapshot.appendItems(
                    viewModel.todoSectionList.value.filter{ $0.identifier == "20:0022:00" }.first!.todoList,
                    toSection: viewModel.todoSectionList.value.filter{ $0.identifier == "20:0022:00" }.first!
                )
            }
        }
        dataSource.apply(snapshot)
        sender.isSelected.toggle()
    }

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
            supplementaryView.configure(self, todoSection: todoSection)
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

// MARK: - Action
private extension ScheduleViewController {

    func goToToday() {
        calendarView.select(calendarView.today)
    }

    func presentActionSheet() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        let simple = UIAlertAction(title: "간단한 Todo", style: .default)
        let detail = UIAlertAction(title: "자세한 Todo", style: .default)
        [cancel, simple, detail].forEach { alert.addAction($0) }
        present(alert, animated: true)
    }

}
