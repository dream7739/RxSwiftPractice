//
//  ShopDetailViewController.swift
//  RxSwiftPractice
//
//  Created by 홍정민 on 8/2/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class ShopDetailViewController: UIViewController {
    private let titleTextField = UITextField()
    
    let detailData = BehaviorRelay(value: Shop(title: ""))
    let disposeBag = DisposeBag()
    
    var editTitleSender: ((String) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = "쇼핑 상세"
        
        configureView()
        bind()
    }
    
    private func configureView(){
        view.addSubview(titleTextField)
        titleTextField.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        titleTextField.borderStyle = .roundedRect
        
        let save = UIBarButtonItem(title: "저장")
        navigationItem.rightBarButtonItem = save
    }
    
    private func bind(){
        detailData
            .map{ $0.title }
            .bind(to: titleTextField.rx.text)
            .disposed(by: disposeBag)
        
        titleTextField
            .rx
            .text
            .orEmpty
            .bind(with: self) { owner, value in
                if value.isEmpty {
                    owner.navigationItem.rightBarButtonItem?.isEnabled = false
                }else{
                    owner.navigationItem.rightBarButtonItem?.isEnabled = true
                }
            }
            .disposed(by: disposeBag)
        
        navigationItem.rightBarButtonItem?.rx.tap
            .withLatestFrom(titleTextField.rx.text.orEmpty)
            .bind(with: self, onNext: { owner, value in
                owner.editTitleSender?(value)
                owner.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
    }
}
