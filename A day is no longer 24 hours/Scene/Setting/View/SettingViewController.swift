//
//  SettingViewController.swift
//  A day is no longer 24 hours
//
//  Created by 서승우 on 2023/10/30.
//

import UIKit

final class SettingViewController: BaseViewController {
    // MARK: - View
    private let mainView = SettingMainView()

    // MARK: - ViewModel
    let viewModel = SettingViewModel()

    // MARK: - Life Cycle
    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    // MARK: - Initial Setting
    override func initialAttributes() {
        super.initialAttributes()

        navigationItem.backButtonTitle = "설정"
        mainView.collectionView.delegate = self
    }

}

extension SettingViewController: UICollectionViewDelegate {

    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        pushToOnboardingTabViewController()
    }

}

private extension SettingViewController {

    func pushToOnboardingTabViewController() {
        let vc = OnboardingTabViewController()
        navigationController?.pushViewController(
            vc,
            animated: true
        )
    }

}
