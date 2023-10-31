//
//  SettingMainView.swift
//  A day is no longer 24 hours
//
//  Created by 서승우 on 2023/10/30.
//

import UIKit

final class SettingMainView: BaseView {
    // MARK: - View
    lazy var collectionView = {
        let view = UICollectionView(
            frame: .zero,
            collectionViewLayout: createLayout()
        )
        view.backgroundColor = Constraints.Color.black
        return view
    }()

    // MARK: - DataSource
    private var dataSource: UICollectionViewDiffableDataSource<SettingSection, SettingItemIdentifier>!

    // MARK: - Initial Setting
    override func initialAttributes() {
        super.initialAttributes()

        configureDataSource()
        initialSnapshotApply()
    }

    override func initialHierarchy() {
        super.initialHierarchy()

        addSubview(collectionView)
    }

    override func initialLayout() {
        super.initialLayout()

        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
    }
}

private extension SettingMainView {

    enum SettingSection: Int, CaseIterable {
        case change
        case normal

        var items: [SettingItemIdentifier] {
            switch self {
            case .change:
                return [
                    SettingItemIdentifier(text: "기본 수면 시간 설정")
                ]
            case .normal:
                return []
            }
        }
    }

    struct SettingItemIdentifier: Hashable {
        let text: String
    }

    func createLayout() -> UICollectionViewLayout {
        var config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        config.backgroundColor = Constraints.Color.black
        let layout = UICollectionViewCompositionalLayout.list(using: config)
        return layout
    }

    func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, SettingItemIdentifier> { (cell, indexPath, itemIdentifier) in
            var backgroundConfig = UIBackgroundConfiguration.listPlainCell()
            backgroundConfig.backgroundColor = Constraints.Color.lightGray_alpha012
            cell.backgroundConfiguration = backgroundConfig

            var contentConfig = cell.defaultContentConfiguration()
            contentConfig.textProperties.color = Constraints.Color.white
            contentConfig.text = itemIdentifier.text
            cell.contentConfiguration = contentConfig
        }

        dataSource = UICollectionViewDiffableDataSource<SettingSection, SettingItemIdentifier>(
            collectionView: collectionView
        ) { collectionView, indexPath, itemIdentifier in
            return collectionView.dequeueConfiguredReusableCell(
                using: cellRegistration,
                for: indexPath,
                item: itemIdentifier
            )
        }
    }

    func initialSnapshotApply() {
        var snapshot = NSDiffableDataSourceSnapshot<SettingSection, SettingItemIdentifier>()
        snapshot.appendSections(SettingSection.allCases)
        for section in SettingSection.allCases {
            snapshot.appendItems(section.items, toSection: section)
        }
        dataSource.apply(snapshot)
    }

}
