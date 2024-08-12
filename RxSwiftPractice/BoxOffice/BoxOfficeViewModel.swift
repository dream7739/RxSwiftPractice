//
//  BoxOfficeViewModel.swift
//  RxSwiftPractice
//
//  Created by 홍정민 on 8/8/24.
//

import Foundation
import RxSwift
import RxCocoa

final class BoxOfficeViewModel: BaseViewModel {
    private let disposeBag = DisposeBag()
    
    struct Input {
        let searchText: ControlProperty<String>
        let searchButtonTap: ControlEvent<Void>
    }
    
    struct Output {
        let movieList: PublishSubject<[DailyBoxOfficeList]>
    }
    
    func transform(input: Input) -> Output {
        let movieList = PublishSubject<[DailyBoxOfficeList]>()
        
        input.searchButtonTap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(input.searchText)
            .distinctUntilChanged()
            .map {
                guard let intText = Int($0) else {
                    return 20240808
                }
                return intText
            }
            .map { "\($0)" }
            .flatMap { NetworkManager.shared.callRequest(date: $0)
                    .catch{ error in
                        return Single<BoxOffice>.never()
                    }
            }
            .debug("Button Tap")
            .subscribe { value in
                movieList.onNext(value.boxOfficeResult.dailyBoxOfficeList)
            } onError: { error in
                print("error", error)
            } onCompleted: {
                print("complete")
            } onDisposed: {
                print("dispose")
            }.disposed(by: disposeBag)

        
        return Output(movieList: movieList)
    }
    
    
}
