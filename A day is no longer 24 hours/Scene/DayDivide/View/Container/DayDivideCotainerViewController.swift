//
//  DayDivideCotainerViewController.swift
//  A day is no longer 24 hours
//
//  Created by 서승우 on 2023/10/17.
//

import Pageboy
import Tabman
import UIKit

import SnapKit

final class DayDivideCotainerViewController: TabmanViewController {
    // MARK: - View
    lazy var viewControllers: [UIViewController] = []

    // MARK: - ViewModel
    let viewModel: DayDivideContainerViewModel

    // MARK: - Init
    init(viewModel: DayDivideContainerViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        dataSource = self

        // Create bar
        let bar = TMBar.ButtonBar()
        bar.delegate = self
        bar.layout.contentMode = .intrinsic
        bar.layout.alignment = .centerDistributed


        bar.layout.transitionStyle = .snap // Customize
        // Add to view
        addBar(bar, dataSource: self, at: .top)

        bind()
    }

    func bind() {
        viewModel.viewControllers.bind { _ in
            self.reloadData()
        }
    }

}

extension DayDivideCotainerViewController: PageboyViewControllerDataSource {

    func numberOfViewControllers(
        in pageboyViewController: PageboyViewController
    ) -> Int {
        return viewModel.numberOfViewControllers
    }

    func viewController(
        for pageboyViewController: PageboyViewController,
        at index: PageboyViewController.PageIndex
    ) -> UIViewController? {
        return viewModel.viewController(index: index)
    }

    func defaultPage(
        for pageboyViewController: PageboyViewController
    ) -> PageboyViewController.Page? {
        return nil
    }

}

extension DayDivideCotainerViewController: TMBarDataSource {

    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        let title = "Page \(index)"
        return TMBarItem(title: title)
    }

}
