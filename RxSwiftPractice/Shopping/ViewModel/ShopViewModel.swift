//
//  ShopViewModel.swift
//  RxSwiftPractice
//
//  Created by 홍정민 on 8/5/24.
//

import Foundation
import RxSwift
import RxCocoa

final class ShopViewModel {
    lazy var items = BehaviorRelay(value: data)
    var data = ShopResult.list
    
    let checkButtonClicked = PublishRelay<Int>()
    let starButtonClicked = PublishRelay<Int>()

    let disposeBag = DisposeBag()
    
    struct Input {
        let itemDelete: ControlEvent<IndexPath>
        let itemSelect: ControlEvent<IndexPath>
        let modelSelect: ControlEvent<Shop>
        let addTap: ControlEvent<Void>
        let addText: ControlProperty<String?>
        let searchText: ControlProperty<String?>
    }
    
    struct Output {
        let selectedData: Observable<(idx: Int, data: ControlEvent<Shop>.Element)>
    }
    
    func transform(input: Input) -> Output {
        input.itemDelete
            .bind(with: self) { owner, index in
                owner.data.remove(at: index.row)
                owner.items.accept(owner.data)
            }
            .disposed(by: disposeBag)
        
        input.addTap
            .withLatestFrom(input.addText.orEmpty){ void, text in
                return text
            }
            .bind(with: self) { owner, value in
                if !value.isEmpty {
                    let shop = Shop(title: value)
                    owner.data.insert(shop, at: 0)
                    owner.items.accept(owner.data)
                }
            }
            .disposed(by: disposeBag)
        
        let selectedData = Observable.zip(input.itemSelect, input.modelSelect)
            .map { index, value in
                return (idx: index.row, data: value)
            }
        
        input.searchText
            .orEmpty
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .bind(with: self) { owner, value in
                let filterList = owner.data.filter {
                    $0.title.localizedCaseInsensitiveContains(value)
                }
                
                if !filterList.isEmpty {
                    owner.items.accept(filterList)
                }else{
                    owner.items.accept(owner.data)
                }
            }
            .disposed(by: disposeBag)
        
        checkButtonClicked
            .bind(with: self) { owner, row in
                owner.data[row].isComplete.toggle()
                owner.items.accept(owner.data)
            }
            .disposed(by: disposeBag)
        
        starButtonClicked
            .bind(with: self) { owner, row in
                owner.data[row].isFavorited.toggle()
                owner.items.accept(owner.data)
            }
            .disposed(by: disposeBag)
        
        return Output(selectedData: selectedData)
    }
}
