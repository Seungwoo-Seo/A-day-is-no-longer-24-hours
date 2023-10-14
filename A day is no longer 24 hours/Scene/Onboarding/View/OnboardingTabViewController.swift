//
//  OnboardingTabViewController.swift
//  A day is no longer 24 hours
//
//  Created by 서승우 on 2023/10/14.
//

import Pageboy
import UIKit

final class OnboardingTabViewController: PageboyViewController {
    // MARK: - View
    private let viewControllers: [UIViewController]

    // MARK: - Init
    private init(_ viewModel: OnboardingViewModel) {
        self.viewControllers = [
            SleepTimeViewController(viewModel: viewModel.sleepTimeViewModel),
            DateDivideViewController(viewModel: viewModel.dateDivideViewModel)
        ]
        super.init(nibName: nil, bundle: nil)
    }

    convenience init(viewModel: OnboardingViewModel) {
        self.init(viewModel)

        viewModel.lifeTime.bind { _ in
            self.scrollToPage(.next, animated: true)
        }

        viewModel.sleepTimeViewModel.nextButtonTapped.bind(
            subscribeNow: false
        ) { [weak self] _ in
            guard let self else {return}
            self.scrollToPage(.next, animated: true)
        }

        viewModel.dateDivideViewModel.prevButtonTapped.bind(
            subscribeNow: false
        ) { [weak self] _ in
            guard let self else {return}
            self.scrollToPage(.previous, animated: true)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        dataSource = self
        isScrollEnabled = false
    }
}

// MARK: - PageboyViewControllerDataSource
extension OnboardingTabViewController: PageboyViewControllerDataSource {

    func numberOfViewControllers(
        in pageboyViewController: PageboyViewController
    ) -> Int {
        return viewControllers.count
    }

    func viewController(
        for pageboyViewController: PageboyViewController,
        at index: PageboyViewController.PageIndex
    ) -> UIViewController? {
        return viewControllers[index]
    }

    func defaultPage(
        for pageboyViewController: PageboyViewController
    ) -> PageboyViewController.Page? {
        return nil
    }

}
