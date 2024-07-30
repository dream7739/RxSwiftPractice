//
//  SimpleViewController.swift
//  RxSwiftPractice
//
//  Created by 홍정민 on 7/30/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class SimpleViewController: UIViewController {
    
    private let simplePickerView = UIPickerView()
    private let simpleLabel = UILabel()
    private let simpleTableView = UITableView()
    private let simpleSwitch = UISwitch()
    
    private let disposebag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        configureHierarchy()
        configureLayout()
        setPickerView()
        setTableView()
        setSwitch()
    }
    
    private func configureHierarchy(){
        
        view.addSubview(simplePickerView)
        view.addSubview(simpleLabel)
        view.addSubview(simpleTableView)
        view.addSubview(simpleSwitch)
    }

    private func configureLayout(){
        simplePickerView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        simpleLabel.snp.makeConstraints { make in
            make.top.equalTo(simplePickerView.snp.bottom).offset(2)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        simpleTableView.snp.makeConstraints { make in
            make.top.equalTo(simpleLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(130)
        }
        
        simpleSwitch.snp.makeConstraints { make in
            make.top.equalTo(simpleTableView.snp.bottom).offset(8)
            make.centerX.equalTo(view.safeAreaLayoutGuide)
        }
    
    }
    
    private func setPickerView(){
        let items = Observable.just(["영화",
                                    "애니메이션",
                                    "드라마",
                                    "기타"])
        
        items.bind(to: simplePickerView.rx.itemTitles){
            (row, element) in
            return element
        }
        .disposed(by: disposebag)
        
        simplePickerView.rx.modelSelected(String.self)
            .map { $0.description }
            .bind(to: simpleLabel.rx.text)
            .disposed(by: disposebag)
    }
    
    private func setTableView(){
        simpleTableView.backgroundColor  = .magenta

        simpleTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        let items = Observable.just([
            "First Item",
            "Second Item",
            "Third Item"
        ])
        
        items.bind(to: simpleTableView.rx.items){
          (tableView, row, element) in
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
            cell.textLabel?.text = "\(element) @row \(row)"
            return cell
        }.disposed(by: disposebag)
        
        simpleTableView.rx.modelSelected(String.self)
            .map { data in
                "\(data)를 클릭했습니다."
            }
            .bind(to: simpleLabel.rx.text)
            .disposed(by: disposebag)
    }
    
    private func setSwitch(){
        Observable.of(false)
            .bind(to: simpleSwitch.rx.isOn)
            .disposed(by: disposebag)
    }

}

