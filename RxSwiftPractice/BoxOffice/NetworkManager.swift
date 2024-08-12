//
//  NetworkManager.swift
//  RxSwiftPractice
//
//  Created by 홍정민 on 8/8/24.
//

import Foundation
import RxSwift

enum APIError: Error {
    case invalidURL
    case unknownError
    case statusError
    case unknownResponse
}

final class NetworkManager {
    static let shared = NetworkManager()
    private init(){ }
    
    func callRequest(date: String) -> Single<BoxOffice> {

        let result = Single<BoxOffice>.create { observer in
            var component = URLComponents(string: APIURL.movieURL)
            let key = URLQueryItem(name: "key", value: APIKey.movieKey)
            let targetDt = URLQueryItem(name: "targetDt", value: date)
            component?.queryItems = [key, targetDt]
            
            guard let url = component?.url else {
                observer(.failure(APIError.invalidURL))
                return Disposables.create()
            }
            
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let _ = error {
                    observer(.failure(APIError.unknownError))
                    return
                }
                
                guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                    observer(.failure(APIError.statusError))
                    return
                }
                
                if let data = data, let decodingData = try? JSONDecoder().decode(BoxOffice.self, from: data) {
                    observer(.success(decodingData))
                } else{
                    observer(.failure(APIError.unknownResponse))
                }
            }.resume()
            
            return Disposables.create()
        }
            .debug("API 통신")
 
        return result
    }
    
}
