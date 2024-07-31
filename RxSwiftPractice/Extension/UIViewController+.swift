//
//  Alert.swift
//  RxSwiftPractice
//
//  Created by 홍정민 on 7/30/24.
//

import UIKit

extension UIViewController {
    func showAlert(title: String?, content: String?){
        let alert = UIAlertController(title: title, message: content, preferredStyle: .alert)
        let action = UIAlertAction(title: "확인", style: .default)
        alert.addAction(action)
        present(alert, animated: true)
    }
}
