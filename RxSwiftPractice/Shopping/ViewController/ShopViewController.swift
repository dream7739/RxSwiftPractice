//
//  ShopViewController.swift
//  RxSwiftPractice
//
//  Created by 홍정민 on 8/2/24.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit

final class ShopViewController: UIViewController {
    private let searchController = UISearchController()
    private let searchView = UIView()
    private let searchTextField = UITextField()
    private let addButton = UIButton()
    private let tableView = UITableView()
    
    let viewModel = ShopViewModel()
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = "쇼핑"
        navigationItem.searchController = searchController
        searchController.searchBar.placeholder = "키워드를 검색해보세요"
        
        configureHierarchy()
        configureLayout()
        configureUI()
        bind()
    }
    
    private func configureHierarchy(){
        view.addSubview(searchView)
        searchView.addSubview(searchTextField)
        searchView.addSubview(addButton)
        view.addSubview(tableView)
    }
    
    private func configureLayout(){
        searchView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(4)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.height.equalTo(60)
        }
        
        searchTextField.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.equalTo(44)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalTo(addButton.snp.leading).offset(-10)
        }
        
        addButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.equalTo(60)
            make.trailing.equalToSuperview().offset(-10)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchView.snp.bottom).offset(14)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func configureUI(){
        searchView.backgroundColor = .systemGray6
        searchView.layer.cornerRadius = 10
        
        searchTextField.placeholder = "무엇을 구매하실 건가요?"
        
        addButton.setTitle("추가", for: .normal)
        addButton.backgroundColor = .systemGray5
        addButton.layer.cornerRadius = 10
        addButton.setTitleColor(UIColor.black, for: .normal)
        
        tableView.register(ShopTableViewCell.self, forCellReuseIdentifier: ShopTableViewCell.identifier)
        tableView.rowHeight = 50
    }
    
    private func bind(){
        let input = ShopViewModel.Input(
            itemDelete: tableView.rx.itemDeleted,
            itemSelect: tableView.rx.itemSelected,
            modelSelect: tableView.rx.modelSelected(Shop.self),
            addTap: addButton.rx.tap,
            addText: searchTextField.rx.text,
            searchText: searchController.searchBar.rx.text
        )
        
        let output = viewModel.transform(input: input)
        
        viewModel.items
            .bind(to: tableView.rx.items(cellIdentifier: ShopTableViewCell.identifier, cellType: ShopTableViewCell.self)) { (row, element, cell) in
                cell.configureData(element)
            
                cell.checkButton.rx.tap
                    .bind(with: self) { owner, _ in
                        owner.viewModel.checkButtonClicked.accept(row)
                    }
                    .disposed(by: cell.disposeBag)
                
                cell.starButton.rx.tap
                    .bind(with: self) { owner, _ in
                        owner.viewModel.starButtonClicked.accept(row)
                    }
                    .disposed(by: cell.disposeBag)
                
            }
            .disposed(by: disposeBag)
        
        output.selectedData
            .bind(with: self) { owner, value in
                let detailVC = ShopDetailViewController()
                detailVC.viewModel.detailData.accept(value.data.title)

                detailVC.viewModel.editTitleSender = { [weak self] title in
                    self?.viewModel.data[value.idx].title = title
                    self?.viewModel.items.accept(self?.viewModel.data ?? [])
                }
                
                owner.navigationController?.pushViewController(detailVC, animated: true)
                
            }
            .disposed(by: disposeBag)
        
        
    }
}

