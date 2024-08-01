//
//  PasswordViewController.swift
//  RxSwiftPractice
//
//  Created by 홍정민 on 7/31/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class PasswordViewController: UIViewController {
    
    private let passwordTextField = UITextField()
    private let descriptionLabel = UILabel()
    private let nextButton = UIButton()
    
    private let validText = Observable.just("8자 이상 입력해주세요")
    
    private let disposebag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureHierarchy()
        configureLayout()
        configureUI()
        configurePassword()
    }
    
    private func configureHierarchy(){
        view.addSubview(passwordTextField)
        view.addSubview(descriptionLabel)
        view.addSubview(nextButton)
    }
    
    private func configureLayout(){
        passwordTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.top.equalTo(passwordTextField.snp.bottom)
            make.horizontalEdges.equalTo(view.safeAreaInsets).inset(20)
        }
        
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(passwordTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
            
    }
    
    private func configureUI(){
        passwordTextField.borderStyle = .roundedRect
        descriptionLabel.textColor = .systemRed
        nextButton.backgroundColor = .systemBlue
    }
    
    private func configurePassword(){
        validText
            .bind(to: descriptionLabel.rx.text)
            .disposed(by: disposebag)
        
        let validation = passwordTextField.rx.text.orEmpty
            .map { $0.count >= 8}
        
        validation
            .bind(to: nextButton.rx.isEnabled, descriptionLabel.rx.isHidden)
            .disposed(by: disposebag)
        
        validation
            .bind(with: self) { owner, value in
                let color: UIColor = value ? .systemPink : .lightGray
                owner.nextButton.backgroundColor = color
            }
            .disposed(by: disposebag)
        
        nextButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.showAlert(title: "클릭", content: "")
            }
            .disposed(by: disposebag)
    }
}

