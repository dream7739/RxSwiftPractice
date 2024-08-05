//
//  SignUpViewModel.swift
//  RxSwiftPractice
//
//  Created by 홍정민 on 8/5/24.
//

import Foundation
import RxSwift
import RxCocoa

final class SignUpViewModel {
    let validationText = BehaviorRelay(value: "이메일은 8자 이상이어야 합니다")

    struct Input {
        let tap: ControlEvent<Void>
        let validTap: ControlEvent<Void>
        let email: ControlProperty<String?>
    }
    
    struct Output {
        let tap: ControlEvent<Void>
        let validTap: ControlEvent<Void>
        let validation: Observable<Bool>
        let countValidation: Observable<Bool>
    }
    
    func transform(input: Input) -> Output {
        let validation = input.email
            .orEmpty
            .map { $0.count >= 8 }
        
        let countValidation = input.email
            .orEmpty
            .map { $0.isEmpty }
        
        return Output(
            tap: input.tap,
            validTap: input.validTap,
            validation: validation,
            countValidation: countValidation
        )
    }
    
}
