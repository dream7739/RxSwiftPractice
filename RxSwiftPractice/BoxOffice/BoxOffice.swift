//
//  BoxOffice.swift
//  RxSwiftPractice
//
//  Created by 홍정민 on 8/8/24.
//

import Foundation

struct BoxOffice: Decodable {
    let boxOfficeResult: BoxOfficeResult
}

struct BoxOfficeResult: Decodable {
    let dailyBoxOfficeList: [DailyBoxOfficeList]
}

struct DailyBoxOfficeList: Decodable {
    let movieNm: String
    let openDt: String
}
