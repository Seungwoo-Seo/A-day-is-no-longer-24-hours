//
//  DefaultTimeConfigViewController.swift
//  A day is no longer 24 hours
//
//  Created by 서승우 on 2023/10/12.
//

import UIKit
import HGCircularSlider
import RxCocoa
import RxSwift

final class DefaultTimeConfigViewController: BaseViewController {
    // MARK: - View
    private let mainView = DefaultTimeConfigMainView()

    private let disposeBag = DisposeBag()

    init(viewModel: DefaultTimeConfigViewModel) {
        super.init(nibName: nil, bundle: nil)

        let pointValueChanged = PublishRelay<(start: CGFloat, end: CGFloat)>()

        let input = DefaultTimeConfigViewModel.Input(
            sliderValueChanged: mainView.rangeCircularSlider.rx.controlEvent(.valueChanged),
            pointValueChanged: pointValueChanged,
            nextButtonTapped: mainView.nextButtom.rx.tap
        )

        let output = viewModel.transform(input: input)
        output.adjustValue
            .bind(with: self) { owner, _ in
                // Rx스럽진 않지만 inout 파라미터를 사용해야하기 때문에 어쩔 수 없다.
                viewModel.adjustValue(value: &owner.mainView.rangeCircularSlider.startPointValue)
                viewModel.adjustValue(value: &owner.mainView.rangeCircularSlider.endPointValue)
                pointValueChanged.accept(
                    (owner.mainView.rangeCircularSlider.startPointValue,
                     owner.mainView.rangeCircularSlider.endPointValue)
                )
            }
            .disposed(by: disposeBag)

        output.whenIsBedTimeToString
            .bind(to: mainView.bedTimeLabel.rx.text)
            .disposed(by: disposeBag)

        output.whenIsWakeUpTimeToString
            .bind(to: mainView.wakeUpTimeLabel.rx.text)
            .disposed(by: disposeBag)

        output.howMuchSleepTimeToString
            .bind(to: mainView.sleepHourAndMinuteLabel.rx.text)
            .disposed(by: disposeBag)

        output.howMuchSleepTimeState
            .bind(with: self) { owner, state in
                switch state {
                case .available:
                    owner.mainView.nextButtom.isEnabled = true
                    owner.mainView.rangeCircularSlider.trackFillColor = Constraints.Color.white
                    owner.mainView.sleepHourToMinuteValidityLabel.textColor = Constraints.Color.white
                case .unavailable:
                    owner.mainView.nextButtom.isEnabled = false
                    owner.mainView.rangeCircularSlider.trackFillColor = Constraints.Color.red
                    owner.mainView.sleepHourToMinuteValidityLabel.textColor = Constraints.Color.red
                }
                owner.mainView.sleepHourToMinuteValidityLabel.text = state.description
            }
            .disposed(by: disposeBag)
    }

    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
}
