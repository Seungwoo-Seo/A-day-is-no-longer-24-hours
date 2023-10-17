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
    private lazy var viewControllers = [
        DefaultTimeConfigViewController(viewModel: viewModel.defaultTimeConfigViewModel),
        DefaultDivideConfigViewController(viewModel: viewModel.dateDivideViewModel)
    ]

    // MARK: - ViewModel
    private let viewModel = OnboardingViewModel()

    // MARK: - Init
    init() {
        super.init(nibName: nil, bundle: nil)

        viewModel.defaultTimeConfigViewModel.nextButtonTapped.bind(
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

        viewModel.createDefaultDayConfigurationTableValidity.bind(
            subscribeNow: false
        ) { [weak self] (bool) in
            guard let self else {return}
            if bool {
                self.windowResetByScheduleViewController()
            } else {
                self.presentErrorAlert()
            }
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

private extension OnboardingTabViewController {

    func presentErrorAlert() {
        let alert = UIAlertController(
            title: "현재 하루를 나눌 수 없습니다.",
            message: nil,
            preferredStyle: .alert
        )
        let cancel = UIAlertAction(title: "확인", style: .default)
        alert.addAction(cancel)
        present(alert, animated: true)
    }

    func windowResetByScheduleViewController() {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let sceneDelegate = windowScene?.delegate as? SceneDelegate
        sceneDelegate?.window?.rootViewController = UINavigationController(
            rootViewController: ScheduleViewController()
        )
        sceneDelegate?.window?.makeKeyAndVisible()
    }

}
