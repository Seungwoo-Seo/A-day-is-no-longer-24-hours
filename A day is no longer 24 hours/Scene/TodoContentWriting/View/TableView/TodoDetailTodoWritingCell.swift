//
//  TodoDetailTodoWritingCell.swift
//  A day is no longer 24 hours
//
//  Created by 서승우 on 2023/10/22.
//

import UIKit

protocol TodoDetailTodoWritingCellDelegate: AnyObject {
    func didTapDeleteButton(
        item: DetailTodo
    )
    func editingChangedDetailTodoTextField(
        _ text: String,
        item: DetailTodo
    )
}

/// Todo 컨텐츠 중 "자세한 Todo" 작성하는 셀
final class TodoDetailTodoWritingCell: BaseTableViewCell {
    // MARK: - View
    lazy var detailTodoTextField = {
        let textField = UITextField()
        textField.delegate = self
        textField.textColor = Constraints.Color.white
        textField.tintColor = Constraints.Color.white
        textField.backgroundColor = Constraints.Color.lightGray_alpha012
        textField.borderStyle = .roundedRect
        textField.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        textField.addTarget(self, action: #selector(editingChangedDetailTodoTextField), for: .editingChanged)
        return textField
    }()
    lazy var deleteButton = {
        var config = UIButton.Configuration.plain()
        config.baseForegroundColor = Constraints.Color.red
        config.background.backgroundColor = Constraints.Color.clear
        config.image = UIImage(systemName: "minus.circle")
        let button = UIButton(configuration: config)
        button.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        button.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        button.addTarget(self, action: #selector(didTapDeleteButton), for: .touchUpInside)
        return button
    }()

    @objc
    func didTapDeleteButton() {
        guard let detailTodo else {return}
        delegate?.didTapDeleteButton(
            item: detailTodo
        )
    }

    @objc
    func editingChangedDetailTodoTextField(_ sender: UITextField) {
        guard let detailTodo else {return}
        guard let text = sender.text else {return}
        delegate?.editingChangedDetailTodoTextField(
            text,
            item: detailTodo
        )
    }

    // MARK: - delegate
    weak var delegate: TodoDetailTodoWritingCellDelegate?

    // MARK: - ItemIdentifier
    var detailTodo: DetailTodo?

    func configure(detailTodo: DetailTodo?) {
        self.detailTodo = detailTodo
        detailTodoTextField.text = detailTodo?.text
    }


    // MARK: - Life Cycle
    override func prepareForReuse() {
        super.prepareForReuse()

        // 초기화
        detailTodoTextField.text = ""
    }

    // MARK: - Initial Setting
    override func initialAttributes() {
        super.initialAttributes()

        backgroundColor = Constraints.Color.black
        selectionStyle = .none
    }

    override func initialHierarchy() {
        super.initialHierarchy()

        [detailTodoTextField, deleteButton].forEach { contentView.addSubview($0) }
    }

    override func initialLayout() {
        super.initialLayout()

        let offset = 8
        let inset = 8
        let height = 44
        detailTodoTextField.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.bottom.equalToSuperview().inset(inset)
            make.height.equalTo(height)
        }

        deleteButton.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalTo(detailTodoTextField.snp.trailing).offset(offset)
            make.trailing.bottom.equalToSuperview().inset(inset)
            make.height.equalTo(height)
        }
    }

}

extension TodoDetailTodoWritingCell: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}
