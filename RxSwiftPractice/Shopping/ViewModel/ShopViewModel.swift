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
    var data = ShopResult.list
    private var recommoendList = ["루피 키보드", "루피 우산", "루피 마우스", "루피 인형", "루피 우비"]
    
    let disposeBag = DisposeBag()
    
    struct Input {
        let checkButtonClicked: PublishRelay<Int>
        let starButtonClicked: PublishRelay<Int>
        let itemDelete: ControlEvent<IndexPath>
        let itemSelect: ControlEvent<IndexPath>
        let modelSelect: ControlEvent<Shop>
        let recommendItemSelect: ControlEvent<IndexPath>
        let recommendModelSelect: ControlEvent<String>
        let modifyTitle: PublishRelay<(Int, String)>
        let addTap: ControlEvent<Void>
        let addText: ControlProperty<String?>
        let searchText: ControlProperty<String?>
    }
    
    struct Output {
        let items: BehaviorRelay<[Shop]>
        let selectedData: Observable<(idx: Int, data: ControlEvent<Shop>.Element)>
        let recommendData: BehaviorRelay<[String]>
    }
    
    func transform(input: Input) -> Output {
        let items = BehaviorRelay(value: data)
        let recommendData = BehaviorRelay(value: recommoendList)

        input.itemDelete
            .bind(with: self) { owner, index in
                owner.data.remove(at: index.row)
                items.accept(owner.data)
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
                    items.accept(owner.data)
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
                    items.accept(filterList)
                }else{
                    items.accept(owner.data)
                }
            }
            .disposed(by: disposeBag)
        
        input.checkButtonClicked
            .bind(with: self) { owner, row in
                owner.data[row].isComplete.toggle()
                items.accept(owner.data)
            }
            .disposed(by: disposeBag)
        
        input.starButtonClicked
            .bind(with: self) { owner, row in
                owner.data[row].isFavorited.toggle()
                items.accept(owner.data)
            }
            .disposed(by: disposeBag)
        
        Observable.zip(input.recommendItemSelect, input.recommendModelSelect)
            .map { return $0.1 }
            .bind(with: self) { owner, value in
                let shop = Shop(title: value)
                owner.data.append(shop)
                items.accept(owner.data)
            }
            .disposed(by: disposeBag)
        
        input.modifyTitle
            .bind(with: self) { owner, value in
                owner.data[value.0].title = value.1
                items.accept(owner.data)
            }
            .disposed(by: disposeBag)
        
        return Output(
            items: items,
            selectedData: selectedData,
            recommendData: recommendData
        )
    }
}
