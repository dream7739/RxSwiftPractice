//
//  PhoneViewModel.swift
//  RxSwiftPractice
//
//  Created by 홍정민 on 8/5/24.
//

import Foundation
import RxSwift
import RxCocoa

final class PhoneViewModel {
    let phoneDescription = BehaviorRelay(value: "010")
    let validationText = BehaviorRelay(value: "전화번호는 10자리 이상이어야 합니다")
    
    struct Input {
        let tap: ControlEvent<Void>
        let phone: ControlProperty<String?>
    }
    
    struct Output {
        let tap: ControlEvent<Void>
        let validation: Observable<Bool>
    }
    
    func transform(input: Input) -> Output {
        
        let validation = input.phone
            .orEmpty
            .map { $0.count >= 10 }
            
        return Output(
            tap: input.tap,
            validation: validation
        )
    }
}
