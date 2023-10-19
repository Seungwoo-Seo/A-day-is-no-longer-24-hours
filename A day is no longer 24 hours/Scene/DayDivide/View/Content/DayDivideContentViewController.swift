//
//  DayDivideContentViewController.swift
//  A day is no longer 24 hours
//
//  Created by 서승우 on 2023/10/19.
//

import UIKit

final class DayDivideContentViewController: BaseViewController {
    // MARK: - View
    private lazy var collectionView = {
        let view = UICollectionView(
            frame: .zero,
            collectionViewLayout: collectionViewLayout()
        )
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.backgroundColor = Constraints.Color.black
        return view
    }()

    // MARK: - ViewModel
    let viewModel: DayDivideContentViewModel

    // MARK: - Init
    init(viewModel: DayDivideContentViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    deinit {
        print(#function)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - DataSource
    var dataSource: UICollectionViewDiffableDataSource<TodoSection, Todo>!
    var snapshot: NSDiffableDataSourceSnapshot<TodoSection, Todo>!

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        configureDataSource()

        viewModel.todoSectionList.bind { [weak self] (todoSectionList) in
            guard let self else {return}
            var snapshot = NSDiffableDataSourceSnapshot<TodoSection, Todo>()
            snapshot.appendSections(todoSectionList)
            self.snapshot = snapshot
            self.dataSource.apply(snapshot)
        }

        DispatchQueue.main.asyncAfter(deadline: .now()) {
            let section =  TodoSection(kind: .startStandard, startTime: "06:00", endTime: "", category: "DayN 시작", title: nil)

            self.viewModel.todoSectionList.value.append(section)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            let section = TodoSection(kind: .simple, startTime: "08:00", endTime: "09:00", category: "아침식사", title: nil)
            self.viewModel.todoSectionList.value.append(section)
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
            let section = TodoSection(kind: .detail, startTime: "12:00", endTime: "18:00", category: "업무", title: "새싹 과제", todoList: [
                Todo(title: "첫번째 씬", sectionIdentifier: ""),
                Todo(title: "두번째 씬", sectionIdentifier: ""),
                Todo(title: "세번째 씬", sectionIdentifier: ""),
                Todo(title: "네번째 씬", sectionIdentifier: "")
            ])
            let section1 = TodoSection(kind: .simple, startTime: "18:00", endTime: "19:00", category: "32회차 리펙토링 및 반복 학습", title: nil)
            let section2 = TodoSection(kind: .simple, startTime: "19:00", endTime: "20:00", category: "달리고 달리고 존나 달리고 달리고 달려 달리기", title: nil)
            let section3 = TodoSection(kind: .detail, startTime: "20:00", endTime: "22:00", category: "아키텍처 공부", title: "클린 아키텍쳐", todoList: [
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

        DispatchQueue.main.asyncAfter(deadline: .now() + 9) {
            let section =  TodoSection(kind: .endStandard, startTime: "", endTime: "24:00", category: "DayN 마감", title: nil)

            self.viewModel.todoSectionList.value.append(section)
        }
    }

    override func initialHierarchy() {
        super.initialHierarchy()

        view.addSubview(collectionView)
    }

    override func initialLayout() {
        super.initialLayout()

        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

// MARK: - CollectionViewLayout
private extension DayDivideContentViewController {

    func collectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] (sectionIndex, environment) in
            guard let self else {return nil}
            let section = self.viewModel.getTodoSection(section: sectionIndex)
            switch section.kind {
            case .startStandard: return self.startStandardSection()
            case .simple: return self.simpleSection()
            case .detail: return self.detailSection()
            case .endStandard: return self.endStandardSection()
            }
        }

        return layout
    }

    func startStandardSection() -> NSCollectionLayoutSection {
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
            elementKind: StartStandardTodoHeader.identifier,
            alignment: .top
        )
        section.boundarySupplementaryItems = [header]

        return section
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

    func endStandardSection() -> NSCollectionLayoutSection {
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
            elementKind: EndStandardTodoHeader.identifier,
            alignment: .top
        )
        section.boundarySupplementaryItems = [header]

        return section
    }

}

// MARK: - CollectionViewDataSource
private extension DayDivideContentViewController {

    func configureDataSource() {
        let startStandardHeaderRegistration = UICollectionView.SupplementaryRegistration<StartStandardTodoHeader>(
            elementKind: StartStandardTodoHeader.identifier
        ) { [weak self] (supplementaryView, elementKind, indexPath) in
            guard let self else {return}
            let standardSection = self.viewModel.getTodoSection(section: indexPath.section)
            supplementaryView.configure(standardSection)
        }

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

        let endStandardHeaderRegistration = UICollectionView.SupplementaryRegistration<EndStandardTodoHeader>(
            elementKind: EndStandardTodoHeader.identifier
        ) { [weak self] (supplementaryView, elementKind, indexPath) in
            guard let self else {return}
            let standardSection = self.viewModel.getTodoSection(section: indexPath.section)
            supplementaryView.configure(standardSection)
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
            if kind == StartStandardTodoHeader.identifier {
                return collectionView.dequeueConfiguredReusableSupplementary(
                    using: startStandardHeaderRegistration,
                    for: indexPath
                )
            } else if kind == SimpleTodoHeader.identifier {
                return collectionView.dequeueConfiguredReusableSupplementary(
                    using: simpleHeaderRegistration,
                    for: indexPath
                )
            } else if kind == DetailTodoHeader.identifier {
                return collectionView.dequeueConfiguredReusableSupplementary(
                    using: detailHeaderRegistration,
                    for: indexPath
                )
            } else if kind == EndStandardTodoHeader.identifier {
                return collectionView.dequeueConfiguredReusableSupplementary(
                    using: endStandardHeaderRegistration,
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

// MARK: - DetailTodoHeaderProtocol
extension DayDivideContentViewController: DetailTodoHeaderProtocol {

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
