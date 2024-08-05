//
//  BirthdayViewModel.swift
//  RxSwiftPractice
//
//  Created by 홍정민 on 8/5/24.
//

import Foundation
import RxSwift
import RxCocoa

final class BirthdayViewModel {
    
    let disposeBag = DisposeBag()
    
    struct Input {
        let date: Driver<Date>
        let tap: ControlEvent<Void>
    }
    
    struct Output {
        let tap: ControlEvent<Void>
        let year: BehaviorRelay<Int>
        let month: BehaviorRelay<Int>
        let day: BehaviorRelay<Int>
        let validation: Observable<Bool>
    }
    
    func transform(input: Input) -> Output {
        let year = BehaviorRelay(value: 0)
        let month = BehaviorRelay(value: 0)
        let day = BehaviorRelay(value: 0)
        
        input.date
            .drive(with: self) { owner, value in
                let component = Calendar.current.dateComponents([.year, .month, .day], from: value)
                year.accept(component.year!)
                month.accept(component.month!)
                day.accept(component.day!)
            }
            .disposed(by: disposeBag)
        
        let validation = input.date
            .map { value in
                let compare = Calendar.current.dateComponents([.year], from: value, to: Date())
                let age = compare.year!
                return age > 17
            }.asObservable()
            
        return Output(
            tap: input.tap,
            year: year,
            month: month,
            day: day,
            validation: validation
        )
    }
}
