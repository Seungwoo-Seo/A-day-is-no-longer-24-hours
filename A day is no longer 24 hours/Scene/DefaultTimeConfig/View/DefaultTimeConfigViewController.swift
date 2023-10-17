//
//  DefaultTimeConfigViewController.swift
//  A day is no longer 24 hours
//
//  Created by 서승우 on 2023/10/12.
//

import HGCircularSlider
import UIKit

final class DefaultTimeConfigViewController: BaseViewController {
    // MARK: - View
    private let mainView = DefaultTimeConfigMainView()

    // MARK: - ViewModel
    private let viewModel: DefaultTimeConfigViewModel

    // MARK: - Init
    private init(_ viewModel: DefaultTimeConfigViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    convenience init(viewModel: DefaultTimeConfigViewModel) {
        self.init(viewModel)

        viewModel.whenIsBedTimeToString.bind { [weak self] (text) in
            guard let self else {return}
            self.mainView.bedTimeLabel.text = text
        }

        viewModel.whenIsWakeUpTimeToString.bind { [weak self] (text) in
            guard let self else {return}
            self.mainView.wakeUpTimeLabel.text = text
        }

        viewModel.howMuchSleepTimeToString.bind { [weak self] (howMuchSleepTimeToString) in
            guard let self else {return}
            self.mainView.sleepHourAndMinuteLabel.text = howMuchSleepTimeToString
        }

        viewModel.howMuchSleepTimeValidity.bind { [weak self] (bool) in
            guard let self else {return}
            if bool {
                self.mainView.nextButtom.isEnabled = true
                self.mainView.rangeCircularSlider.trackFillColor = Constraints.Color.white
                self.mainView.sleepHourToMinuteValidityLabel.textColor = Constraints.Color.white
                self.mainView.sleepHourToMinuteValidityLabel.text = "적절한 수면 시간을 정해보세요!"
            } else {
                self.mainView.nextButtom.isEnabled = false
                self.mainView.rangeCircularSlider.trackFillColor = Constraints.Color.red
                self.mainView.sleepHourToMinuteValidityLabel.textColor = Constraints.Color.red
                self.mainView.sleepHourToMinuteValidityLabel.text = "수면 시간이 너무 작거나 너무 큽니다."
            }
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = mainView
    }

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Initial Setting
    override func initialAttributes() {
        super.initialAttributes()

        view.backgroundColor = Constraints.Color.black
        mainView.nextButtom.addTarget(
            self,
            action: #selector(didTapNextButton),
            for: .touchUpInside
        )
        mainView.rangeCircularSlider.addTarget(
            self,
            action: #selector(valueChangedRangeCircularSlider),
            for: .valueChanged
        )

    }

    // MARK: - Event
    @objc
    private func didTapNextButton(
        _ sender: UIButton
    ) {
        // 애초에 nextButton은 활성화가 되어 있어야 tap
        viewModel.nextButtonTapped.value.toggle()
    }

    @objc
    private func valueChangedRangeCircularSlider(
        _ sender: RangeCircularSlider
    ) {
        // TODO: 비즈니스 로직들인데 여기서 직접 사용하는게 맘에 안든다. 근데 메서드 따로 만들어서 했는데 왜 안되는지 모르겠음 - 1
        viewModel.adjustValue(
            value: &sender.startPointValue
        )
        viewModel.adjustValue(
            value: &sender.endPointValue
        )
        viewModel.updateTimes(
            startPointValue: sender.startPointValue,
            endPointValue: sender.endPointValue
        )
        viewModel.updateHowMuchSleepTimeValidity()
    }

}
