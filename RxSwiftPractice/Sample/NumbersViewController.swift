//
//  NumbersViewController.swift
//  RxSwiftPractice
//
//  Created by 홍정민 on 7/31/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class NumbersViewController: UIViewController {
    private let number1 = UITextField()
    private let number2 = UITextField()
    private let number3 = UITextField()
    private let plus = UILabel()
    private let seperator = UIView()
    private let result = UILabel()
    
    private let disposebag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureHierarchy()
        configureLayout()
        configureUI()
        configureCalculate()
    }
    
    private func configureHierarchy(){
        view.addSubview(number1)
        view.addSubview(number2)
        view.addSubview(number3)
        view.addSubview(plus)
        view.addSubview(seperator)
        view.addSubview(result)
        
    }
    
    private func configureLayout(){
        number1.snp.makeConstraints { make in
            make.width.equalTo(100)
            make.centerY.equalTo(view.safeAreaLayoutGuide).offset(-80)
            make.centerX.equalTo(view.safeAreaLayoutGuide)
        }
        
        number2.snp.makeConstraints { make in
            make.top.equalTo(number1.snp.bottom).offset(4)
            make.width.equalTo(100)
            make.centerX.equalTo(view.safeAreaLayoutGuide)
        }
        
        number3.snp.makeConstraints { make in
            make.top.equalTo(number2.snp.bottom).offset(4)
            make.width.equalTo(100)
            make.centerX.equalTo(view.safeAreaLayoutGuide)
        }
        
        plus.snp.makeConstraints { make in
            make.trailing.equalTo(number3.snp.leading).offset(-8)
            make.centerY.equalTo(number3)
        }
        
        seperator.snp.makeConstraints { make in
            make.top.equalTo(number3.snp.bottom).offset(8)
            make.leading.equalTo(plus)
            make.trailing.equalTo(number3)
            make.height.equalTo(1)
        }
        
        result.snp.makeConstraints { make in
            make.top.equalTo(seperator.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(seperator)
        }
    }
    
    private func configureUI(){
        number1.borderStyle = .roundedRect
        number1.textAlignment = .right
        number2.borderStyle = .roundedRect
        number2.textAlignment = .right
        number3.borderStyle = .roundedRect
        number3.textAlignment = .right
        plus.text = "+"
        seperator.backgroundColor = .black
        result.textAlignment = .right
    }
    
    func configureCalculate(){
        Observable.combineLatest(number1.rx.text.orEmpty,
                                 number2.rx.text.orEmpty,
                                 number3.rx.text.orEmpty){
            textValue1, textValue2, textValue3 -> Int in
            return (Int(textValue1) ?? 0) + (Int(textValue2) ?? 0) + (Int(textValue3) ?? 0)
        }.map {
            $0.description
        }
        .bind(to: result.rx.text)
        .disposed(by: disposebag)
            
    }
}
