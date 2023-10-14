//
//  DayDivideViewController.swift
//  A day is no longer 24 hours
//
//  Created by 서승우 on 2023/10/13.
//

import TextFieldEffects
import UIKit

final class DateDivideViewController: BaseViewController {
    // MARK: - View
    private lazy var prevButton = {
        var config = UIButton.Configuration.plain()
        config.baseForegroundColor = Constraints.Color.systemBlue
        config.background.backgroundColor = Constraints.Color.clear
        config.title = "이전으로"
        let button = UIButton(configuration: config)
        button.setContentHuggingPriority(.defaultHigh, for: .vertical)
        button.addTarget(
            self,
            action: #selector(didTapPrevButton),
            for: .touchUpInside
        )
        return button
    }()
    private let descriptionLabel = {
        let label = UILabel()
        label.text = "하루는 더 이상 24시간이 아닙니다. 하루를 나눠서 n배 생산적이고 효율적인 삶을 살아보세요."
        label.textColor = Constraints.Color.white
        label.font = Constraints.Font.Insensitive.systemFont_24_semibold
        label.numberOfLines = 0
        return label
    }()
    private let topAdviceLabel = {
        let label = UILabel()
        label.text = "수면 시간을 제외한 생활시간을 나누게 됩니다."
        label.textColor = Constraints.Color.darkGray
        label.font = Constraints.Font.Insensitive.systemFont_17_semibold
        label.numberOfLines = 0
        return label
    }()
    private lazy var dateDividePickerView = {
        let view = UIPickerView()
        view.dataSource = self
        view.delegate = self
        view.backgroundColor = Constraints.Color.lightGray_alpha012
        view.tintColor = Constraints.Color.white
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        return view
    }()
    private lazy var dateDivideSelectButton = {
        var config = UIButton.Configuration.filled()
        config.baseForegroundColor = Constraints.Color.black
        config.background.backgroundColor = Constraints.Color.white
        let button = UIButton(configuration: config)
        button.addTarget(self, action: #selector(didTapDayDivideSelectButton), for: .touchUpInside)
        return button
    }()
    private let bottomAdviceLabel = {
        let label = UILabel()
        label.text = "사용자의 생활시간을 알고리즘을 통해 가장 최적화된 일수로 자동 분할했습니다."
        label.textColor = Constraints.Color.darkGray
        label.font = Constraints.Font.Insensitive.systemFont_17_semibold
        label.numberOfLines = 0
        return label
    }()

    // MARK: - ViewModel
    private let viewModel: DateDivideViewModel

    // MARK: - Init
    private init(_ viewModel: DateDivideViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    convenience init(viewModel: DateDivideViewModel) {
        self.init(viewModel)

        viewModel.dayDivideValueList.bind(
            subscribeNow: false
        ) { list in
            self.dateDividePickerView.reloadAllComponents()
            self.dateDividePickerView.selectRow(0, inComponent: 0, animated: true)
            self.viewModel.dayDivideValue.value = list.first ?? 1
        }

        viewModel.dayDivideValue.bind { value in
            self.dateDivideSelectButton.configuration?.title = "\(value)일로 나누기"
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Initial Setting
    override func initialAttributes() {
        super.initialAttributes()

        view.backgroundColor = Constraints.Color.black
    }

    override func initialHierarchy() {
        super.initialHierarchy()

        [
            prevButton,
            dateDividePickerView,
            descriptionLabel,
            topAdviceLabel,
            bottomAdviceLabel,
            dateDivideSelectButton
        ].forEach { view.addSubview($0) }
    }

    override func initialLayout() {
        super.initialLayout()

        let offset = 16
        let inset = 8
        prevButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalToSuperview()
        }

        dateDividePickerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(inset)
        }

        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(prevButton.snp.bottom).offset(offset)
            make.bottom.equalTo(topAdviceLabel.snp.top).offset(-offset)
            make.horizontalEdges.equalToSuperview().inset(inset)
        }

        topAdviceLabel.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(offset)
            make.horizontalEdges.equalToSuperview().inset(inset)
            make.bottom.equalTo(dateDividePickerView.snp.top).offset(-offset)
        }

        bottomAdviceLabel.snp.makeConstraints { make in
            make.top.equalTo(dateDividePickerView.snp.bottom).offset(offset)
            make.horizontalEdges.equalToSuperview().inset(inset)
        }

        dateDivideSelectButton.snp.makeConstraints { make in
            make.top.greaterThanOrEqualTo(bottomAdviceLabel.snp.bottom).offset(offset)
            make.horizontalEdges.equalToSuperview().inset(inset)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(inset*2)
            make.height.equalTo(44)
        }
    }

    // MARK: - Event
    @objc
    private func didTapPrevButton() {
        viewModel.prevButtonTapped.value.toggle()
    }

    @objc
    private func didTapDayDivideSelectButton() {
        viewModel.dateDivideSelectButtonTapped.value.toggle()
    }
}

// MARK: - UIPickerViewDataSource
extension DateDivideViewController: UIPickerViewDataSource {

    func numberOfComponents(
        in pickerView: UIPickerView
    ) -> Int {
        return viewModel.numberOfComponents
    }

    func pickerView(
        _ pickerView: UIPickerView,
        numberOfRowsInComponent component: Int
    ) -> Int {
        return viewModel.numberOfRowsInComponent
    }

}

// MARK: - UIPickerViewDelegate
extension DateDivideViewController: UIPickerViewDelegate {

    func pickerView(
        _ pickerView: UIPickerView,
        attributedTitleForRow row: Int,
        forComponent component: Int
    ) -> NSAttributedString? {
        return viewModel.attributedTitleForRow(row)
    }

    func pickerView(
        _ pickerView: UIPickerView,
        didSelectRow row: Int,
        inComponent component: Int
    ) {
        viewModel.didSelectRow(row)
    }

}
