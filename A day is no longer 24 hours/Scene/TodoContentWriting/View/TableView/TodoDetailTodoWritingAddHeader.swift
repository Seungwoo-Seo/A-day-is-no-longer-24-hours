//
//  TodoDetailTodoWritingAddHeader.swift
//  A day is no longer 24 hours
//
//  Created by 서승우 on 2023/10/22.
//

import UIKit

final class TodoDetailTodoWritingAddHeader: BaseTableViewHeaderFooterView {
    let titleLabel = {
        let label = UILabel()
        let appendAtt = NSAttributedString(
            string: "(선택사항)",
            attributes: [
                .foregroundColor: Constraints.Color.white.withAlphaComponent(0.5),
                .font: Constraints.Font.Insensitive.systemFont_17_semibold
            ]
        )
        let attributedText = NSMutableAttributedString(
            string: "자세한 할 일 추가 ",
            attributes: [
                .foregroundColor: Constraints.Color.white,
                .font: Constraints.Font.Insensitive.systemFont_24_semibold
            ]
        )
        attributedText.append(appendAtt)
        label.attributedText = attributedText
        return label
    }()

    override func initialAttributes() {
        super.initialAttributes()

        backgroundColor = Constraints.Color.clear
        contentView.backgroundColor = Constraints.Color.clear
    }

    override func initialHierarchy() {
        super.initialHierarchy()

        addSubview(titleLabel)
    }

    override func initialLayout() {
        super.initialLayout()

        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.horizontalEdges.bottom.equalToSuperview().inset(8)
        }
    }

}
