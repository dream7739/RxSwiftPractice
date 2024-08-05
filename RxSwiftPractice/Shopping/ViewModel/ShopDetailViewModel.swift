//
//  ShopDetailViewModel.swift
//  RxSwiftPractice
//
//  Created by 홍정민 on 8/5/24.
//

import Foundation
import RxSwift
import RxCocoa

final class ShopDetailViewModel {
    let detailData = BehaviorRelay(value: "")
    var editTitleSender: ((String) -> Void)?

    struct Input {
        let title: ControlProperty<String?>
        let navigationTap: ControlEvent<Void>
    }
    
    struct Output {
        let validation: Observable<Bool>
        let editText: Observable<String>
    }
    
    func transform(input: Input) -> Output {
        let validation = input.title
            .orEmpty
            .map { $0.isEmpty }
        
        let editText = input.navigationTap
            .withLatestFrom(input.title.orEmpty)
            
        return Output(
            validation: validation,
            editText: editText
        )
    }
}
