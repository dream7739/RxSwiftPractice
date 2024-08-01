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

    private let phoneData = BehaviorRelay(value: "010")
    
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Color.white
        
        configureLayout()
        
        bind()
    }
    
    private func bind(){
        phoneData
            .bind(to: phoneTextField.rx.text)
            .disposed(by: disposeBag)
        
        phoneTextField.rx.text
            .orEmpty
            .map { $0.count >= 10}
            .bind(with: self) { owner, value in
                let color: UIColor = value ? .black : .gray
                owner.phoneTextField.layer.borderColor = color.cgColor
                owner.nextButton.backgroundColor = color
                owner.nextButton.isEnabled = value
                owner.descriptionLabel.isHidden = value
                
            }
            .disposed(by: disposeBag)
        
        nextButton.rx.tap
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
        
        descriptionLabel.text = "전화번호는 10자리 이상이어야 합니다"

    }

}

