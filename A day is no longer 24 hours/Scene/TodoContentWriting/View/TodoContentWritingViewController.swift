//
//  TodoContentWritingViewController.swift
//  A day is no longer 24 hours
//
//  Created by 서승우 on 2023/10/22.
//

import UIKit

final class TodoContentWritingViewController: BaseViewController {
    // MARK: - View
    let mainView = TodoContentWritingMainView()

    // MARK: - TableView
    private var dataSource: UITableViewDiffableDataSource<TodoContentWritingTableViewSection, DetailTodo>!

    // MARK: - ViewModel
    let viewModel: TodoContentWritingViewModel

    // MARK: - Init
    init(viewModel: TodoContentWritingViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    // MARK: - Life Cycle
    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.detailTodoList.bind { [weak self] (detailTodoList) in
            guard let self else {return}

            var snapshot = NSDiffableDataSourceSnapshot<TodoContentWritingTableViewSection, DetailTodo>()
            snapshot.appendSections(TodoContentWritingTableViewSection.allCases)
            snapshot.appendItems(detailTodoList, toSection: .detail)
            self.dataSource.apply(snapshot)
        }

        viewModel.categoryExists.bind(
            subscribeNow: false
        ) { [weak self] (bool) in
            guard let self else {return}
            if bool {
                self.mainView.tableHeaderView.errorLabel.text = ""
            } else {
                self.mainView.tableHeaderView.errorLabel.text = "할 일이 어떤 종류인지 적어주세요."
            }
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        // MARK: - 진짜 개 꿀팁
        sizeHeaderToFit()
    }

    // MARK: - Initial Setting
    override func initialAttributes() {
        super.initialAttributes()

        view.backgroundColor = Constraints.Color.black
        mainView.prevButton.addTarget(self, action: #selector(didTapPrevButton), for: .touchUpInside)
        mainView.addButtom.addTarget(self, action: #selector(didTapAddButton), for: .touchUpInside)
        mainView.tableHeaderView.delegate = self
        mainView.tableView.delegate = self
        configureDataSource()
    }

    func configureDataSource() {
        dataSource = UITableViewDiffableDataSource(
            tableView: mainView.tableView
        ) { [weak self] (tableView, indexPath, itemIdentifier) in
            guard let self else {return UITableViewCell()}
            let cell = tableView.dequeueReusableCell(
                withIdentifier: TodoDetailTodoWritingCell.identifier,
                for: indexPath
            ) as? TodoDetailTodoWritingCell

            cell?.delegate = self
            cell?.configure(detailTodo: itemIdentifier)

            return cell
        }
        dataSource.defaultRowAnimation = .fade
        mainView.tableView.dataSource = dataSource

        initialApply()
    }

    func initialApply() {
        var snapshot = NSDiffableDataSourceSnapshot<TodoContentWritingTableViewSection, DetailTodo>()
        snapshot.appendSections(TodoContentWritingTableViewSection.allCases)
        dataSource.apply(snapshot)
    }

    // MARK: - Event
    @objc
    func didTapPrevButton() {
        viewModel.prevButtonTapped.value.toggle()
    }

    @objc
    func didTapAddButton() {
        viewModel.addButtonTapped.value.toggle()
    }

    @objc
    func didTapDetailTodoAddButton(_ sender: UIButton) {
        let detailTodo = DetailTodo()
        viewModel.detailTodoList.value.append(detailTodo)
    }
}

extension TodoContentWritingViewController: UITableViewDelegate {

    func tableView(
        _ tableView: UITableView,
        viewForHeaderInSection section: Int
    ) -> UIView? {
        return tableView.dequeueReusableHeaderFooterView(
            withIdentifier: TodoDetailTodoWritingAddHeader.identifier
        )
    }

    func tableView(
        _ tableView: UITableView,
        viewForFooterInSection section: Int
    ) -> UIView? {
        let footer = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: TodoDetailTodoWritingAddFooter.identifier
        ) as? TodoDetailTodoWritingAddFooter
        footer?.detailTodoAddButton.addTarget(self, action: #selector(didTapDetailTodoAddButton), for: .touchUpInside)
        return footer
    }

}

extension TodoContentWritingViewController: TodoContentWritingTableHeaderViewDelegate {

    func editChangedCategoryTextField(_ text: String) {
        viewModel.category = text
    }
}

extension TodoContentWritingViewController: TodoDetailTodoWritingCellDelegate {

    func didTapDeleteButton(item: DetailTodo) {
        if let index = viewModel.detailTodoList.value.firstIndex(where: {$0.hashValue == item.hashValue}) {
            viewModel.detailTodoList.value.remove(at: index)
        }
    }

    func editingChangedDetailTodoTextField(
        _ text: String,
        item: DetailTodo
    ) {
        if let index = viewModel.detailTodoList.value.firstIndex(where: {$0.hashValue == item.hashValue}) {
            viewModel.detailTodoList.value[index].text = text
        }
    }

}

private extension TodoContentWritingViewController {

    func sizeHeaderToFit() {
        if let headerView = mainView.tableView.tableHeaderView {

            headerView.setNeedsLayout()
            headerView.layoutIfNeeded()

            let height = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
            var newFrame = headerView.frame

            // Needed or we will stay in viewDidLayoutSubviews() forever
            if height != newFrame.size.height {
                newFrame.size.height = height
                headerView.frame = newFrame

                mainView.tableView.tableHeaderView = headerView
            }
        }
    }

}
