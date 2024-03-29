//
//  CustomObservable.swift
//  A day is no longer 24 hours
//
//  Created by 서승우 on 2023/09/30.
//

import Foundation

final class CustomObservable<T> {
    private var listener: ((T) -> ())?

    var value: T {
        didSet {
            listener?(value)
        }
    }

    init(_ value: T) {
        self.value = value
    }

    func bind(
        subscribeNow: Bool = true,
        _ closure: @escaping ((T) -> ())
    ) {
        if subscribeNow {
            closure(value)
        }
        listener = closure
    }

}
