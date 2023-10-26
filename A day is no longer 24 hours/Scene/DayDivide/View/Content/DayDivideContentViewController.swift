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

    // MARK: - DataSource
    var dataSource: UICollectionViewDiffableDataSource<TodoStruct, DetailTodoStruct>!
    var snapshot: NSDiffableDataSourceSnapshot<TodoStruct, DetailTodoStruct>!

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        configureDataSource()

        viewModel.todoStructList.bind { [weak self] (todoStructList) in
            guard let self else {return}
            var snapshot = NSDiffableDataSourceSnapshot<TodoStruct, DetailTodoStruct>()
            snapshot.appendSections(todoStructList)
            self.snapshot = snapshot
            self.dataSource.apply(snapshot)
        }
    }

    override func initialAttributes() {
        super.initialAttributes()
        
        view.backgroundColor = Constraints.Color.black
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
            let todo = self.viewModel.getTodoSection(section: indexPath.section)
            supplementaryView.configure(self, todo: todo)
        }

        let detailHeaderRegistration = UICollectionView.SupplementaryRegistration<DetailTodoHeader>(
            elementKind: DetailTodoHeader.identifier
        ) { [weak self] (supplementaryView, elementKind, indexPath) in
            guard let self else {return}
            let todo = self.viewModel.getTodoSection(section: indexPath.section)
            supplementaryView.configure(self, todo: todo)
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

        let detailTodoCellRegistration = UICollectionView.CellRegistration<DetailTodoCell, DetailTodoStruct> { cell, indexPath, itemIdentifier in
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

// MARK: - SimpleTodoHeaderProtocol
extension DayDivideContentViewController: SimpleTodoHeaderProtocol {

    func didTapSimpleTodoHeader(_ todo: TodoStruct) {
        presentAlert { [weak self] in
            guard let self else {return}
            self.viewModel.didTapSimpleTodoHeader(todo)
        }
    }

}

// MARK: - DetailTodoHeaderProtocol
extension DayDivideContentViewController: DetailTodoHeaderProtocol {

    func didTapDetailTodoHeader(_ todo: TodoStruct) {
        presentAlert { [weak self] in
            guard let self else {return}
            self.viewModel.didTapDetailTodoHeader(todo)
        }
    }

    func didTapExpandButton(_ sender: ExpandButton) {
        viewModel.test(
            isSelected: sender.isSelected,
            identifier: sender.identifier,
            append: {
                self.snapshot.appendItems($0, toSection: $1)
                self.dataSource.apply(self.snapshot)
            },
            delete: {
                self.snapshot.deleteItems($0)
                self.dataSource.apply(self.snapshot)
            }
        )

        sender.isSelected.toggle()
    }

}

private extension DayDivideContentViewController {

    func presentAlert(completion: @escaping () -> ()) {
        let alert = UIAlertController(title: "삭제하시겠습니까?", message: nil, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "아니오", style: .cancel)
        let confirm = UIAlertAction(title: "네", style: .default) { _ in
            completion()
        }
        [cancel, confirm].forEach { alert.addAction($0) }
        present(alert, animated: true)
    }

}
