//
//  TodoDetailTodoWritingAddFooter.swift
//  A day is no longer 24 hours
//
//  Created by 서승우 on 2023/10/22.
//

import UIKit

/// Todo 컨턴츠 중 "자세한 Todo"를 작성할 수 있는 뷰를 "추가" 해줄 Footer
final class TodoDetailTodoWritingAddFooter: BaseTableViewHeaderFooterView {
    let detailTodoAddButton = {
        var config = UIButton.Configuration.plain()
        config.baseForegroundColor = Constraints.Color.systemBlue
        config.background.backgroundColor = Constraints.Color.clear
        config.image = UIImage(systemName: "plus")
        let button = UIButton(configuration: config)
        return button
    }()

    override func initialAttributes() {
        super.initialAttributes()

        backgroundColor = Constraints.Color.clear
        contentView.backgroundColor = Constraints.Color.clear
    }

    override func initialHierarchy() {
        super.initialHierarchy()

        addSubview(detailTodoAddButton)
    }

    override func initialLayout() {
        super.initialLayout()

        detailTodoAddButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

}
