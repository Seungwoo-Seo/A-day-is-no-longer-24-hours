//
//  TodoContentWritingTableHeaderView.swift
//  A day is no longer 24 hours
//
//  Created by 서승우 on 2023/10/22.
//

import UIKit

protocol TodoContentWritingTableHeaderViewDelegate: AnyObject {
    func editChangedCategoryTextField(_ text: String)
}

/// Todo 컨텐츠 중 "카테고리" 작성하는 TableView의 header (section header 아님)
final class TodoContentWritingTableHeaderView: BaseView {
    let titleLabel = {
        let label = UILabel()
        label.text = "Todo의 종류를 작성해주세요."
        label.textColor = Constraints.Color.white
        label.font = Constraints.Font.Insensitive.systemFont_24_semibold
        return label
    }()
    lazy var categoryTextField = {
        let textField = UITextField()
        textField.textColor = Constraints.Color.white
        textField.tintColor = Constraints.Color.white
        textField.backgroundColor = Constraints.Color.lightGray_alpha012
        textField.attributedPlaceholder = NSAttributedString(
            string: "ex) 공부, 업무, 운동",
            attributes: [.foregroundColor: Constraints.Color.white.withAlphaComponent(0.5)]
        )
        textField.borderStyle = .roundedRect
        textField.addTarget(self, action: #selector(editChangedCategoryTextField), for: .editingChanged)
        return textField
    }()

    weak var delegate: TodoContentWritingTableHeaderViewDelegate?

    @objc
    func editChangedCategoryTextField(_ sender: UITextField) {
        guard let text = sender.text else {return}
        delegate?.editChangedCategoryTextField(text)
    }

    override func initialAttributes() {
        super.initialAttributes()

        backgroundColor = Constraints.Color.black
    }

    override func initialHierarchy() {
        super.initialHierarchy()

        [titleLabel, categoryTextField].forEach { addSubview($0) }
    }

    override func initialLayout() {
        super.initialLayout()

        let offset = 16
        let inset = 8
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(offset)
            make.horizontalEdges.equalToSuperview().inset(inset)
        }

        categoryTextField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(offset/2)
            make.horizontalEdges.equalToSuperview().inset(inset)
            make.bottom.equalToSuperview().inset(inset*2)
            make.height.equalTo(44)
        }
    }
}
