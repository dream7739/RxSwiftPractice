//
//  SignUpViewController.swift
//  RxSwiftPractice
//
//  Created by 홍정민 on 8/4/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa


class SignUpViewController: UIViewController {

    let emailTextField = SignTextField(placeholderText: "이메일을 입력해주세요")
    let descriptionLabel = UILabel()
    let validationButton = UIButton()
    let nextButton = PointButton(title: "다음")
    
    let viewModel = SignUpViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Color.white
        
        configureLayout()
        configure()
        bind()
    }
    
    func bind(){
        let input = SignUpViewModel.Input(
            tap: nextButton.rx.tap, 
            validTap: validationButton.rx.tap,
            email: emailTextField.rx.text
        )
        
        let output = viewModel.transform(input: input)
        
        viewModel.validationText
            .bind(to: descriptionLabel.rx.text)
            .disposed(by: disposeBag)
        
        
        output.validation
            .bind(with: self) { owner, value in
                let color: UIColor = value ? .systemBlue : .lightGray
                owner.nextButton.backgroundColor = color
                owner.nextButton.isEnabled = value
                owner.descriptionLabel.isHidden = value
            }
            .disposed(by: disposeBag)
        
        output.countValidation
            .bind(with: self) { owner, value in
                let color: UIColor = value ? .lightGray : .black
                owner.validationButton.isEnabled = !value
                owner.validationButton.layer.borderColor = color.cgColor
                owner.validationButton.setTitleColor(color, for: .normal)
            }
            .disposed(by: disposeBag)
        
        output.validTap
            .bind(with: self) { owner, value in
                owner.showAlert(title: "중복확인", content: "")
            }
            .disposed(by: disposeBag)
        
        output.tap
            .bind(with: self) { owner, value in
                owner.navigationController?.pushViewController(PasswordViewController(), animated: true)
            }
            .disposed(by: disposeBag)
    }
    

    func configure() {
        validationButton.setTitle("중복확인", for: .normal)
        validationButton.setTitleColor(Color.black, for: .normal)
        validationButton.layer.borderWidth = 1
        validationButton.layer.borderColor = Color.black.cgColor
        validationButton.layer.cornerRadius = 10
    }
    
    func configureLayout() {
        view.addSubview(emailTextField)
        view.addSubview(validationButton)
        view.addSubview(descriptionLabel)
        view.addSubview(nextButton)
        
        validationButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.width.equalTo(100)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.trailing.equalTo(validationButton.snp.leading).offset(-8)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(4)
            make.horizontalEdges.equalTo(view.safeAreaInsets).inset(20)
        }
        
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(emailTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
    

}
