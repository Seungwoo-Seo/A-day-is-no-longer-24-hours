//
//  TodoAddContainerViewController.swift
//  A day is no longer 24 hours
//
//  Created by 서승우 on 2023/10/20.
//

import Pageboy
import UIKit

final class TodoAddContainerViewController: PageboyViewController {

    // MARK: - ViewModel
    let viewModel: TodoAddViewModel

    // MARK: - Init
    init(viewModel: TodoAddViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        bind()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func bind() {
        viewModel.dayDividedSelectViewModel.prevButtonTapped.bind(
            subscribeNow: false
        ) { [weak self] _ in
            guard let self else {return}
            self.dismiss(animated: true)
        }

        viewModel.dayDividedSelectViewModel.nextButtonTapped.bind(subscribeNow: false) { [weak self] _ in
            guard let self else {return}
            self.scrollToPage(.next, animated: true)
        }

        viewModel.todoTimeSettingViewModel.prevButtonTapped.bind(
            subscribeNow: false
        ) { [weak self] _ in
            guard let self else {return}
            self.scrollToPage(.previous, animated: true)
        }

        viewModel.todoTimeSettingViewModel.nextButtonTapped.bind(
            subscribeNow: false
        ) { [weak self] _ in
            guard let self else {return}
            self.scrollToPage(.next, animated: true)
        }

        viewModel.todoContentWritingViewModel.prevButtonTapped.bind(subscribeNow: false) { [weak self] (bool) in
            guard let self else {return}
            self.scrollToPage(.previous, animated: true)
        }


        viewModel.isDone.bind { [weak self] (bool) in
            guard let self else {return}
            self.dismiss(animated: true)
        }
    }

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        dataSource = self
        isScrollEnabled = false
    }
}

// MARK: - PageboyViewControllerDataSource
extension TodoAddContainerViewController: PageboyViewControllerDataSource {

    func numberOfViewControllers(
        in pageboyViewController: PageboyViewController
    ) -> Int {
        return viewModel.numberOfViewControllers
    }

    func viewController(
        for pageboyViewController: PageboyViewController,
        at index: PageboyViewController.PageIndex
    ) -> UIViewController? {
        return viewModel.viewControllerCorresponding(to: index)
    }

    func defaultPage(
        for pageboyViewController: PageboyViewController
    ) -> PageboyViewController.Page? {
        return nil
    }

}
