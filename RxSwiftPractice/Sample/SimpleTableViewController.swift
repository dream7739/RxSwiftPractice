//
//  SimpleTableViewController.swift
//  RxSwiftPractice
//
//  Created by 홍정민 on 7/30/24.
//


import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class SimpleTableViewController: UIViewController {
    
    private let simpleTableView = UITableView()
    
    private let disposebag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        configureHierarchy()
        configureLayout()
        setTableView()
    }
    
    private func configureHierarchy(){
        view.addSubview(simpleTableView)
    }

    private func configureLayout(){
        simpleTableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func setTableView(){

        simpleTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        let items = Observable.just((0..<20).map { "\($0)" })
        
        items
            .bind(to: simpleTableView.rx.items(cellIdentifier: "Cell")){ (row, element, cell) in
                cell.textLabel?.text = "\(element) @row \(row)"
                cell.accessoryType = .detailButton
            }
            .disposed(by: disposebag)
        
        simpleTableView.rx
            .modelSelected(String.self)
            .subscribe { value in
                self.showAlert(title: "Tapped \(value)", content: "")
            }
            .disposed(by: disposebag)
        
        simpleTableView.rx
            .itemAccessoryButtonTapped
            .subscribe { value in
                self.showAlert(title: "Tapped \(value.section), \(value.row)", content: "")
            }
            .disposed(by: disposebag)

       
    }
    

}

