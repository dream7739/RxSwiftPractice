//
//  PasswordViewModel.swift
//  RxSwiftPractice
//
//  Created by 홍정민 on 8/5/24.
//

import Foundation
import RxSwift
import RxCocoa

final class PasswordViewModel {
    let passwordDescription = BehaviorRelay(value: "8자 이상 입력해주세요")

    struct Input {
        let password: ControlProperty<String?>
        let tap: ControlEvent<Void>
    }
    
    struct Output {
        let validation: Driver<Bool>
        let tap: ControlEvent<Void>
    }
    
    func transform(input: Input) -> Output {
        let validation = input.password
            .orEmpty
            .map { $0.count >= 8 }
            .asDriver(onErrorJustReturn: false)
        
        return Output(
            validation: validation,
            tap: input.tap
        )
    }
}
