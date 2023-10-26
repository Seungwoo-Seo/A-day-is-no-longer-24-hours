//
//  TodoTimeSettingViewController.swift
//  A day is no longer 24 hours
//
//  Created by 서승우 on 2023/10/20.
//

import UIKit

// 살짝 아쉽긴 한데 일단 유저가 알맞게 선택해주길
final class TodoTimeSettingViewController: BaseViewController {
    // MARK: - View
    let mainView = TodoTimeSettingMainView()

    // MARK: - ViewModel
    let viewModel: TodoTimeSettingViewModel

    // MARK: - Init
    init(viewModel: TodoTimeSettingViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    // MARK: - Life Cycle
    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.whenIsUseHourMinuteList.bind { [weak self] _ in
            guard let self else {return}

            self.mainView.whenIsStartView.picker.reloadAllComponents()
            self.mainView.whenIsStartView.picker.selectRow(0, inComponent: 0, animated: false)
            self.mainView.whenIsStartView.picker.selectRow(0, inComponent: 1, animated: false)
        }

        viewModel.livingHourMinuteList.bind { [weak self] _ in
            guard let self else {return}

            self.mainView.howMuchToDoView.picker.reloadAllComponents()
            self.mainView.howMuchToDoView.picker.selectRow(0, inComponent: 0, animated: false)
            self.mainView.howMuchToDoView.picker.selectRow(0, inComponent: 1, animated: false)
        }

        viewModel.whenIsStartViewBottomDescriptionText.bind { [weak self] (text) in
            guard let self else {return}

            self.mainView.whenIsStartView.setBottomDescriptionLabel(text: text)
        }

        viewModel.howMuchTodoViewBottomDescriptionText.bind { [weak self] (text) in
            guard let self else {return}

            self.mainView.howMuchToDoView.setBottomDescriptionLabel(text: text)
        }

        viewModel.timeOverFlow.bind { [weak self] (bool) in
            guard let self else {return}
            if bool {
                self.mainView.errorLabel.text = ""
                self.mainView.nextButtom.isEnabled = true
            } else {
                self.mainView.errorLabel.text = "선택하신 하루의 종료 시각을 넘어가는 설정은 불가능합니다."
                self.mainView.nextButtom.isEnabled = false
            }
        }

        viewModel.timeAvailable.bind { [weak self] (bool) in
            guard let self else {return}
            if bool {
                self.mainView.errorLabel.text = ""
                self.mainView.nextButtom.isEnabled = true
            } else {
                self.mainView.errorLabel.text = "선택하신 시간 범위에 이미 할 일이 있습니다."
                self.mainView.nextButtom.isEnabled = false
            }
        }
    }

    // MARK: - Initial Setting
    override func initialAttributes() {
        super.initialAttributes()

        view.backgroundColor = Constraints.Color.black
        mainView.prevButton.addTarget(
            self,
            action: #selector(didTapPrevButton),
            for: .touchUpInside
        )
        mainView.nextButtom.addTarget(
            self,
            action: #selector(didTapNextButton),
            for: .touchUpInside
        )
        mainView.whenIsStartView.picker.dataSource = self
        mainView.howMuchToDoView.picker.dataSource = self
        mainView.whenIsStartView.picker.delegate = self
        mainView.howMuchToDoView.picker.delegate = self
    }

    // MARK: - Event
    @objc
    private func didTapPrevButton(_ sender: UIButton) {
        viewModel.prevButtonTapped.value.toggle()
    }

    @objc
    private func didTapNextButton(_ sender: UIButton) {
        viewModel.nextButtonTapped.value.toggle()
    }

}

extension TodoTimeSettingViewController: UIPickerViewDataSource {

    func numberOfComponents(
        in pickerView: UIPickerView
    ) -> Int {
        return viewModel.numberOfComponents
    }

    func pickerView(
        _ pickerView: UIPickerView,
        numberOfRowsInComponent component: Int
    ) -> Int {
        return viewModel.numberOfRowsInComponent(
            component,
            tag: pickerView.tag
        )
    }

}

extension TodoTimeSettingViewController: UIPickerViewDelegate {

    func pickerView(
        _ pickerView: UIPickerView,
        attributedTitleForRow row: Int,
        forComponent component: Int
    ) -> NSAttributedString? {
        return viewModel.attributedTitleForRow(
            row,
            forComponent: component,
            tag: pickerView.tag
        )
    }

    func pickerView(
        _ pickerView: UIPickerView,
        didSelectRow row: Int,
        inComponent component: Int
    ) {
        viewModel.didSelectRow(
            row,
            inComponent: component,
            tag: pickerView.tag
        ) {
            // component가 0일 떄만 호출할 것
            pickerView.reloadComponent(1)
            // 이걸 일단 강제해줘야하는게 아쉽다
            // 시를 올리는 선택을 하면 좋은 동작이지만
            // 반대로 시를 내릴 때 분이 0번째 row로 강제되는게 안좋은 동작인거 같은데
            // 강제할 수 밖에 없는 이유가
            // 각 시마다 분의 개수가 다 다르기 때문에
            // 더 많은 분을 가지고 있는 시에서 분을 스크롤 하던 도중
            // 더 적은 분을 가지고 있는 시를 선택하는 순간 인덱스 아웃 오브 레인지 에러가 발생할 수 있어서 앱이 터지게 되기 때문에
            // 그걸 막고자 좀 강제하게 되었다.
            pickerView.selectRow(0, inComponent: 1, animated: false)

            // 필연적인 상황이 있어
            // 예를들어 6시간이 맥스라면 분은 0일텐데
            // 이전에 1분이라는 분을 선택하고 있었다면
            // 이 값을 업데이트 해줘야 하잖아
            return pickerView.selectedRow(
                inComponent: 1
            )
        }
    }

}
