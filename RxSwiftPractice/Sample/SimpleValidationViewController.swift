//
//  SimpleValidationViewController.swift
//  RxSwiftPractice
//
//  Created by 홍정민 on 7/31/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

private let minimalUsernameLength = 5
private let minimalPasswordLength = 5

final class SimpleValidationViewController: UIViewController {
    
    private let usernameLabel = UILabel()
    private let username = UITextField()
    private let usernameValid = UILabel()
    private let passwordLabel = UILabel()
    private let password = UITextField()
    private let passwordValid = UILabel()
    private let signButton = UIButton()
    
    private let disposebag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        configureHierarchy()
        configureLayout()
        configureUI()
        configureValid()
    }
    
    private func configureHierarchy(){
        view.addSubview(usernameLabel)
        view.addSubview(username)
        view.addSubview(usernameValid)
        view.addSubview(passwordLabel)
        view.addSubview(password)
        view.addSubview(passwordValid)
        view.addSubview(signButton)
    }
    
    private func configureLayout(){
        usernameLabel.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        username.snp.makeConstraints { make in
            make.top.equalTo(usernameLabel.snp.bottom).offset(4)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        usernameValid.snp.makeConstraints { make in
            make.top.equalTo(username.snp.bottom).offset(4)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        passwordLabel.snp.makeConstraints { make in
            make.top.equalTo(usernameValid.snp.bottom).offset(4)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        password.snp.makeConstraints { make in
            make.top.equalTo(passwordLabel.snp.bottom).offset(4)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        passwordValid.snp.makeConstraints { make in
            make.top.equalTo(password.snp.bottom).offset(4)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        signButton.snp.makeConstraints { make in
            make.top.equalTo(passwordValid.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(44)
        }

    }
    
    private func configureUI(){
        usernameLabel.text = "Username"
        username.borderStyle = .roundedRect
        usernameValid.textColor = .systemRed
        
        passwordLabel.text = "Password"
        password.borderStyle = .roundedRect
        passwordValid.textColor = .systemRed
        
        signButton.setTitle("Do something", for: .normal)
        signButton.backgroundColor = .systemGreen
        
        usernameValid.text = "Username has to be at least \(minimalUsernameLength) characters"
        passwordValid.text = "Password has to be at least \(minimalPasswordLength) characters"
    }
    
    private func configureValid(){
        let usernameIsValid = username.rx.text.orEmpty
            .map { $0.count >= minimalUsernameLength }
            .share(replay: 1)
        
        let passwordIsValid = password.rx.text.orEmpty
            .map { $0.count >= minimalPasswordLength }
            .share(replay: 1)
        
        let everythingValid = Observable.combineLatest(usernameIsValid, passwordIsValid){ $0 && $1}
            .share(replay: 1)
        
        usernameIsValid
            .bind(to: password.rx.isEnabled)
            .disposed(by: disposebag)
        
        usernameIsValid
            .bind(to: usernameValid.rx.isHidden)
            .disposed(by: disposebag)
        
        passwordIsValid
            .bind(to: passwordValid.rx.isHidden)
            .disposed(by: disposebag)
        
        everythingValid
            .bind(to: signButton.rx.isEnabled)
            .disposed(by: disposebag)
        
        signButton.rx.tap
            .subscribe(with: self) { owner, _ in
                owner.showAlert(title: "클릭", content: "클릭")
            }
            .disposed(by: disposebag)
    }
    
    
}
