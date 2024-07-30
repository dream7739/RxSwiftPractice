//
//  SignViewController.swift
//  RxSwiftPractice
//
//  Created by 홍정민 on 7/30/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class SignViewController: UIViewController {
    
    private let signName = UITextField()
    private let signEmail = UITextField()
    private let simpleLabel = UILabel()
    private let signButton = UIButton()
    
    private let disposebag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        configureHierarchy()
        configureLayout()
        setSign()
    }
    
    private func configureHierarchy(){
        view.addSubview(signName)
        view.addSubview(signEmail)
        view.addSubview(simpleLabel)
        view.addSubview(signButton)
    }
    
    private func configureLayout(){
        signName.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        signEmail.snp.makeConstraints { make in
            make.top.equalTo(signName.snp.bottom).offset(4)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        simpleLabel.snp.makeConstraints { make in
            make.top.equalTo(signEmail.snp.bottom).offset(4)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        signButton.snp.makeConstraints { make in
            make.top.equalTo(simpleLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        signName.backgroundColor = .systemRed
        signEmail.backgroundColor = .systemBlue
        simpleLabel.backgroundColor = .systemCyan
        signButton.backgroundColor = .systemPink
        
    }
    
    private func setSign(){
        Observable.combineLatest(signName.rx.text.orEmpty, signEmail.rx.text.orEmpty){
            value1, value2 in
            return "name은 \(value1)이고, 이메일은 \(value2)입니다"
        }
        .bind(to: simpleLabel.rx.text)
        .disposed(by: disposebag)
        
        signName.rx.text.orEmpty
            .map { $0.count < 4}
            .bind(to: signEmail.rx.isHidden, signButton.rx.isHidden)
            .disposed(by: disposebag)
        
        signEmail.rx.text.orEmpty
            .map { $0.count > 4}
            .bind(to: signButton.rx.isEnabled)
            .disposed(by: disposebag)
        
        signButton.rx.tap
            .subscribe { _ in
                self.showAlert()
            }
            .disposed(by: disposebag)
    }
    
    private func showAlert(){
        let alert = UIAlertController(title: "버튼 클릭", message: "클릭클릭", preferredStyle: .alert)
        let action = UIAlertAction(title: "확인", style: .default)
        alert.addAction(action)
        present(alert, animated: true)
    }
    
}
