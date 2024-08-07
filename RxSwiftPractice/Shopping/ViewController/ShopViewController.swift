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
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())
    private let tableView = UITableView()
    
    static func layout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 120, height: 35)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        layout.scrollDirection = .horizontal
        return layout
    }
    
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
        view.addSubview(collectionView)
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
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(searchView.snp.bottom).offset(14)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(40)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom).offset(14)
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
        
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(ShopCollectionViewCell.self, forCellWithReuseIdentifier: ShopCollectionViewCell.identifier)
    }
    
    private func bind(){
        let checkButtonClicked = PublishRelay<Int>()
        let starButtonClicked = PublishRelay<Int>()
        let modifyTitle = PublishRelay<(Int, String)>()
        
        let input = ShopViewModel.Input(
            checkButtonClicked: checkButtonClicked,
            starButtonClicked: starButtonClicked,
            itemDelete: tableView.rx.itemDeleted,
            itemSelect: tableView.rx.itemSelected,
            modelSelect: tableView.rx.modelSelected(Shop.self),
            recommendItemSelect: collectionView.rx.itemSelected,
            recommendModelSelect: collectionView.rx.modelSelected(String.self),
            modifyTitle: modifyTitle,
            addTap: addButton.rx.tap,
            addText: searchTextField.rx.text,
            searchText: searchController.searchBar.rx.text
        )
        
        let output = viewModel.transform(input: input)
        
        //tableView
        output.items
            .bind(to: tableView.rx.items(cellIdentifier: ShopTableViewCell.identifier, cellType: ShopTableViewCell.self)) { (row, element, cell) in
                cell.configureData(element)
                
                cell.checkButton.rx.tap
                    .bind(with: self) { owner, _ in
                        input.checkButtonClicked.accept(row)
                    }
                    .disposed(by: cell.disposeBag)
                
                cell.starButton.rx.tap
                    .bind(with: self) { owner, _ in
                        input.starButtonClicked.accept(row)
                    }
                    .disposed(by: cell.disposeBag)
                
            }
            .disposed(by: disposeBag)
        
        //tableView itemSelect modelSelect
        output.selectedData
            .bind(with: self) { owner, value in
                let detailVC = ShopDetailViewController()
                detailVC.viewModel.detailData.accept(value.data.title)
                
                detailVC.viewModel.editTitleSender = { title in
                    input.modifyTitle.accept((value.idx, title))
                }
                
                owner.navigationController?.pushViewController(detailVC, animated: true)
                
            }
            .disposed(by: disposeBag)
        
        //collectionView
        output.recommendData.bind(to: collectionView.rx.items(cellIdentifier: ShopCollectionViewCell.identifier, cellType: ShopCollectionViewCell.self)){ (row, element, cell) in
            cell.titleLabel.text = element
        }
        .disposed(by: disposeBag)
        
        
    }
}

