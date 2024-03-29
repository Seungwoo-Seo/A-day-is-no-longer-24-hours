//
//  OnboardingTabViewController.swift
//  A day is no longer 24 hours
//
//  Created by 서승우 on 2023/10/14.
//

import UIKit
import Pageboy
import RxCocoa
import RxSwift

final class OnboardingTabViewController: PageboyViewController {

    // MARK: - ViewModel
    private let disposeBag = DisposeBag()
    private let viewModel = OnboardingViewModel()

    // MARK: - Init
    init() {
        super.init(nibName: nil, bundle: nil)

        let input = OnboardingViewModel.Input()
        let output = viewModel.transform(input: input)

        output.scrollToDefaultDivideConfig
            .bind(with: self) { owner, void in
                owner.scrollToPage(.next, animated: true)
            }
            .disposed(by: disposeBag)

        output.backScrollToDefaultTimeConfig
            .bind(with: self) { owner, void in
                owner.scrollToPage(.previous, animated: true)
            }
            .disposed(by: disposeBag)

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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        tabBarController?.tabBar.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        tabBarController?.tabBar.isHidden = false
    }

}

// MARK: - PageboyViewControllerDataSource
extension OnboardingTabViewController: PageboyViewControllerDataSource {

    func numberOfViewControllers(
        in pageboyViewController: PageboyViewController
    ) -> Int {
        return viewModel.viewControllers.count
    }

    func viewController(
        for pageboyViewController: PageboyViewController,
        at index: PageboyViewController.PageIndex
    ) -> UIViewController? {
        return viewModel.viewControllers[index]
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
        sceneDelegate?.window?.rootViewController = TabBarController()
        sceneDelegate?.window?.makeKeyAndVisible()
    }

}
