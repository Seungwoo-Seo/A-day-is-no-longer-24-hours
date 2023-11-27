//
//  DefaultDivideConfigViewController.swift
//  A day is no longer 24 hours
//
//  Created by 서승우 on 2023/10/13.
//

import UIKit
import RxCocoa
import RxSwift

final class DefaultDivideConfigViewController: BaseViewController {
    private let mainView = DefaultDivideConfigMainView()
    private let disposeBag = DisposeBag()

    init(viewModel: DefaultDivideCofigViewModel) {
        super.init(nibName: nil, bundle: nil)

        let input = DefaultDivideCofigViewModel.Input(
            itemSelected: mainView.dateDividePickerView.rx.itemSelected,
            modelSelected: mainView.dateDividePickerView.rx.modelSelected(Int.self),
            prevButtonTapped: mainView.prevButton.rx.tap,
            divideAndStartButtonTapped: mainView.divideAndStartButton.rx.tap
        )

        let output = viewModel.transform(input: input)

        output.divideValueList
            .bind(to: mainView.dateDividePickerView.rx.itemAttributedTitles) { row, item  in
                return NSAttributedString(
                    string: "\(item)",
                    attributes: [.foregroundColor: Constraints.Color.white]
                )
            }
            .disposed(by: disposeBag)

        output.divideValueList
            .bind(with: self) { owner, divideValueList in
                owner.mainView.dateDividePickerView.reloadAllComponents()
                owner.mainView.dateDividePickerView.selectRow(0, inComponent: 0, animated: true)
                viewModel.currentDivideValue.accept(divideValueList.first ?? 1)
            }
            .disposed(by: disposeBag)

        output.currentDivideValue
            .bind(with: self) { owner, divideValue in
                owner.mainView.divideAndStartButton.configuration?.title = "\(divideValue)일로 나누고 시작하기"
            }
            .disposed(by: disposeBag)

//        viewModel.divideValueList.bind() { [weak self] (list) in
//            guard let self else {return}
//            self.mainView.dateDividePickerView.reloadAllComponents()
//            self.mainView.dateDividePickerView.selectRow(0, inComponent: 0, animated: true)
//            self.viewModel.currentDivideValue.value = list.first ?? 1
//        }
//
    }

    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }

}
