//
//  TodoContentWritingMainView.swift
//  A day is no longer 24 hours
//
//  Created by 서승우 on 2023/10/22.
//

import UIKit

enum TodoContentWritingTableViewSection: Int, CaseIterable {
    case detail
}

final class TodoContentWritingMainView: BaseView {
    // MARK: - View
    let prevButton = {
        var config = UIButton.Configuration.plain()
        config.baseForegroundColor = Constraints.Color.systemBlue
        config.background.backgroundColor = Constraints.Color.clear
        config.title = "이전으로"
        let button = UIButton(configuration: config)
        button.setContentHuggingPriority(.defaultHigh, for: .vertical)
        return button
    }()
    let addButtom = {
        var config = UIButton.Configuration.plain()
        config.baseForegroundColor = Constraints.Color.systemBlue
        config.background.backgroundColor = Constraints.Color.clear
        config.title = "추가하기"
        let button = UIButton(configuration: config)
        button.setContentHuggingPriority(.defaultHigh, for: .vertical)
        return button
    }()

    let tableHeaderView = TodoContentWritingTableHeaderView(frame: .zero)
    lazy var tableView = {
        let view = UITableView(
            frame: .zero,
            style: .grouped
        )
        view.tableHeaderView = tableHeaderView
        view.backgroundColor = Constraints.Color.black
        view.estimatedRowHeight = UITableView.automaticDimension
        view.estimatedSectionHeaderHeight = UITableView.automaticDimension
        view.estimatedSectionFooterHeight = UITableView.automaticDimension
        view.register(
            TodoDetailTodoWritingCell.self,
            forCellReuseIdentifier: TodoDetailTodoWritingCell.identifier
        )
        view.register(
            TodoDetailTodoWritingAddHeader.self,
            forHeaderFooterViewReuseIdentifier: TodoDetailTodoWritingAddHeader.identifier
        )
        view.register(
            TodoDetailTodoWritingAddFooter.self,
            forHeaderFooterViewReuseIdentifier: TodoDetailTodoWritingAddFooter.identifier
        )
        return view
    }()

    override func initialHierarchy() {
        super.initialHierarchy()

        [prevButton, addButtom, tableView].forEach { addSubview($0) }
    }

    override func initialLayout() {
        super.initialLayout()

        let offset = 4
        prevButton.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(offset)
            make.leading.equalToSuperview()
        }

        addButtom.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(offset)
            make.trailing.equalToSuperview()
        }

        tableView.snp.makeConstraints { make in
            make.top.equalTo(addButtom.snp.bottom).offset(offset)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(safeAreaLayoutGuide)
        }
    }

}
