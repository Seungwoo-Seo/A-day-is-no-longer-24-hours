//
//  ViewModelType.swift
//  A day is no longer 24 hours
//
//  Created by 서승우 on 2023/11/27.
//

import Foundation

protocol ViewModelType {
    associatedtype Input
    associatedtype Output

    func transform(input: Input) -> Output
}

