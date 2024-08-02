//
//  Shop.swift
//  RxSwiftPractice
//
//  Created by 홍정민 on 8/2/24.
//

import Foundation


struct ShopResult {
    static var list: [Shop] = [
        Shop(isComplete: true, title: "그립톡 구매하기", isFavorited: true),
        Shop(isComplete: false, title: "사이다 구매", isFavorited: false),
        Shop(isComplete: false, title: "아이패드 케이스 최저가 알아보기", isFavorited: true),
        Shop(isComplete: false, title: "양말", isFavorited: true)
    ]
}

struct Shop {
    var isComplete: Bool
    var title: String
    var isFavorited: Bool
    
    init(isComplete: Bool = false, title: String, isFavorited: Bool = false) {
        self.isComplete = isComplete
        self.title = title
        self.isFavorited = isFavorited
    }
}
