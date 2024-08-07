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
    
    let viewModel = ShopDetailViewModel()
    
    let disposeBag = DisposeBag()
    
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
        let input = ShopDetailViewModel.Input(
            title: titleTextField.rx.text,
            navigationTap: navigationItem.rightBarButtonItem!.rx.tap
        )
        
        let output = viewModel.transform(input: input)
        
        viewModel.detailData
            .bind(to: titleTextField.rx.text)
            .disposed(by: disposeBag)
        
        output.validation
            .bind(with: self) { owner, value in
                owner.navigationItem.rightBarButtonItem?.isEnabled = value
            }
            .disposed(by: disposeBag)
        
        output.editText
            .bind(with: self, onNext: { owner, value in
                owner.viewModel.editTitleSender?(value)
                owner.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
    }
}
