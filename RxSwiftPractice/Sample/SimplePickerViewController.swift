//
//  SimplePickerViewController.swift
//  RxSwiftPractice
//
//  Created by 홍정민 on 7/30/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class SimplePickerViewController: UIViewController {
    
    private let simplePickerView1 = UIPickerView()
    private let simplePickerView2 = UIPickerView()
    private let simplePickerView3 = UIPickerView()

    private let disposebag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        configureHierarchy()
        configureLayout()
        setPickerView()
    }
    
    private func configureHierarchy(){
        
        view.addSubview(simplePickerView1)
        view.addSubview(simplePickerView2)
        view.addSubview(simplePickerView3)

    }

    private func configureLayout(){
        simplePickerView1.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        simplePickerView2.snp.makeConstraints { make in
            make.top.equalTo(simplePickerView1.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        simplePickerView3.snp.makeConstraints { make in
            make.top.equalTo(simplePickerView2.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)       
        }
      
    
    }
    
    private func setPickerView(){
        Observable.just([1, 2, 3])
            .bind(to: simplePickerView1.rx.itemTitles){
                _, item in
                return "\(item)"
            }
            .disposed(by: disposebag)
     
        simplePickerView1.rx.modelSelected(Int.self)
            .subscribe { models in
                print("models selected 1: \(models)")
            }
            .disposed(by: disposebag)
        
        Observable.just([1, 2, 3])
            .bind(to: simplePickerView2.rx.itemAttributedTitles){
                _, item in
                return NSAttributedString(string: "\(item)", attributes: [
                    .foregroundColor : UIColor.cyan,
                    .underlineStyle : NSUnderlineStyle.double.rawValue
                ])
            }
            .disposed(by: disposebag)
        
        simplePickerView2.rx.modelSelected(Int.self)
            .subscribe { models in
                print("models selected 2: \(models)")
            }
            .disposed(by: disposebag)
        
        Observable.just([UIColor.red, UIColor.green, UIColor.blue])
            .bind(to: simplePickerView3.rx.items){ _, item, _ in
                let view = UIView()
                view.backgroundColor = item
                return view
            }.disposed(by: disposebag)
        
        simplePickerView3.rx.modelSelected(UIColor.self)
            .subscribe { models in
                print("models selected 3: \(models)")
            }
            .disposed(by: disposebag)
     
    }
   
}

