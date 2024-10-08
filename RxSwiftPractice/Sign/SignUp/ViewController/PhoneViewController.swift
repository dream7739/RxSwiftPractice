//
//  PhoneViewController.swift
//  RxSwiftPractice
//
//  Created by 홍정민 on 8/1/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class PhoneViewController: UIViewController {
   
    private let phoneTextField = SignTextField(placeholderText: "연락처를 입력해주세요")
    private let descriptionLabel = UILabel()
    private let nextButton = PointButton(title: "다음")

    let viewModel = PhoneViewModel()
    
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Color.white
        
        configureLayout()
        
        bind()
    }
    
    private func bind(){
        let input = PhoneViewModel.Input(
            tap: nextButton.rx.tap,
            phone: phoneTextField.rx.text
        )
        
        let output = viewModel.transform(input: input)
        
        viewModel.phoneDescription
            .bind(to: phoneTextField.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.validationText
            .bind(to: descriptionLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.validation
            .bind(with: self) { owner, value in
                let color: UIColor = value ? .black : .gray
                owner.phoneTextField.layer.borderColor = color.cgColor
                owner.nextButton.backgroundColor = color
                owner.nextButton.isEnabled = value
                owner.descriptionLabel.isHidden = value
                
            }
            .disposed(by: disposeBag)
        
        output.tap
            .bind(with: self) { owner, _ in
                owner.navigationController?.pushViewController(BirthdayViewController(), animated: true)
            }
            .disposed(by: disposeBag)
        
    }
    
    private func configureLayout() {
        view.addSubview(phoneTextField)
        view.addSubview(nextButton)
        view.addSubview(descriptionLabel)
         
        phoneTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(phoneTextField.snp.bottom).offset(4)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(phoneTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        

    }

}

