//
//  BoxOfficeViewController.swift
//  RxSwiftPractice
//
//  Created by 홍정민 on 8/8/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class BoxOfficeViewController: UIViewController {
    private let searchBar = UISearchBar()
    private let tableView = UITableView()
    
    let viewModel = BoxOfficeViewModel()
    private let disposeBag = DisposeBag()
 
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        bind()
    }
    
    private func configureView(){
        view.backgroundColor = .white
        navigationItem.titleView = searchBar
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        tableView.register(BoxOfficeTableViewCell.self, forCellReuseIdentifier: BoxOfficeTableViewCell.identifier)
        tableView.rowHeight = 100
    }
    
    private func bind(){
        let input = BoxOfficeViewModel.Input(
            searchText: searchBar.rx.text.orEmpty,
            searchButtonTap: searchBar.rx.searchButtonClicked
        )
        
        let output = viewModel.transform(input: input)
        
        output.movieList
            .bind(to: tableView.rx.items(cellIdentifier: BoxOfficeTableViewCell.identifier, cellType: BoxOfficeTableViewCell.self)){ (row, element, cell) in
                cell.configureData(data: element)
                
            }
            .disposed(by: disposeBag)
        
    }
}
